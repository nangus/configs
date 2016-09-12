#!/bin/bash

function helpMe {
    clear
    printf "
    ---------------------------------------------------
    $(basename $0) -- Help
    ---------------------------------------------------

    DESCRIPTION:
        $(basename $0) is a script to scan git repos for instances of a pattern

    SYNTAX:
        $(basename $0) [-u <user>] [-t <token>] [-o '<orgs>'] [-p <pattern>] [-D][-h]

    SAMPLE:
        $(basename $0)   
        $(basename $0) -o 'dsqa data dstools'
        $(basename $0) -u 'jyanko' -t 'xxxxxxxxx' -o 'dsqa' -p '(atti|attinteractive).com'

    OPTIONS:
        -D             enable debug messages
        -h             view this help
        -u <user>      provide username for github as argument
        -t <token>     provide token    for github as argument
        -o '<orgs>'    provide space delim list of orgs as quoted argument
        -p '<pattern>' provide regex pattern as argument

        " | tr -d "\t" 

        exit

}




function error {
    echo "[error] $1"
    jtlClose  # close the results file since we're exitting now
    exit 1  
}

function warningMessage {
    echo "[warning] $1"
}


function debugMessage {
    if [ ${DEBUG} = "true" ];then
        echo "[debug] $1"
    fi
}

function scanForPattern {

    #
    # test to compare count of found atti occurances against allowed count of occurances.
    #
    CLASSNAME="${FUNCNAME}"
    TESTNAME="${GIT_ORG}.${GIT_REPO}"      # repo to be scanned
    MAXCOUNT=0                              # max occurances of atti dot com or attinteractive dot com to allow

    debugMessage "[${FUNCNAME}] processing :: ${REPO_NAME}"

    STARTING_DIR="$PWD"

    debugMessage "[START] $TESTNAME"
    # check for domains only if the clone succeeded
    if [ ${CLONE_SUCCESS} = "true" ];then
        cd ${GIT_REPO}                            || error "cd into git clone failed" 

        # scan repo for atti dot com or attinteractive dot com and report
        MATCHING_FILES_FOUND=$(git grep -cEI "$PATTERN")
        COUNT_ATTI_FOUND=$(git grep -cEI "$PATTERN" | wc -l | tr -d ' ')

        echo "$COUNT_ATTI_FOUND ^ ${GIT_ORG}/${GIT_REPO} ^ ${BRANCH}" >> $TMP_LOG

        # check for count of atti matches
        if [ $COUNT_ATTI_FOUND -gt $MAXCOUNT ];then
            debugMessage "-> $COUNT_ATTI_FOUND is greater than $MAXCOUNT"
                SUCCEED="false"
        else
            debugMessage "-> $COUNT_ATTI_FOUND is not greater than $MAXCOUNT"
            SUCCEED="true"
        fi

        MSG_PASSING="<testcase classname=\"$CLASSNAME\" name=\"$TESTNAME\" />"
        MSG_FAILING="<testcase classname=\"$CLASSNAME\" name=\"$TESTNAME\"><failure> $COUNT_ATTI_FOUND files found with atti occurances ($MAXCOUNT allowed)</failure> <system-out>$MATCHING_FILES_FOUND</system-out> </testcase>"

        debugMessage "-> Succeed : $SUCCEED"
        debugMessage "-> MsgPass : $MSG_PASSING"
        debugMessage "-> MsgFail : $MSG_FAILING"

        jtlWriteTestResult

        debugMessage "[DONE] $TESTNAME"

    fi
}

function cloneRepo {

    GIT_ORG="${ORG}"
    GIT_REPO="${REPO_NAME}"

    debugMessage "========================================================================"
    debugMessage "[${FUNCNAME}] processing :: ${GIT_ORG}/${GIT_REPO}"
    debugMessage "-> ${GITROOT}:${GIT_ORG}/${GIT_REPO}.git"
    debugMessage "========================================================================"
    git clone --depth 1 ${GITROOT}:${GIT_ORG}/${GIT_REPO}.git && CLONE_SUCCESS="true" || CLONE_SUCCESS="false"

    if [ ${CLONE_SUCCESS} = "false" ];then
        warningMessage "git clone failed"       # Make a clone of the repository
        CLASSNAME="${FUNCNAME}"
        TESTNAME="${GIT_ORG}/${GIT_REPO}" 
        SUCCEED="false"
        MSG_FAILING="<testcase classname=\"$CLASSNAME\" name=\"$TESTNAME\"><failure> git clone repo failure </failure></testcase>"
        jtlWriteTestResult # send result to jtl file
    fi

}

function scanThroughOrgs {
    jtlOpen # open results jtl file

    for ORG in ${ARRAY_ORGS[*]};do
        ARRAY_REPOS=( $(curl --max-time 10 -s -i -u ${USERNAME}/token:${TOKEN} \
            "${GITHUBURL}/api/v2/xml/repos/show/${ORG}" \
            | grep '<name>' \
            | perl -pe 's/(.*<name>)(.*)(<\/name>.*)/\2/gi;' ) 
        )
        
        echo "Count ^ Repo ^ Branch" > $TMP_LOG
        test -d $TMP_DIR || mkdir -p $TMP_DIR
        cd $TMP_DIR
        debugMessage "[main] -> PWD        : $(pwd)"
        debugMessage "[main] -> ARRAY COUNT: ${#ARRAY_REPOS[*]}"
# report and exit if it appears no repos were captured
        if [ ${#ARRAY_REPOS[*]} -lt "1" ];then
            error "failed to capture repos from github api"
        fi

        # process repos in array
        for REPO_NAME in ${ARRAY_REPOS[*]};do
            debugMessage "[main] -> process $ORG/$REPO_NAME"
            # call function to clone repo into current dir
            cloneRepo
            # call function to scan repo for atti domains
            scanForPattern
            # remove the temp cloned repo
            cd "$STARTING_DIR" && rm -rf ${GIT_REPO}  || error "removing clone failed"  # Remove our temporary local repository
        done

        echo "========================================================================"
        echo "RESULTS"
        echo "========================================================================"
        cat $TMP_LOG | column -t -s '^'
    done
    jtlClose # close results jtl file
}

function jtlOpen {
    debugMessage "enter jtlOpen{}"
    echo                                 > $OUTPUT_JTL
    echo "    <testsuite tests=\"$1\">" >> $OUTPUT_JTL
}


function jtlWriteTestResult {
    debugMessage "enter jtlWriteTestResult{}"
    debugMessage "-> Succeed : $SUCCEED"
    if [ $SUCCEED = "false" ];then
        debugMessage "-> succeed is false condition"
        echo "         $MSG_FAILING" >> $OUTPUT_JTL
    else
        debugMessage "-> succeed is true condition"
        echo "         $MSG_PASSING" >> $OUTPUT_JTL
    fi

}

function jtlClose {
    debugMessage "enter jtlClose{}"
    echo "    </testsuite>" >> $OUTPUT_JTL
    echo                    >> $OUTPUT_JTL
}

################################################################################
#
#  START SCRIPT RUN
#
################################################################################
DEBUG="false"
GITHOSTNAME="git.corp.attinteractive.com"
GITROOT="git@${GITHOSTNAME}"
GITHUBURL="https://${GITHOSTNAME}"
BRANCH=master
WORKSPACE=$(pwd)
OUTPUT_JTL="${WORKSPACE}/results.jtl"
TMP_DIR=$(mktemp -d ${WORKSPACE}/temp-XXXXXX)
TMP_LOG=${TMP_DIR}.log
PATTERN='(atti|attiinteractive).com'    # define default regex pattern 
ARRAY_ORGS=( dsqa )                     # define default orgs to scan

# collect possible input parameters...
while getopts "t:u:o:p:Dh" OPTION
do
    case $OPTION in
        D ) DEBUG="true" ;;
        h ) helpMe ;;
        u ) USERNAME=$OPTARG ;;
        t ) TOKEN=$OPTARG ;;
        o ) ARRAY_ORGS=$OPTARG ;;
        p ) PATTERN=$OPTARG ;;
    esac
done

debugMessage "DEBUG        $DEBUG"
debugMessage "USERNAME     $USERNAME"
debugMessage "TOKEN        $TOKEN"
debugMessage "ARRAY_ORGS   $ARRAY_ORGS"
debugMessage "PATTERN      $PATTERN"

echo "Will scan repos found in the following orgs"
for ORG in ${ARRAY_ORGS[*]};do
echo "[org] $ORG"
done


# call function to scan through all defined orgs in the array
scanThroughOrgs


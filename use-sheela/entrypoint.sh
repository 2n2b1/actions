#!/bin/sh

# Sheela, used to setup the base (branches, etc)
# before dev-work and after dev-work
# into merging with master.
# Defaults:
{
    set -e
    newbranch=""
    patch=""
    featureName=""
    featurePRBranch=""
    useName=""

    createFlag=false;
    pullRequestFlag=false;
    deployFlag=false;

    dockerName=""
    dockerFlag=false;
    showHelp=false;

    while getopts "c:d:r:n:h" opt; do
        case $opt in
            c | create ) createFlag=true; featureName=$OPTARG;; ## create a new deployment branch
            d | deploy ) deployFlag=true; deployBranch=$OPTARG;; ## deploy a new deployment branch
            k | docKer ) dockerFlag=true; dockerName=$OPTARG;; ## dockerize a new action branch
            n | name ) useName=$OPTARG;; ## name
            r | pullrequest ) pullRequestFlag=true; featureName=$OPTARG;;
            h | help ) showHelp=true;;
            \? ) echo "Unknown option: -$OPTARG" >&2; exit 127;;
             : ) echo "Missing option argument for -$OPTARG" >&2; exit 127;;
             * ) echo "Invalid option -$OPTARG" >&2; exit 127;;
        esac
    done

    if $showHelp;
    then
        echo "Commands: ";
        exit 0;
    fi

    if $createFlag;
    then
        echo "Create a new dev branch and such. Name: $featureName";
        git=$(which git);
        gitcore=$($git --exec-path)
        output=$(/bin/sh -c "true \
                    && $gitcore/git-checkout -B add-feature-$featureName --track origin/master \
                    && mkdir -p ./use-$featureName");
        echo "$output"
        exit 0;
    fi

    if $dockerFlag;
    then
        # translate all .sh entryfiles to DOCKERFILES.
        # FROM alpine
        # ADD entrypoint.sh /bin/
        # RUN chmod +x /bin/script.sh
        # RUN apk -Uuv add curl ca-certificates
        # ENTRYPOINT /bin/script.sh
        # ---> ./action/use-vpn: has {entrypoint.sh}
        # --->  this will translate that into Dockerfile
        # --->  (pointing at entrypoint.sh)
        # --->  (and publish it into the repo of your choice)
        exit 0;
    fi

    if $pullRequestFlag;
    then
        echo "Create a new pull request.";
        exit 0;
    fi

    if $deployFlag;
    then
        echo "Create a new deploy request.";
        exit 0;
    fi

    # New Feature Dev Branch
    # git checkout --orphan add-feature-$featureName

    # Setup for Pull Request / Merge
    # git checkout master
    # git pull
    # git checkout -b master-pull-request-1
    # git diff master add-feature-action-hooks > ../patchfile.1
    # git format-patch $(git merge-base --fork-point master-pull-request-1)
    # git apply -3
    # if doesn't take:
    # git merge add-feature-action-hooks --squash --allow-unrelated-histories --progress

    # Push out new merged branch
    # git push --set-upstream origin $featurePRBranch

    echo "Try using:\n$_ -h  \n\tor\n$_ help";
    exit 0;

} || echo "Problem with Sheela. Error: $!"; exit 1;

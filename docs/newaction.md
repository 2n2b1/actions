## Actions

### Format
>
    [runner] [actions-repo] [folder] entrypoint.sh [action-type] [optional arguments]   


Ideally it should look like this ..
>
    run actions\use-file-cleaner entrypoint.sh *.sh

What I'd like to get it down to...
>
    run actions\use-file-cleaner *.sh


#### New Action
>
    setup [actions-repo] [action-name] [default-program] [optional: linkto=[additional-repo-link]]

will create:
1) empty GitHub repo within actions repo.
1) README.md documentation file.
1) if source, set source and build image using source and 
1) if linkto, set additional repo linked as folder.

Raw Actions:
>
    git checkout --orphan feature-[new-action-name]

Ideally I'd like to get this to be..
>
    setup new [action-name] 

#### Tools - Add-Ins
Git Large File storage
>
    git lfs install
    git lfs track "*.tar"
    git add .gitattributes
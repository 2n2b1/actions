# Hooks Folder

### Action taken upon commit
A call is placed to 'jt-hooker' automatically.
>
    actions/use-jt-hooker

Which will move the .hook.sh files to just the action name. (Per Git's requirements);
so..

>
    .hooks/update.hook.sh   
becomes...
>
    .hooks/update

## No action is necessary on your part to do this.
## Why?
Mostly this has to be with linting, shellcheck, and running these hooks on a local system.
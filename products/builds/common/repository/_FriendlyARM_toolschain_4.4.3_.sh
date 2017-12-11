#!/bin/bash
#Copyright (c) 2017.  jielong.lin@qq.com, 2017-12-10,12:12:20,  All rights reserved.
#Author:   JLLim (jielong.lin@qq.com) 
#Email:    jielong.lin@qq.com
#

###
### Generate a sourcable .env4toolschain.sh
###

PathFileForScript="`which $0`"
if [ x"${PathFileForScript}" != x ]; then
    ScriptName=${PathFileForScript##*/}
    ScriptPath=${PathFileForScript%/*}
    if [ x"${ScriptPath}" = x ]; then
        ScriptPath="$(pwd)"
    else
        if [ -e "${ScriptPath}" ]; then
            ScriptPath="$(cd ${ScriptPath};pwd;cd - >/dev/null)"
        else
            echo
            echo "JLLim..| Not obtain Script Path, then exit"
            echo
            [ x"${PathFileForScript}" != x ] && unset PathFileForScript
            [ x"${ScriptName}" != x ] && unset ScriptName
            [ x"${ScriptPath}" != x ] && unset ScriptPath
            exit 0 
        fi
    fi
    if [ x"${ScriptName}" = x ]; then
        echo
        echo "JLLim..| Not recognize the command \"$0\", then exit - 0"
        echo
        [ x"${PathFileForScript}" != x ] && unset PathFileForScript
        [ x"${ScriptName}" != x ] && unset ScriptName
        [ x"${ScriptPath}" != x ] && unset ScriptPath
        exit 0
    fi
else
    echo
    echo "JLLim..| Not recognize the command \"$0\", then exit - 1"
    echo
    [ x"${PathFileForScript}" != x ] && unset PathFileForScript
    [ x"${ScriptName}" != x ] && unset ScriptName
    [ x"${ScriptPath}" != x ] && unset ScriptPath
    exit 0
fi
[ x"${PathFileForScript}" != x ] && unset PathFileForScript

if [ x"$1" = x -o ! -e "$1" ]; then
    echo
    echo "JLLim..| Please check parameters for ${ScriptName}"
    echo
    [ x"${PathFileForScript}" != x ] && unset PathFileForScript
    [ x"${ScriptName}" != x ] && unset ScriptName
    [ x"${ScriptPath}" != x ] && unset ScriptPath
    exit 0
fi

_toolschain_sdk_="${ScriptPath}/FriendlyARM_toolschain_4.4.3.tgz"
_toolschain_rt_="${ScriptPath}/../toolschain"
_toolschain_="${_toolschain_rt_}/FriendlyARM/toolschain/4.4.3/bin"

if [ ! -e "${_toolschain_}" ]; then
    mkdir -pv ${_toolschain_}
fi


function _common_Exit_0()
{
    echo "JLLim..| Exit 0 from ${ScriptName}"
    [ x"${_toolschain_sdk_}" != x ] && unset _toolschain_sdk_
    [ x"${_toolschain_}" != x ] && unset _toolschain_
    [ x"${ScriptName}" != x ] && unset ScriptName
    [ x"${ScriptPath}" != x ] && unset ScriptPath

    exit 0
}


echo
echo "JLLim.S| Build _toolschain_=${_toolschain_}"
echo
if [ ! -e "${_toolschain_}" -o x"$(ls ${_toolschain_} 2>/dev/null)" = x ]; then 
    echo "JLLim..| Not found \"${_toolschain_}\", trying to build it..."
    if [ ! -e "${_toolschain_sdk_}" ]; then
        echo "JLLim..| Error: Not found \"${_toolschain_sdk_}\""
        _common_Exit_0
    fi
    tar -zvxf ${_toolschain_sdk_} -C ${_toolschain_rt_}
    if [ ! -e "${_toolschain_}" -o x"$(ls ${_toolschain_} 2>/dev/null)" = x ]; then 
        echo "JLLim..| Not found \"${_toolschain_}\""
        echo "JLLim..| Error: Can not install toolschain for arm linux"
        _common_Exit_0
    fi
fi
_toolschain_="$(cd ${_toolschain_} >/dev/null;pwd;cd - >/dev/null)"
echo "JLLim.E| Build _toolschain_=${_toolschain_}"
echo

_CHK_="$(echo "${PATH}" | grep -i "${_toolschain_}" 2>/dev/null)"
if [ x"${_CHK_}" = x ]; then
    echo  "JLLim..| output ${_toolschain_}"
    echo  "export PATH=\${PATH}:${_toolschain_}" >$1/.env4toolschain.sh
    echo  "JLLim..| create $1/.env4toolschain.sh"
    echo
fi
[ x"${_CHK_}" != x ] && unset _CHK_
[ x"${_toolschain_sdk_}" != x ] && unset _toolschain_sdk_
[ x"${_toolschain_}" != x ] && unset _toolschain_
[ x"${ScriptName}" != x ] && unset ScriptName
[ x"${ScriptPath}" != x ] && unset ScriptPath


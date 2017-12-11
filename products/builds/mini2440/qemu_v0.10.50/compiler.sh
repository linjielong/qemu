#!/bin/bash
# Copyright(c) 2016-2100.   jielong.lin.  All rights reserved.
#
#   FileName:     compiler.sh
#   Author:       JLLim (jielong.lin) 
#   Email:        jielong.lin@qq.com
#   DateTime:     2017-12-10 17:03:15
#   ModifiedTime: 2017-12-11 02:01:51
#
# Revision:
#     Warning: Compiling Qemu without using arm toolschain,
#              Because the Qemu will be run in Intel platform. 
#


if [ 1 -eq 0 ]; then

# it will be used to build the toolschain and generate .env4toolschain.sh
_toolschain_cmd_="../../common/repository/_FriendlyARM_toolschain_4.4.3_.sh"

# it will tell build system to create .env4toolschain.sh in where
_toolschain_=$(pwd)





##########################################################################
# Not change about toolschain
##########################################################################

if [ ! -e "${_toolschain_cmd_}" ]; then
    echo
    echo "JLLim..| not found ${_toolschain_cmd_}"
    echo
    exit 0
fi

# Not change the below _toolschain_env_
_toolschain_env_=.env4toolschain.sh


[ -e "${_toolschain_}/${_toolschain_env_}" ] \
    && rm -rf ${_toolschain_}/${_toolschain_env_}

# _toolschain_env_ will be generated under ${_toolschain_}
eval "${_toolschain_cmd_}" "${_toolschain_}"
if [ ! -e "${_toolschain_}/${_toolschain_env_}" ]; then
    echo
    echo "JLLim..| Error: Not found toolschain from"
    echo "         ${_toolschain_}/${_toolschain_env_}"
    echo
    exit 0
fi

source ${_toolschain_}/${_toolschain_env_}

echo "-------- PATH ----------"
echo $PATH
echo

echo "Testing..."
which arm-linux-gcc
echo
echo

[ x"${_toolschain_}" != x ] && unset _toolschain_
[ x"${_toolschain_cmd_}" != x ] && unset _toolschain_cmd_
[ x"${_toolschain_env_}" != x ] && unset _toolschain_env_

fi  # END OF if [ 1 -eq 0 ]; then



##########################################################################
# Customize YOUR compiled task
#-------------------------------------------------------------------------
#
# qemu
# ├── products
# │   ├── builds
# │   │   ├── common
# │   │   │   ├── repository
# │   │   │   └── toolschain
# │   │   ├── mini2440
# │   │   │   ├── linux_v2.6
# │   │   │   ├── qemu_v0.10.50 ---------------> (compiled script)
# │   │   │   ├── sample4project               |
# │   │   │   └── uboot_v1.1.5                 |
# │   │   └── readme4build                     |
# │   └── mini2440                             |
# │       ├── for_linux                        |
# │       │   └── v201712101626 <--- (output)  |
# │       │       └── qemu         |           |
# │       │           └── v0.10.50 |           |
# │       └── for_windows          |           |
# ├── readme                     __|           |
# └── repository                /              |
#     └── mini2440             /               |
#         ├── linux           /                |
#         │   └── v2.6       /                 |
#         ├── qemu          /                  |
#         │   └── v0.10.50  <-------------------- (source code)
#         └── uboot
#             └── v1.1.5
#
##########################################################################
_version_="$(pwd)"
_version_="${_version_##*/}"
_version_="v${_version_##*_v}"
if [ x"${_version_}" = x -o y"$(pwd | grep ${_version_})" = y ]; then
    echo
    echo "JLLim..| Not obtain version"
    echo
    exit 0
fi
echo "JLLim..| _version_=${_version_}"

_project_="$(pwd)"
_project_="${_project_##*/}"
_project_="${_project_%_v*}"
if [ x"${_project_}" = x -o y"$(pwd | grep ${_project_})" = y ]; then
    echo
    echo "JLLim..| Not obtain project name"
    echo
    [ x"${_version_}" != x ] && unset _version_
    exit 0
fi
echo "JLLim..| _project_=${_project_}"

_platform_="$(pwd)"
_platform_="${_platform_%/${_project_}_${_version_}*}"
_platform_="${_platform_##*/}"
if [ x"${_platform_}" = x -o y"$(pwd | grep ${_platform_})" = y ]; then
    echo
    echo "JLLim..| Not obtain platform name"
    echo
    [ x"${_project_}" != x ] && unset _project_
    [ x"${_version_}" != x ] && unset _version_
    exit 0
fi
echo "JLLim..| _platform_=${_platform_}"

_dt_="v$(date +%Y%m%d%H%M)"
_source_code_="$(pwd)/../../../../repository/${_platform_}/${_project_}/${_version_}"
_for_OS_="for_linux"
_out_="$(pwd)/../../../${_platform_}/${_for_OS_}/${_dt_}/${_project_}/${_version_}"
_env4qemu_="$(pwd)/../../../${_platform_}/${_for_OS_}/env4qemu"

_log_="${_out_##*${_for_OS_}}"
_log_="LOG.${_for_OS_}${_log_//\//_}"


function _compile_unset()
{
    [ x"${_version_}" != x ] && unset _version_
    [ x"${_project_}" != x ] && unset _project_
    [ x"${_platform_}" != x ] && unset _platform_
    [ x"${_source_code_}" != x ] && unset _source_code_
    [ x"${_for_OS_}" != x ] && unset _for_OS_
    [ x"${_out_}" != x ] && unset _out_
    [ x"${_log_}" != x ] && unset _log_
    [ x"${_env4qemu_}" != x ] && unset _env4qemu_
}

function _compile_exit_0()
{
    _compile_unset
    exit 0
}

_choice_=y
if [ -e "${_env4qemu_}" ]; then
    echo
    echo "JLLim..| Qemu has been present ..."
    read -n 1 -p "JLLim..| Rebuilding Qemu if press [y], or skip:   " _choice_
    echo
fi

if [ x"${_choice_}" = x"y" ]; then

    if [ ! -e "${_source_code_}" ]; then
        echo "JLLim..| not found ${_source_code_}"
        _compile_exit_0
    fi

    if [ -e "${_out_}" ]; then
        rm -rf ${_out_}
    fi

    mkdir -pv ${_out_}
    
    #>${_log_}
    echo "#/bin/bash" >${_env4qemu_}
    echo "#Copyright(c) 2017-2100.  jielong.lin.   All rights reserved." >>${_env4qemu_}
    echo "#Created Time: $(date +%Y-%m-%d\ %H:%M:%S)"                    >>${_env4qemu_}

    cd ${_source_code_}
    ./configure --target-list=arm-softmmu --prefix=${_out_}
    make
    make install
    cd - >/dev/null

    if [ -e "${_out_}/bin/qemu-system-arm" ]; then
        cd ${_source_code_}
        make clean
        cd - >/dev/null
        echo
        echo "JLLim..| Succeed to build qemu for mini2440:"
        echo "  out= ${_out_}"
        echo "JLLim..| Generated:"
        echo "         ${_env4qemu_}"
        echo                                                                     >>${_env4qemu_}
        echo "if [ -e \"$(cd ${_out_}/bin;pwd;cd - >/dev/null)\" ]; then"        >>${_env4qemu_}
        echo "    export PATH=$(cd ${_out_}/bin;pwd;cd - >/dev/null):\\\${PATH}" >>${_env4qemu_}
        echo "else"                                                              >>${_env4qemu_}
        echo "    if [ x\"\${_QEMU_PRODUCT_}\" != x -a -e \"\${_QEMU_PRODUCT_}\" ]; then" \
                                                                                 >>${_env4qemu_}
        echo "        export PATH=\${_QEMU_PRODUCT_}/${_platform_}/${_for_OS_}/${_dt_}/${_project_}/${_version_}/bin:\\\${PATH}"  >>${_env4qemu_}
        echo "    else"                                                          >>${_env4qemu_}
        echo "        echo \"Please set _QEMU_PRODUCT_\""                        >>${_env4qemu_}
        echo "        echo \"  For Example:\" "                                  >>${_env4qemu_}
        echo "        echo \"  _QEMU_PRODUCT_=$(cd ./../../../;pwd;cd - >/dev/null)\""     \
                                                                                 >>${_env4qemu_}
        echo "    fi"                                                            >>${_env4qemu_}
        echo "fi"                                                                >>${_env4qemu_}
        echo                                                                     >>${_env4qemu_}
        echo
    else
        echo
        echo "JLLim..| Failed to build qemu for mini2440"
        echo
        rm -rf ${_env4qemu_}
        rm -rf ${_out_}
    fi

fi

_compile_unset


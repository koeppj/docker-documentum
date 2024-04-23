#/bin/bash
. ~/.env
echo "exec" | idql $DM_DOCBASE_NAME -Udmadmin 1> /dev/null 2>/dev/null || exit 1
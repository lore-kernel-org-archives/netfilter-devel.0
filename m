From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [RFC nftables PATCH] nft: add bash completion script
Date: Fri,  5 Feb 2016 17:53:02 +0100
Message-ID: <1454691182-6573-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38708 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcBEQxH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2016 11:53:07 -0500
Received: by mail-wm0-f41.google.com with SMTP id p63so35465749wmp.1
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Feb 2016 08:53:06 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch adds a bash completion script
which permits to complete nft commands.

To install it:
- cp files/nft-completion /etc/bash_completion.d/
- . /etc/bash_completion.d/nft-completion

The following commands are supported:
- nft add table <family> <name>
- nft list table <family> <name>
- nft list tables
- nft list sets
- nft list chains
- nft list ruleset
- nft list set <table> <name>
- nft add set <table> <name>
- nft add element <table> <set>
- nft add map <table>
- nft flush table <family> <table>

Most probably this won't work with sudo, since there
are some nft commands into the script.

A second patch to add completion in interactive mode
will come.

This is only a draft,
any feedback is appreciated.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 files/nft-completion | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 files/nft-completion

diff --git a/files/nft-completion b/files/nft-completion
new file mode 100644
index 0000000..c138312
--- /dev/null
+++ b/files/nft-completion
@@ -0,0 +1,60 @@
+_nft()
+{
+    local cur prev
+    COMPREPLY=()
+    cur="${COMP_WORDS[COMP_CWORD]}"
+    prev="${COMP_WORDS[COMP_CWORD-1]}"
+
+    local families="ip ip6 arp bridge inet netdev"
+    local sets=$(nft list sets | grep -i "set" | awk '{print $2 }' | tr -d ' ')
+
+    if [ $COMP_CWORD -eq 1 ]; then
+        COMPREPLY=( $(compgen -W "add flush list" -- $cur) )
+    elif [ $COMP_CWORD -eq 2 ]; then
+        case "$prev" in
+            "add")
+                command="${prev}"
+                COMPREPLY=( $(compgen -W "element map table set" -- $cur) )
+                ;;
+            "list")
+                COMPREPLY=( $(compgen -W "chains ruleset set sets table tables" -- $cur) )
+                ;;
+            "flush")
+                COMPREPLY=( $(compgen -W "table" -- $cur) )
+                ;;
+            *)
+                ;;
+        esac
+    elif [ $COMP_CWORD -eq 3 ]; then
+        case "$prev" in
+            "table")
+                COMPREPLY=( $(compgen -W "${families}" -- $cur) )
+                ;;
+            "set"|"element"|"map")
+                local tables=$(nft list tables | awk '{print $3 }' | tr -d ' ')
+                COMPREPLY=( $(compgen -W "${tables}" -- $cur) )
+                ;;
+            *)
+                ;;
+        esac
+    elif [ $COMP_CWORD -eq 4 ]; then
+        local tables=$(nft list tables | awk '{print $3 }' | tr -d ' ')
+        if [[ "$families" =~ "$prev" ]]; then 
+            local tables=$(nft list tables "${prev}" | awk '{print $3 }' | tr -d ' ')
+            COMPREPLY=( $(compgen -W "${tables}" -- $cur) )
+        fi
+
+        if [ "${COMP_WORDS[1]}" != "add" ] && [[ "$tables" =~ "$prev" ]]; then
+            COMPREPLY=( $(compgen -W "${sets}" -- $cur) )
+        fi
+
+        if [ "${COMP_WORDS[1]}" == "add" ] && [ "${COMP_WORDS[2]}" == "element" ] && [[ "$tables" =~ "$prev" ]]; then
+            COMPREPLY=( $(compgen -W "${sets}" -- $cur) )
+        fi
+    fi
+
+    return 0;
+}
+
+complete -F _nft nft
+
-- 
2.5.0


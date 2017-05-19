From: Oliver Ford <ojford@gmail.com>
Subject: [PATCH v4 1/1] iptables: Fix crash on malformed iptables-restore
Date: Fri, 19 May 2017 11:22:36 +0000
Message-ID: <1495192956-9207-1-git-send-email-ojford@gmail.com>
Cc: Oliver Ford <ojford@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35857 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbdESLWn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 07:22:43 -0400
Received: by mail-wm0-f68.google.com with SMTP id k15so16387041wmh.3
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 04:22:42 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes the crash reported in Bugzilla #1131 where a malformed parameter that
specifies the table option during a restore can create an invalid pointer.
It was discovered during fuzz testing that options like '-ftf'
can cause a segfault. A parameter that includes a 't' is not currently
filtered correctly.

Improves the filtering to:
Filter a beginning '-' followed by a character other than '-' and then a 't'
anywhere in the parameter. This filters parameters like '-ftf'.
Filter '--table', stopping when the parameter length is reached. Because the
getopt_long function allows abbreviations, any unique abbreviation of '--table'
will be treated as '--table'. This filters parameters like '--t', '--ta', but not
'--ttl' or '--target'.

Signed-off-by: Oliver Ford <ojford@gmail.com>
---
 iptables/ip6tables-restore.c | 5 +++--
 iptables/iptables-restore.c  | 5 +++--
 iptables/iptables-xml.c      | 6 +++---
 iptables/xtables-restore.c   | 5 +++--
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 39a881d..98e9c5f 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -165,8 +165,9 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-                            || !strncmp(param_buffer, "--table", 8)) {
+			if ((param_buffer[0] == '-' && param_buffer[1] != '-' &&
+				strchr(param_buffer, 't')) ||
+				!strncmp(param_buffer, "--table", strlen(param_buffer))) {
 				xtables_error(PARAMETER_PROBLEM,
 				"The -t option (seen in line %u) cannot be "
 				"used in ip6tables-restore.\n", line);
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 876fe06..c945745 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -162,8 +162,9 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-			    || !strncmp(param_buffer, "--table", 8)) {
+			if ((param_buffer[0] == '-' && param_buffer[1] != '-' &&
+				strchr(param_buffer, 't')) ||
+				!strncmp(param_buffer, "--table", strlen(param_buffer))) {
 				xtables_error(PARAMETER_PROBLEM,
 				"The -t option (seen in line %u) cannot be "
 				"used in iptables-restore.\n", line);
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 2e093b5..de56138 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -819,9 +819,9 @@ iptables_xml_main(int argc, char *argv[])
 					*(param_buffer + param_len) = '\0';
 
 					/* check if table name specified */
-					if (!strncmp(param_buffer, "-t", 3)
-					    || !strncmp(param_buffer,
-							"--table", 8)) {
+					if ((param_buffer[0] == '-' && param_buffer[1] != '-' &&
+						strchr(param_buffer, 't')) ||
+						!strncmp(param_buffer, "--table", strlen(param_buffer))) {
 						xtables_error(PARAMETER_PROBLEM,
 							   "Line %u seems to have a "
 							   "-t table option.\n",
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 15824f0..642b07f 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -136,8 +136,9 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-			    || !strncmp(param_buffer, "--table", 8)) {
+			if ((param_buffer[0] == '-' && param_buffer[1] != '-' &&
+				strchr(param_buffer, 't')) ||
+				!strncmp(param_buffer, "--table", strlen(param_buffer))) {
 				xtables_error(PARAMETER_PROBLEM,
 				"The -t option (seen in line %u) cannot be "
 				"used in xtables-restore.\n", line);
-- 
2.11.0


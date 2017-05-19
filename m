From: Oliver Ford <ojford@gmail.com>
Subject: [PATCH v3 1/1] iptables: Fix crash on malformed iptables-restore
Date: Fri, 19 May 2017 09:54:24 +0000
Message-ID: <1495187664-7807-1-git-send-email-ojford@gmail.com>
Cc: Oliver Ford <ojford@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35700 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdESJyc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 05:54:32 -0400
Received: by mail-wr0-f194.google.com with SMTP id g12so2334262wrg.2
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 02:54:31 -0700 (PDT)
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
Filter a beginning '--t'. Because the getopt_long function allows abbreviations,
any parameter beginning with '--t' will be treated as '--table'. As no other
iptables option begins with a 't' this won't filter out other options.

Signed-off-by: Oliver Ford <ojford@gmail.com>
---
 iptables/ip6tables-restore.c |  9 +++++----
 iptables/iptables-restore.c  |  9 +++++----
 iptables/iptables-xml.c      | 11 +++++------
 iptables/xtables-restore.c   |  9 +++++----
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 39a881d..46e9fae 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -165,11 +165,12 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-                            || !strncmp(param_buffer, "--table", 8)) {
+			if ((param_buffer[0] == '-' && param_buffer[1] != '-'
+				&& strchr(param_buffer, 't'))
+				|| !strncmp(param_buffer, "--t", 3)) {
 				xtables_error(PARAMETER_PROBLEM,
-				"The -t option (seen in line %u) cannot be "
-				"used in ip6tables-restore.\n", line);
+					"The -t option (seen in line %u) cannot be "
+					"used in ip6tables-restore.\n", line);
 				exit(1);
 			}
 
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 876fe06..9b06395 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -162,11 +162,12 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-			    || !strncmp(param_buffer, "--table", 8)) {
+			if ((param_buffer[0] == '-' && param_buffer[1] != '-'
+				&& strchr(param_buffer, 't'))
+				|| !strncmp(param_buffer, "--t", 3)) {
 				xtables_error(PARAMETER_PROBLEM,
-				"The -t option (seen in line %u) cannot be "
-				"used in iptables-restore.\n", line);
+					"The -t option (seen in line %u) cannot be "
+					"used in iptables-restore.\n", line);
 				exit(1);
 			}
 
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 2e093b5..d836ff4 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -819,13 +819,12 @@ iptables_xml_main(int argc, char *argv[])
 					*(param_buffer + param_len) = '\0';
 
 					/* check if table name specified */
-					if (!strncmp(param_buffer, "-t", 3)
-					    || !strncmp(param_buffer,
-							"--table", 8)) {
+					if ((param_buffer[0] == '-' && param_buffer[1] != '-'
+						&& strchr(param_buffer, 't'))
+						|| !strncmp(param_buffer, "--t", 3)) {
 						xtables_error(PARAMETER_PROBLEM,
-							   "Line %u seems to have a "
-							   "-t table option.\n",
-							   line);
+							"Line %u seems to have a "
+							"-t table option.\n", line);
 						exit(1);
 					}
 
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 15824f0..994e04e 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -136,11 +136,12 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-			    || !strncmp(param_buffer, "--table", 8)) {
+			if ((param_buffer[0] == '-' && param_buffer[1] != '-'
+				&& strchr(param_buffer, 't'))
+				|| !strncmp(param_buffer, "--t", 3)) {
 				xtables_error(PARAMETER_PROBLEM,
-				"The -t option (seen in line %u) cannot be "
-				"used in xtables-restore.\n", line);
+					"The -t option (seen in line %u) cannot be "
+					"used in xtables-restore.\n", line);
 				exit(1);
 			}
 
-- 
2.11.0


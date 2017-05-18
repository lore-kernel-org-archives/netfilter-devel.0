From: Oliver Ford <ojford@gmail.com>
Subject: [PATCH v2 1/1] iptables: Fix crash on malformed iptables-restore
Date: Thu, 18 May 2017 14:18:25 +0000
Message-ID: <1495117105-32762-1-git-send-email-ojford@gmail.com>
Cc: Oliver Ford <ojford@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34682 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754777AbdEROTL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 10:19:11 -0400
Received: by mail-wm0-f67.google.com with SMTP id d127so11596267wmf.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2017 07:19:05 -0700 (PDT)
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
Filter a beginning '--' followed by a 't' anywhere in the parameter where the
parameter is not in a list of valid iptables options (the list is every iptables
option that contains a 't' except for the 'table' option). This filters parameters
like '--tab' but allows valid ones like '--protocol'.

Signed-off-by: Oliver Ford <ojford@gmail.com>
---
 iptables/ip6tables-restore.c | 27 +++++++++++++++++++++++----
 iptables/iptables-restore.c  | 27 +++++++++++++++++++++++----
 iptables/iptables-xml.c      | 29 +++++++++++++++++++++++------
 iptables/xtables-restore.c   | 27 +++++++++++++++++++++++----
 4 files changed, 92 insertions(+), 18 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 39a881d..0c6f2e4 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -165,14 +165,33 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-                            || !strncmp(param_buffer, "--table", 8)) {
+			if (param_buffer[0] == '-' && param_buffer[1] != '-'
+				&& strchr(param_buffer, 't')) {
 				xtables_error(PARAMETER_PROBLEM,
-				"The -t option (seen in line %u) cannot be "
-				"used in ip6tables-restore.\n", line);
+					"The -t option (seen in line %u) cannot be "
+					"used in ip6tables-restore.\n", line);
+				exit(1);
+			} else if (!strncmp(param_buffer, "--", 2)
+				&& strchr(param_buffer, 't')) {
+				/* If we begin with a '--' and have a 't', check
+				 * that the parameter is in the list of valid options */
+				const char* t_options[] = {
+					"delete", "insert", "list", "list-rules", "delete-chain",
+					"destination", "dst", "protocol", "in-interface", "match",
+					"out-interface", "wait", "wait-interval", "exact",
+					"fragments", "set-counters", "goto"};
+				int i, opt_len = ARRAY_SIZE(t_options);
+				for (i = 0; i < opt_len; i++) {
+					if (!strcmp(param_buffer + 2, t_options[i])) {
+						goto t_passed;
+					}
+				}
+				xtables_error(PARAMETER_PROBLEM,
+					"Invalid option in line %u: %s\n", line, param_buffer);
 				exit(1);
 			}
 
+		t_passed:
 			add_argv(param_buffer);
 			param_len = 0;
 		} else {
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 876fe06..4ba9be6 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -162,14 +162,33 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-			    || !strncmp(param_buffer, "--table", 8)) {
+			if (param_buffer[0] == '-' && param_buffer[1] != '-'
+				&& strchr(param_buffer, 't')) {
 				xtables_error(PARAMETER_PROBLEM,
-				"The -t option (seen in line %u) cannot be "
-				"used in iptables-restore.\n", line);
+					"The -t option (seen in line %u) cannot be "
+					"used in iptables-restore.\n", line);
+				exit(1);
+			} else if (!strncmp(param_buffer, "--", 2)
+				&& strchr(param_buffer, 't')) {
+				/* If we begin with a '--' and have a 't', check
+				 * that the parameter is in the list of valid options */
+				const char* t_options[] = {
+					"delete", "insert", "list", "list-rules", "delete-chain",
+					"destination", "dst", "protocol", "in-interface", "match",
+					"out-interface", "wait", "wait-interval", "exact",
+					"fragments", "set-counters", "goto"};
+				int i, opt_len = ARRAY_SIZE(t_options);
+				for (i = 0; i < opt_len; i++) {
+					if (!strcmp(param_buffer + 2, t_options[i])) {
+						goto t_passed;
+					}
+				}
+				xtables_error(PARAMETER_PROBLEM,
+					"Invalid option in line %u: %s\n", line, param_buffer);
 				exit(1);
 			}
 
+		t_passed:
 			add_argv(param_buffer);
 			param_len = 0;
 		} else {
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 2e093b5..d93ca56 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -819,16 +819,33 @@ iptables_xml_main(int argc, char *argv[])
 					*(param_buffer + param_len) = '\0';
 
 					/* check if table name specified */
-					if (!strncmp(param_buffer, "-t", 3)
-					    || !strncmp(param_buffer,
-							"--table", 8)) {
+					if (param_buffer[0] == '-' && param_buffer[1] != '-'
+						&& strchr(param_buffer, 't')) {
 						xtables_error(PARAMETER_PROBLEM,
-							   "Line %u seems to have a "
-							   "-t table option.\n",
-							   line);
+							"Line %u seems to have a "
+							"-t table option.\n", line);
+						exit(1);
+					} else if (!strncmp(param_buffer, "--", 2)
+						&& strchr(param_buffer, 't')) {
+						/* If we begin with a '--' and have a 't', check
+						* that the parameter is in the list of valid options */
+						const char* t_options[] = {
+							"delete", "insert", "list", "list-rules", "delete-chain",
+							"destination", "dst", "protocol", "in-interface", "match",
+							"out-interface", "wait", "wait-interval", "exact",
+							"fragments", "set-counters", "goto"};
+						int i, opt_len = ARRAY_SIZE(t_options);
+						for (i = 0; i < opt_len; i++) {
+							if (!strcmp(param_buffer + 2, t_options[i])) {
+								goto t_passed;
+							}
+						}
+						xtables_error(PARAMETER_PROBLEM,
+							"Invalid option in line %u: %s\n", line, param_buffer);
 						exit(1);
 					}
 
+				t_passed:
 					add_argv(param_buffer, quoted);
 					if (newargc >= 2
 					    && 0 ==
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 15824f0..357f9b0 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -136,14 +136,33 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-			    || !strncmp(param_buffer, "--table", 8)) {
+			if (param_buffer[0] == '-' && param_buffer[1] != '-'
+				&& strchr(param_buffer, 't')) {
 				xtables_error(PARAMETER_PROBLEM,
-				"The -t option (seen in line %u) cannot be "
-				"used in xtables-restore.\n", line);
+					"The -t option (seen in line %u) cannot be "
+					"used in xtables-restore.\n", line);
+				exit(1);
+			} else if (!strncmp(param_buffer, "--", 2)
+				&& strchr(param_buffer, 't')) {
+				/* If we begin with a '--' and have a 't', check
+				 * that the parameter is in the list of valid options */
+				const char* t_options[] = {
+					"delete", "insert", "list", "list-rules", "delete-chain",
+					"destination", "dst", "protocol", "in-interface", "match",
+					"out-interface", "wait", "wait-interval", "exact",
+					"fragments", "set-counters", "goto"};
+				int i, opt_len = ARRAY_SIZE(t_options);
+				for (i = 0; i < opt_len; i++) {
+					if (!strcmp(param_buffer + 2, t_options[i])) {
+						goto t_passed;
+					}
+				}
+				xtables_error(PARAMETER_PROBLEM,
+					"Invalid option in line %u: %s\n", line, param_buffer);
 				exit(1);
 			}
 
+		t_passed:
 			add_argv(param_buffer);
 			param_len = 0;
 		} else {
-- 
2.11.0


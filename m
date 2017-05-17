From: Oliver Ford <ojford@gmail.com>
Subject: [PATCH 1/1] iptables: Fix crash on malformed iptables-restore
Date: Wed, 17 May 2017 16:47:41 +0000
Message-ID: <1495039661-9178-1-git-send-email-ojford@gmail.com>
Cc: Oliver Ford <ojford@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36803 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753986AbdEQQrz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 May 2017 12:47:55 -0400
Received: by mail-wm0-f65.google.com with SMTP id k15so3553225wmh.3
        for <netfilter-devel@vger.kernel.org>; Wed, 17 May 2017 09:47:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes the crash reported in Bugzilla #1131 where a malformed
parameter that specifies the table option can create an invalid
pointer.

Improves the tables option check to find a beginning '-' followed by
a 't' anywhere in the parameter.

Signed-off-by: Oliver Ford <ojford@gmail.com>
---
 iptables/ip6tables-restore.c |  3 +--
 iptables/iptables-restore.c  |  3 +--
 iptables/iptables-xml.c      | 10 ++++------
 iptables/xtables-restore.c   |  3 +--
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 39a881d..1a8cc5e 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -165,8 +165,7 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-                            || !strncmp(param_buffer, "--table", 8)) {
+			if (param_buffer[0] == '-' && strchr(param_buffer, 't')) {
 				xtables_error(PARAMETER_PROBLEM,
 				"The -t option (seen in line %u) cannot be "
 				"used in ip6tables-restore.\n", line);
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 876fe06..70dc7eb 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -162,8 +162,7 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-			    || !strncmp(param_buffer, "--table", 8)) {
+			if (param_buffer[0] == '-' && strchr(param_buffer, 't')) {
 				xtables_error(PARAMETER_PROBLEM,
 				"The -t option (seen in line %u) cannot be "
 				"used in iptables-restore.\n", line);
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 2e093b5..fe219ae 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -819,13 +819,11 @@ iptables_xml_main(int argc, char *argv[])
 					*(param_buffer + param_len) = '\0';
 
 					/* check if table name specified */
-					if (!strncmp(param_buffer, "-t", 3)
-					    || !strncmp(param_buffer,
-							"--table", 8)) {
+					if (param_buffer[0] == '-' && strchr(param_buffer, 't')) {
 						xtables_error(PARAMETER_PROBLEM,
-							   "Line %u seems to have a "
-							   "-t table option.\n",
-							   line);
+							"Line %u seems to have a "
+							"-t table option.\n",
+							line);
 						exit(1);
 					}
 
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 15824f0..75a64a7 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -136,8 +136,7 @@ static void add_param_to_argv(char *parsestart)
 			param_buffer[param_len] = '\0';
 
 			/* check if table name specified */
-			if (!strncmp(param_buffer, "-t", 2)
-			    || !strncmp(param_buffer, "--table", 8)) {
+			if (param_buffer[0] == '-' && strchr(param_buffer, 't')) {
 				xtables_error(PARAMETER_PROBLEM,
 				"The -t option (seen in line %u) cannot be "
 				"used in xtables-restore.\n", line);
-- 
2.11.0



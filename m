Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C72FCA9EC8
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 22:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BEA421D7D
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 22:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441559AbfJQWtZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 18:49:25 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42642 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438332AbfJQWtY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 18:49:24 -0400
Received: from localhost ([::1]:55732 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iLEaB-00045r-Hr; Fri, 18 Oct 2019 00:49:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/8] xtables-restore: Introduce rule counter tokenizer function
Date:   Fri, 18 Oct 2019 00:48:31 +0200
Message-Id: <20191017224836.8261-4-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191017224836.8261-1-phil@nwl.cc>
References: <20191017224836.8261-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The same piece of code appears three times, introduce a function to take
care of tokenizing and error reporting.

Pass buffer pointer via reference so it can be updated to point to after
the counters (if found).

While being at it, drop pointless casting when passing pcnt/bcnt to
add_argv().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.c                   | 35 ++----------------
 iptables/iptables-xml.c                       | 31 +---------------
 .../ipt-restore/0008-restore-counters_0       | 22 +++++++++++
 iptables/xshared.c                            | 37 +++++++++++++++++++
 iptables/xshared.h                            |  1 +
 iptables/xtables-restore.c                    | 35 ++----------------
 6 files changed, 70 insertions(+), 91 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0008-restore-counters_0

diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 6bc182bfae4a2..3655b3e84637e 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -313,44 +313,17 @@ ip46tables_restore_main(struct iptables_restore_cb *cb, int argc, char *argv[])
 			int a;
 			char *pcnt = NULL;
 			char *bcnt = NULL;
-			char *parsestart;
-
-			if (buffer[0] == '[') {
-				/* we have counters in our input */
-				char *ptr = strchr(buffer, ']');
-
-				if (!ptr)
-					xtables_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need ]\n",
-						   line);
-
-				pcnt = strtok(buffer+1, ":");
-				if (!pcnt)
-					xtables_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need :\n",
-						   line);
-
-				bcnt = strtok(NULL, "]");
-				if (!bcnt)
-					xtables_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need ]\n",
-						   line);
-
-				/* start command parsing after counter */
-				parsestart = ptr + 1;
-			} else {
-				/* start command parsing at start of line */
-				parsestart = buffer;
-			}
+			char *parsestart = buffer;
 
 			add_argv(argv[0], 0);
 			add_argv("-t", 0);
 			add_argv(curtable, 0);
 
+			tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
 			if (counters && pcnt && bcnt) {
 				add_argv("--set-counters", 0);
-				add_argv((char *) pcnt, 0);
-				add_argv((char *) bcnt, 0);
+				add_argv(pcnt, 0);
+				add_argv(bcnt, 0);
 			}
 
 			add_param_to_argv(parsestart, line);
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 36ad78450b1ef..5255e097eba88 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -644,7 +644,7 @@ iptables_xml_main(int argc, char *argv[])
 			unsigned int a;
 			char *pcnt = NULL;
 			char *bcnt = NULL;
-			char *parsestart;
+			char *parsestart = buffer;
 			char *chain = NULL;
 
 			/* the parser */
@@ -652,34 +652,7 @@ iptables_xml_main(int argc, char *argv[])
 			int quote_open, quoted;
 			char param_buffer[1024];
 
-			if (buffer[0] == '[') {
-				/* we have counters in our input */
-				char *ptr = strchr(buffer, ']');
-
-				if (!ptr)
-					xtables_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need ]\n",
-						   line);
-
-				pcnt = strtok(buffer + 1, ":");
-				if (!pcnt)
-					xtables_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need :\n",
-						   line);
-
-				bcnt = strtok(NULL, "]");
-				if (!bcnt)
-					xtables_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need ]\n",
-						   line);
-
-				/* start command parsing after counter */
-				parsestart = ptr + 1;
-			} else {
-				/* start command parsing at start of line */
-				parsestart = buffer;
-			}
-
+			tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
 
 			/* This is a 'real' parser crafted in artist mode
 			 * not hacker mode. If the author can live with that
diff --git a/iptables/tests/shell/testcases/ipt-restore/0008-restore-counters_0 b/iptables/tests/shell/testcases/ipt-restore/0008-restore-counters_0
new file mode 100755
index 0000000000000..5ac70682b76bf
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0008-restore-counters_0
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+set -e
+
+DUMP="*filter
+:foo - [23:42]
+[13:37] -A foo -j ACCEPT
+COMMIT
+"
+
+EXPECT=":foo - [0:0]
+[0:0] -A foo -j ACCEPT"
+
+$XT_MULTI iptables-restore <<< "$DUMP"
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables-save --counters | grep foo)
+
+# iptables-*-restore ignores custom chain counters :(
+EXPECT=":foo - [0:0]
+[13:37] -A foo -j ACCEPT"
+
+$XT_MULTI iptables-restore --counters <<< "$DUMP"
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables-save --counters | grep foo)
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 5e6cd4ae7c908..ba723f59dbaad 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -373,6 +373,43 @@ int parse_counters(const char *string, struct xt_counters *ctr)
 	return ret == 2;
 }
 
+/* Tokenize counters argument of typical iptables-restore format rule.
+ *
+ * If *bufferp contains counters, update *pcntp and *bcntp to point at them,
+ * change bytes after counters in *bufferp to nul-bytes, update *bufferp to
+ * point to after the counters and return true.
+ * If *bufferp does not contain counters, return false.
+ * If syntax is wrong in *bufferp, call xtables_error() and hence exit().
+ * */
+bool tokenize_rule_counters(char **bufferp, char **pcntp, char **bcntp, int line)
+{
+	char *ptr, *buffer = *bufferp, *pcnt, *bcnt;
+
+	if (buffer[0] != '[')
+		return false;
+
+	/* we have counters in our input */
+
+	ptr = strchr(buffer, ']');
+	if (!ptr)
+		xtables_error(PARAMETER_PROBLEM, "Bad line %u: need ]\n", line);
+
+	pcnt = strtok(buffer+1, ":");
+	if (!pcnt)
+		xtables_error(PARAMETER_PROBLEM, "Bad line %u: need :\n", line);
+
+	bcnt = strtok(NULL, "]");
+	if (!bcnt)
+		xtables_error(PARAMETER_PROBLEM, "Bad line %u: need ]\n", line);
+
+	*pcntp = pcnt;
+	*bcntp = bcnt;
+	/* start command parsing after counter */
+	*bufferp = ptr + 1;
+
+	return true;
+}
+
 inline bool xs_has_arg(int argc, char *argv[])
 {
 	return optind < argc &&
diff --git a/iptables/xshared.h b/iptables/xshared.h
index b08c700e1d8b9..21f4e8fdee67c 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -151,6 +151,7 @@ extern int xtables_lock_or_exit(int wait, struct timeval *tv);
 int parse_wait_time(int argc, char *argv[]);
 void parse_wait_interval(int argc, char *argv[], struct timeval *wait_interval);
 int parse_counters(const char *string, struct xt_counters *ctr);
+bool tokenize_rule_counters(char **bufferp, char **pcnt, char **bcnt, int line);
 bool xs_has_arg(int argc, char *argv[]);
 
 extern const struct xtables_afinfo *afinfo;
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 24bfce516d34c..4652d631d2219 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -230,47 +230,20 @@ void xtables_restore_parse(struct nft_handle *h,
 			int a;
 			char *pcnt = NULL;
 			char *bcnt = NULL;
-			char *parsestart;
+			char *parsestart = buffer;
 
 			/* reset the newargv */
 			newargc = 0;
 
-			if (buffer[0] == '[') {
-				/* we have counters in our input */
-				char *ptr = strchr(buffer, ']');
-
-				if (!ptr)
-					xtables_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need ]\n",
-						   line);
-
-				pcnt = strtok(buffer+1, ":");
-				if (!pcnt)
-					xtables_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need :\n",
-						   line);
-
-				bcnt = strtok(NULL, "]");
-				if (!bcnt)
-					xtables_error(PARAMETER_PROBLEM,
-						   "Bad line %u: need ]\n",
-						   line);
-
-				/* start command parsing after counter */
-				parsestart = ptr + 1;
-			} else {
-				/* start command parsing at start of line */
-				parsestart = buffer;
-			}
-
 			add_argv(xt_params->program_name, 0);
 			add_argv("-t", 0);
 			add_argv(curtable->name, 0);
 
+			tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
 			if (counters && pcnt && bcnt) {
 				add_argv("--set-counters", 0);
-				add_argv((char *) pcnt, 0);
-				add_argv((char *) bcnt, 0);
+				add_argv(pcnt, 0);
+				add_argv(bcnt, 0);
 			}
 
 			add_param_to_argv(parsestart, line);
-- 
2.23.0


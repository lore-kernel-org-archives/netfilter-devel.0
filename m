Return-Path: <SRS0=/SeC=YO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C1ECA9EAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 13:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EC0820873
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 13:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfJUNXf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 09:23:35 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51348 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727256AbfJUNXf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 09:23:35 -0400
Received: from localhost ([::1]:36204 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iMXen-00057X-B5; Mon, 21 Oct 2019 15:23:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2] xtables-restore: Fix --table parameter check
Date:   Mon, 21 Oct 2019 15:23:24 +0200
Message-Id: <20191021132324.11039-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Xtables-restore tries to reject rule commands in input which contain a
--table parameter (since it is adding this itself based on the previous
table line). The manual check was not perfect though as it caught any
parameter starting with a dash and containing a 't' somewhere, even in
rule comments:

| *filter
| -A FORWARD -m comment --comment "- allow this one" -j ACCEPT
| COMMIT

Instead of error-prone manual checking, go a much simpler route: All
do_command callbacks are passed a boolean indicating they're called from
*tables-restore. React upon this when handling a table parameter and
error out if it's not the first one.

Fixes: f8e5ebc5986bf ("iptables: Fix crash on malformed iptables-restore")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:

Completely rewritten: While simplifying v1 code, I noticed that even
valid --table options may appear in comments without problem, so
searched for a different approach than manual option parsing. This
solution is much easier and fully backwards compatible.
---
 iptables/iptables.c                                 |  4 ++++
 .../testcases/ipt-restore/0009-table-name-comment_0 | 13 +++++++++++++
 iptables/xshared.c                                  | 12 ------------
 iptables/xtables-eb.c                               |  4 ++++
 iptables/xtables.c                                  |  4 ++++
 5 files changed, 25 insertions(+), 12 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0009-table-name-comment_0

diff --git a/iptables/iptables.c b/iptables/iptables.c
index 0fbe3ec96bb27..d7a41321760e0 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1494,6 +1494,10 @@ int do_command4(int argc, char *argv[], char **table,
 			if (cs.invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
+			if (restore && *table)
+				xtables_error(PARAMETER_PROBLEM,
+					      "The -t option (seen in line %u) cannot be used in %s.\n",
+					      line, xt_params->program_name);
 			*table = optarg;
 			break;
 
diff --git a/iptables/tests/shell/testcases/ipt-restore/0009-table-name-comment_0 b/iptables/tests/shell/testcases/ipt-restore/0009-table-name-comment_0
new file mode 100755
index 0000000000000..4e2202df986cf
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0009-table-name-comment_0
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+# when restoring a ruleset, *tables-restore prefixes each rule with
+# '-t <tablename>' so standard rule parsing routines may be used. This means
+# that it has to detect and reject rules which already contain a table option.
+
+$XT_MULTI iptables-restore <<EOF
+*filter
+-t nat -A FORWARD -j ACCEPT
+COMMIT
+EOF
+
+[[ $? != 0 ]] || exit 1
diff --git a/iptables/xshared.c b/iptables/xshared.c
index ba723f59dbaad..5211b6472ed81 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -533,18 +533,6 @@ void add_param_to_argv(char *parsestart, int line)
 		}
 
 		param.buffer[param.len] = '\0';
-
-		/* check if table name specified */
-		if ((param.buffer[0] == '-' &&
-		     param.buffer[1] != '-' &&
-		     strchr(param.buffer, 't')) ||
-		    (!strncmp(param.buffer, "--t", 3) &&
-		     !strncmp(param.buffer, "--table", strlen(param.buffer)))) {
-			xtables_error(PARAMETER_PROBLEM,
-				      "The -t option (seen in line %u) cannot be used in %s.\n",
-				      line, xt_params->program_name);
-		}
-
 		add_argv(param.buffer, 0);
 		param.len = 0;
 	}
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 3b03daef28eb3..aa754d79608da 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -947,6 +947,10 @@ print_zero:
 			break;
 		case 't': /* Table */
 			ebt_check_option2(&flags, OPT_TABLE);
+			if (restore && *table)
+				xtables_error(PARAMETER_PROBLEM,
+					      "The -t option (seen in line %u) cannot be used in %s.\n",
+					      line, xt_params->program_name);
 			if (strlen(optarg) > EBT_TABLE_MAXNAMELEN - 1)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Table name length cannot exceed %d characters",
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 0e0cb5f53d421..89f3271e36dd0 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -879,6 +879,10 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			if (cs->invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
+			if (p->restore && p->table)
+				xtables_error(PARAMETER_PROBLEM,
+					      "The -t option (seen in line %u) cannot be used in %s.\n",
+					      line, xt_params->program_name);
 			if (!nft_table_builtin_find(h, optarg))
 				xtables_error(VERSION_PROBLEM,
 					      "table '%s' does not exist",
-- 
2.23.0


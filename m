Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE6BCA9EA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 10:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C88B32184C
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 10:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388390AbfJVKe4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 06:34:56 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:53484 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388259AbfJVKe4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 06:34:56 -0400
Received: from localhost ([::1]:38342 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iMrV9-0003Pf-1D; Tue, 22 Oct 2019 12:34:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xtables-restore: Unbreak *tables-restore
Date:   Tue, 22 Oct 2019 12:34:46 +0200
Message-Id: <20191022103446.14561-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 3dc433b55bbfa ("xtables-restore: Fix --table parameter check")
installed an error check which evaluated true in all cases as all
callers of do_command callbacks pass a pointer to a table name already.
Attached test case passed as it tested error condition only.

Fix the whole mess by introducing a boolean to indicate whether a table
parameter was seen already. Extend the test case to cover positive as
well as negative behaviour and to test ebtables-restore and
ip6tables-restore as well. Also add the required checking code to the
latter since the original commit missed it.

Fixes: 3dc433b55bbfa ("xtables-restore: Fix --table parameter check")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c                          |  6 ++++++
 iptables/iptables.c                           |  4 +++-
 .../ipt-restore/0009-table-name-comment_0     | 21 +++++++++++++++++--
 iptables/xtables-eb.c                         |  4 +++-
 iptables/xtables.c                            |  4 +++-
 5 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 57b0f9f55a921..c160a2dd4e65b 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1228,6 +1228,7 @@ int do_command6(int argc, char *argv[], char **table,
 	struct xtables_rule_match *matchp;
 	struct xtables_target *t;
 	unsigned long long cnt;
+	bool table_set = false;
 
 	/* re-set optind to 0 in case do_command6 gets called
 	 * a second time */
@@ -1508,7 +1509,12 @@ int do_command6(int argc, char *argv[], char **table,
 			if (cs.invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
+			if (restore && table_set)
+				xtables_error(PARAMETER_PROBLEM,
+					      "The -t option (seen in line %u) cannot be used in %s.\n",
+					      line, xt_params->program_name);
 			*table = optarg;
+			table_set = true;
 			break;
 
 		case 'x':
diff --git a/iptables/iptables.c b/iptables/iptables.c
index d7a41321760e0..544e87596e7e4 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1217,6 +1217,7 @@ int do_command4(int argc, char *argv[], char **table,
 	struct xtables_rule_match *matchp;
 	struct xtables_target *t;
 	unsigned long long cnt;
+	bool table_set = false;
 
 	/* re-set optind to 0 in case do_command4 gets called
 	 * a second time */
@@ -1494,11 +1495,12 @@ int do_command4(int argc, char *argv[], char **table,
 			if (cs.invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
-			if (restore && *table)
+			if (restore && table_set)
 				xtables_error(PARAMETER_PROBLEM,
 					      "The -t option (seen in line %u) cannot be used in %s.\n",
 					      line, xt_params->program_name);
 			*table = optarg;
+			table_set = true;
 			break;
 
 		case 'x':
diff --git a/iptables/tests/shell/testcases/ipt-restore/0009-table-name-comment_0 b/iptables/tests/shell/testcases/ipt-restore/0009-table-name-comment_0
index 4e2202df986cf..e96140758a99d 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0009-table-name-comment_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0009-table-name-comment_0
@@ -4,10 +4,27 @@
 # '-t <tablename>' so standard rule parsing routines may be used. This means
 # that it has to detect and reject rules which already contain a table option.
 
-$XT_MULTI iptables-restore <<EOF
+families="ip ip6"
+[[ $(basename $XT_MULTI) == xtables-nft-multi ]] && families+=" eb"
+
+for fam in $families; do
+	$XT_MULTI ${fam}tables-restore <<EOF
 *filter
 -t nat -A FORWARD -j ACCEPT
 COMMIT
 EOF
+	[[ $? != 0 ]] || {
+		echo "${fam}tables-restore did not fail when it should have"
+		exit 1
+	}
 
-[[ $? != 0 ]] || exit 1
+	$XT_MULTI ${fam}tables-restore <<EOF
+*filter
+-A FORWARD -j ACCEPT
+COMMIT
+EOF
+	[[ $? == 0 ]] || {
+		echo "${fam}tables-restore failed when it should not have"
+		exit 1
+	}
+done
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index aa754d79608da..fd7d601f6136a 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -780,6 +780,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	int selected_chain = -1;
 	struct xtables_rule_match *xtrm_i;
 	struct ebt_match *match;
+	bool table_set = false;
 
 	/* prevent getopt to spoil our error reporting */
 	optind = 0;
@@ -947,7 +948,7 @@ print_zero:
 			break;
 		case 't': /* Table */
 			ebt_check_option2(&flags, OPT_TABLE);
-			if (restore && *table)
+			if (restore && table_set)
 				xtables_error(PARAMETER_PROBLEM,
 					      "The -t option (seen in line %u) cannot be used in %s.\n",
 					      line, xt_params->program_name);
@@ -956,6 +957,7 @@ print_zero:
 					      "Table name length cannot exceed %d characters",
 					      EBT_TABLE_MAXNAMELEN - 1);
 			*table = optarg;
+			table_set = true;
 			break;
 		case 'i': /* Input interface */
 		case 2  : /* Logical input interface */
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 89f3271e36dd0..8a9e0edc3bea2 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -590,6 +590,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 	bool wait_interval_set = false;
 	struct timeval wait_interval;
 	struct xtables_target *t;
+	bool table_set = false;
 	int wait = 0;
 
 	memset(cs, 0, sizeof(*cs));
@@ -879,7 +880,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			if (cs->invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
-			if (p->restore && p->table)
+			if (p->restore && table_set)
 				xtables_error(PARAMETER_PROBLEM,
 					      "The -t option (seen in line %u) cannot be used in %s.\n",
 					      line, xt_params->program_name);
@@ -888,6 +889,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 					      "table '%s' does not exist",
 					      optarg);
 			p->table = optarg;
+			table_set = true;
 			break;
 
 		case 'x':
-- 
2.23.0


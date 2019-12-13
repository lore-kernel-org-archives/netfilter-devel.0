Return-Path: <SRS0=a9hH=2D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A5CC2D0C9
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 10:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6539206DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 10:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbfLMKc6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 05:32:58 -0500
Received: from correo.us.es ([193.147.175.20]:39196 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfLMKc6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 05:32:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 80BB3DA88C
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Dec 2019 11:32:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7193FDA70D
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Dec 2019 11:32:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4E321DA70C; Fri, 13 Dec 2019 11:32:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81E1DDA711;
        Fri, 13 Dec 2019 11:32:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Dec 2019 11:32:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 631C64265A5A;
        Fri, 13 Dec 2019 11:32:49 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft] main: enforce options before commands
Date:   Fri, 13 Dec 2019 11:32:46 +0100
Message-Id: <20191213103246.260989-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch turns on POSIXLY_CORRECT on the getopt parser to enforce
options before commands. Users get a hint in such a case:

 # nft list ruleset -a
 Error: syntax error, options must be specified before commands
 nft list ruleset -a
    ^             ~~

This patch recovers 9fc71bc6b602 ("main: Fix for misleading error with
negative chain priority").

Tests have been updated.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c                                         | 46 +++++++++++++++++++++-
 tests/shell/testcases/cache/0001_cache_handling_0  |  2 +-
 tests/shell/testcases/chains/0016delete_handle_0   |  4 +-
 .../shell/testcases/chains/0039negative_priority_0 |  8 ++++
 .../shell/testcases/flowtable/0010delete_handle_0  |  2 +-
 .../shell/testcases/maps/0008interval_map_delete_0 |  2 +-
 tests/shell/testcases/optionals/comments_0         |  2 +-
 tests/shell/testcases/optionals/comments_handles_0 |  2 +-
 .../testcases/optionals/delete_object_handles_0    |  4 +-
 tests/shell/testcases/optionals/handles_0          |  2 +-
 tests/shell/testcases/sets/0028delete_handle_0     |  2 +-
 11 files changed, 64 insertions(+), 12 deletions(-)
 create mode 100755 tests/shell/testcases/chains/0039negative_priority_0

diff --git a/src/main.c b/src/main.c
index fde8b15c5870..74199f93fa66 100644
--- a/src/main.c
+++ b/src/main.c
@@ -46,7 +46,7 @@ enum opt_vals {
 	OPT_TERSE		= 't',
 	OPT_INVALID		= '?',
 };
-#define OPTSTRING	"hvcf:iI:jvnsNaeSupypTt"
+#define OPTSTRING	"+hvcf:iI:jvnsNaeSupypTt"
 
 static const struct option options[] = {
 	{
@@ -202,6 +202,47 @@ static const struct {
 	},
 };
 
+static void nft_options_error(int argc, char * const argv[], int pos)
+{
+	int i;
+
+	fprintf(stderr, "Error: syntax error, options must be specified before commands\n");
+	for (i = 0; i < argc; i++)
+		fprintf(stderr, "%s ", argv[i]);
+	printf("\n%4c%*s\n", '^', pos - 2, "~~");
+}
+
+static bool nft_options_check(int argc, char * const argv[])
+{
+	bool skip = false, nonoption = false;
+	int pos = 0, i;
+
+	for (i = 1; i < argc; i++) {
+		pos += strlen(argv[i - 1]) + 1;
+		if (argv[i][0] == '{') {
+			break;
+		} else if (skip) {
+			skip = false;
+			continue;
+		} else if (argv[i][0] == '-') {
+			if (nonoption) {
+				nft_options_error(argc, argv, pos);
+				return false;
+			} else if (argv[i][1] == 'I' ||
+				   argv[i][1] == 'f' ||
+				   !strcmp(argv[i], "--includepath") ||
+				   !strcmp(argv[i], "--file")) {
+				skip = true;
+				continue;
+			}
+		} else if (argv[i][0] != '-') {
+			nonoption = true;
+		}
+	}
+
+	return true;
+}
+
 int main(int argc, char * const *argv)
 {
 	char *buf = NULL, *filename = NULL;
@@ -211,6 +252,9 @@ int main(int argc, char * const *argv)
 	unsigned int len;
 	int i, val, rc;
 
+	if (!nft_options_check(argc, argv))
+		exit(EXIT_FAILURE);
+
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
 
 	while (1) {
diff --git a/tests/shell/testcases/cache/0001_cache_handling_0 b/tests/shell/testcases/cache/0001_cache_handling_0
index 431aada59234..0a6844045b15 100755
--- a/tests/shell/testcases/cache/0001_cache_handling_0
+++ b/tests/shell/testcases/cache/0001_cache_handling_0
@@ -20,7 +20,7 @@ TMP=$(mktemp)
 echo "$RULESET" >> "$TMP"
 $NFT "flush ruleset;include \"$TMP\""
 rm -f "$TMP"
-rule_handle=$($NFT list ruleset -a | awk '/saddr/{print $NF}')
+rule_handle=$($NFT -a list ruleset | awk '/saddr/{print $NF}')
 $NFT delete rule inet test test handle $rule_handle
 $NFT delete set inet test test
 $NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0016delete_handle_0 b/tests/shell/testcases/chains/0016delete_handle_0
index 4633d771c619..8fd1ad864672 100755
--- a/tests/shell/testcases/chains/0016delete_handle_0
+++ b/tests/shell/testcases/chains/0016delete_handle_0
@@ -10,8 +10,8 @@ $NFT add chain ip6 test-ip6 x
 $NFT add chain ip6 test-ip6 y
 $NFT add chain ip6 test-ip6 z
 
-chain_y_handle=$($NFT list ruleset -a | awk -v n=1 '/chain y/ && !--n {print $NF; exit}');
-chain_z_handle=$($NFT list ruleset -a | awk -v n=2 '/chain z/ && !--n {print $NF; exit}');
+chain_y_handle=$($NFT -a list ruleset | awk -v n=1 '/chain y/ && !--n {print $NF; exit}');
+chain_z_handle=$($NFT -a list ruleset | awk -v n=2 '/chain z/ && !--n {print $NF; exit}');
 
 $NFT delete chain test-ip handle $chain_y_handle
 $NFT delete chain ip6 test-ip6 handle $chain_z_handle
diff --git a/tests/shell/testcases/chains/0039negative_priority_0 b/tests/shell/testcases/chains/0039negative_priority_0
new file mode 100755
index 000000000000..ba17b8cc19ed
--- /dev/null
+++ b/tests/shell/testcases/chains/0039negative_priority_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+# Test parsing of negative priority values
+
+set -e
+
+$NFT add table t
+$NFT add chain t c { type filter hook input priority -30\; }
diff --git a/tests/shell/testcases/flowtable/0010delete_handle_0 b/tests/shell/testcases/flowtable/0010delete_handle_0
index 303967ddb44a..985d4a3ad6ce 100755
--- a/tests/shell/testcases/flowtable/0010delete_handle_0
+++ b/tests/shell/testcases/flowtable/0010delete_handle_0
@@ -7,7 +7,7 @@ set -e
 $NFT add table inet t
 $NFT add flowtable inet t f { hook ingress priority filter\; devices = { lo }\; }
 
-FH=$($NFT list ruleset -a | awk '/flowtable f/ { print $NF }')
+FH=$($NFT -a list ruleset | awk '/flowtable f/ { print $NF }')
 
 $NFT delete flowtable inet t handle $FH
 
diff --git a/tests/shell/testcases/maps/0008interval_map_delete_0 b/tests/shell/testcases/maps/0008interval_map_delete_0
index a43fd28019f7..7da6eb38ddf7 100755
--- a/tests/shell/testcases/maps/0008interval_map_delete_0
+++ b/tests/shell/testcases/maps/0008interval_map_delete_0
@@ -24,7 +24,7 @@ $NFT delete element filter m { 127.0.0.3 }
 $NFT add element filter m { 127.0.0.3 : 0x3 }
 $NFT add element filter m { 127.0.0.2 : 0x2 }
 
-GET=$($NFT list ruleset -s)
+GET=$($NFT -s list ruleset)
 if [ "$EXPECTED" != "$GET" ] ; then
 	DIFF="$(which diff)"
 	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
diff --git a/tests/shell/testcases/optionals/comments_0 b/tests/shell/testcases/optionals/comments_0
index 29b850624635..ab859365a570 100755
--- a/tests/shell/testcases/optionals/comments_0
+++ b/tests/shell/testcases/optionals/comments_0
@@ -5,4 +5,4 @@
 $NFT add table test
 $NFT add chain test test
 $NFT add rule test test tcp dport 22 counter accept comment test_comment
-$NFT list table test -a | grep 'accept comment \"test_comment\"' >/dev/null
+$NFT -a list table test | grep 'accept comment \"test_comment\"' >/dev/null
diff --git a/tests/shell/testcases/optionals/comments_handles_0 b/tests/shell/testcases/optionals/comments_handles_0
index 30539bf0d760..a01df1df50f4 100755
--- a/tests/shell/testcases/optionals/comments_handles_0
+++ b/tests/shell/testcases/optionals/comments_handles_0
@@ -6,5 +6,5 @@ $NFT add table test
 $NFT add chain test test
 $NFT add rule test test tcp dport 22 counter accept comment test_comment
 set -e
-$NFT list table test -a | grep 'accept comment \"test_comment\" # handle '[[:digit:]]$ >/dev/null
+$NFT -a list table test | grep 'accept comment \"test_comment\" # handle '[[:digit:]]$ >/dev/null
 $NFT list table test | grep 'accept comment \"test_comment\"' | grep -v '# handle '[[:digit:]]$ >/dev/null
diff --git a/tests/shell/testcases/optionals/delete_object_handles_0 b/tests/shell/testcases/optionals/delete_object_handles_0
index d5d96547ee14..a2ae4228d6fa 100755
--- a/tests/shell/testcases/optionals/delete_object_handles_0
+++ b/tests/shell/testcases/optionals/delete_object_handles_0
@@ -10,8 +10,8 @@ $NFT add quota ip6 test-ip6 http-quota over 25 mbytes
 $NFT add counter ip6 test-ip6 http-traffic
 $NFT add quota ip6 test-ip6 ssh-quota 10 mbytes
 
-counter_handle=$($NFT list ruleset -a | awk '/https-traffic/{print $NF}')
-quota_handle=$($NFT list ruleset -a | awk '/ssh-quota/{print $NF}')
+counter_handle=$($NFT -a list ruleset | awk '/https-traffic/{print $NF}')
+quota_handle=$($NFT -a list ruleset | awk '/ssh-quota/{print $NF}')
 $NFT delete counter test-ip handle $counter_handle
 $NFT delete quota ip6 test-ip6 handle $quota_handle
 
diff --git a/tests/shell/testcases/optionals/handles_0 b/tests/shell/testcases/optionals/handles_0
index 7c6a437cf12b..80f3c5b226e6 100755
--- a/tests/shell/testcases/optionals/handles_0
+++ b/tests/shell/testcases/optionals/handles_0
@@ -5,4 +5,4 @@
 $NFT add table test
 $NFT add chain test test
 $NFT add rule test test tcp dport 22 counter accept
-$NFT list table test -a | grep 'accept # handle '[[:digit:]]$ >/dev/null
+$NFT -a list table test | grep 'accept # handle '[[:digit:]]$ >/dev/null
diff --git a/tests/shell/testcases/sets/0028delete_handle_0 b/tests/shell/testcases/sets/0028delete_handle_0
index 4e8b3228f605..5ad17c223db2 100755
--- a/tests/shell/testcases/sets/0028delete_handle_0
+++ b/tests/shell/testcases/sets/0028delete_handle_0
@@ -7,7 +7,7 @@ $NFT add set test-ip y { type inet_service \; timeout 3h45s \;}
 $NFT add set test-ip z { type ipv4_addr\; flags constant , interval\;}
 $NFT add set test-ip c {type ipv4_addr \; flags timeout \; elements={192.168.1.1 timeout 10s, 192.168.1.2 timeout 30s} \;}
 
-set_handle=$($NFT list ruleset -a | awk '/set c/{print $NF}')
+set_handle=$($NFT -a list ruleset | awk '/set c/{print $NF}')
 $NFT delete set test-ip handle $set_handle
 
 EXPECTED="table ip test-ip {
-- 
2.11.0


Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA41FC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Nov 2023 12:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjKNMbc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Nov 2023 07:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbjKNMbb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Nov 2023 07:31:31 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26655D1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 04:31:28 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] src: expand create commands
Date:   Tue, 14 Nov 2023 13:31:23 +0100
Message-Id: <20231114123123.269297-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

create commands also need to be expanded, otherwise elements are never
evaluated:

 # cat ruleset.nft
 define ip-block-4 = { 1.1.1.1 }
 create set netdev filter ip-block-4-test {
        type ipv4_addr
	flags interval
	auto-merge
	elements = $ip-block-4
 }
 # nft -f ruleset.nft
 BUG: unhandled expression type 0
 nft: src/intervals.c:211: interval_expr_key: Assertion `0' failed.
 Aborted

Same applies to chains in the form of:

 create chain x y {
	counter
 }

which is also accepted by the parser.

Update tests/shell to improve coverage for these use cases.

Fixes: 56c90a2dd2eb ("evaluate: expand sets and maps before evaluation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c                                    |  3 ++-
 tests/shell/testcases/include/0020include_chain_0    |  7 +++++++
 .../testcases/include/dumps/0020include_chain_0.nft  |  5 +++++
 tests/shell/testcases/sets/0049set_define_0          | 12 ++++++++++++
 .../shell/testcases/sets/dumps/0049set_define_0.nft  |  7 +++++++
 5 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index ec902009e002..0dee1bacb0db 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -532,7 +532,8 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 		collapsed = true;
 
 	list_for_each_entry(cmd, cmds, list) {
-		if (cmd->op != CMD_ADD)
+		if (cmd->op != CMD_ADD &&
+		    cmd->op != CMD_CREATE)
 			continue;
 
 		nft_cmd_expand(cmd);
diff --git a/tests/shell/testcases/include/0020include_chain_0 b/tests/shell/testcases/include/0020include_chain_0
index 8f78e8c606ec..49b6f76c6a8d 100755
--- a/tests/shell/testcases/include/0020include_chain_0
+++ b/tests/shell/testcases/include/0020include_chain_0
@@ -20,4 +20,11 @@ RULESET2="chain inet filter input2 {
 
 echo "$RULESET2" > $tmpfile1
 
+RULESET3="create chain inet filter output2 {
+	type filter hook output priority filter; policy accept;
+	ip daddr 1.2.3.4 tcp dport { 22, 443, 123 } drop
+}"
+
+echo "$RULESET3" >> $tmpfile1
+
 $NFT -o -f - <<< $RULESET
diff --git a/tests/shell/testcases/include/dumps/0020include_chain_0.nft b/tests/shell/testcases/include/dumps/0020include_chain_0.nft
index 3ad6db14d2f5..bf596ffb3067 100644
--- a/tests/shell/testcases/include/dumps/0020include_chain_0.nft
+++ b/tests/shell/testcases/include/dumps/0020include_chain_0.nft
@@ -3,4 +3,9 @@ table inet filter {
 		type filter hook input priority filter; policy accept;
 		ip saddr 1.2.3.4 tcp dport { 22, 123, 443 } drop
 	}
+
+	chain output2 {
+		type filter hook output priority filter; policy accept;
+		ip daddr 1.2.3.4 tcp dport { 22, 123, 443 } drop
+	}
 }
diff --git a/tests/shell/testcases/sets/0049set_define_0 b/tests/shell/testcases/sets/0049set_define_0
index 1d512f7b5a54..756afdc1e965 100755
--- a/tests/shell/testcases/sets/0049set_define_0
+++ b/tests/shell/testcases/sets/0049set_define_0
@@ -14,3 +14,15 @@ table inet filter {
 "
 
 $NFT -f - <<< "$EXPECTED"
+
+EXPECTED="define ip-block-4 = { 1.1.1.1 }
+
+     create set inet filter ip-block-4-test {
+            type ipv4_addr
+            flags interval
+            auto-merge
+            elements = \$ip-block-4
+     }
+"
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/sets/dumps/0049set_define_0.nft b/tests/shell/testcases/sets/dumps/0049set_define_0.nft
index 998b387a8151..d654420c00a1 100644
--- a/tests/shell/testcases/sets/dumps/0049set_define_0.nft
+++ b/tests/shell/testcases/sets/dumps/0049set_define_0.nft
@@ -1,4 +1,11 @@
 table inet filter {
+	set ip-block-4-test {
+		type ipv4_addr
+		flags interval
+		auto-merge
+		elements = { 1.1.1.1 }
+	}
+
 	chain input {
 		type filter hook input priority filter; policy drop;
 		tcp dport { 22, 80, 443 } ct state new counter packets 0 bytes 0 accept
-- 
2.30.2


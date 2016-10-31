From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink_linearize: skip set element expression in flow table key
Date: Mon, 31 Oct 2016 14:29:58 +0100
Message-ID: <1477920598-18055-1-git-send-email-pablo@netfilter.org>
Cc: akp@cohaesio.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35708 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942840AbcJaNaJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2016 09:30:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A706AE8394
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 14:30:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9809DDA91A
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 14:30:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DC38DA853
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 14:30:02 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anders reports that:

 # nft add rule ip6 filter postrouting \
	flow table acct_out \{ meta iif . ip6 saddr timeout 600s counter \}

while the opposite doesn't work:

 # nft add rule ip6 filter postrouting \
	flow table acct_out \{ ip6 saddr . meta iif timeout 600s counter \}

netlink_gen_flow_stmt() relies on the flow table key, that is expressed
as a set element. Use the set element key instead to skip the set
element wrap, otherwise get_register() abort execution:

 nft: netlink_linearize.c:650: netlink_gen_expr: Assertion `dreg < ctx->reg_low' failed.

Reported-by: Anders K. Pedersen <akp@cohaesio.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Anders: I'm proposing this as replacement for http://patchwork.ozlabs.org/patch/683547/

 src/netlink_linearize.c          |  6 +++---
 tests/py/ip6/flowtable.t         |  6 ++++++
 tests/py/ip6/flowtable.t.payload | 16 ++++++++++++++++
 3 files changed, 25 insertions(+), 3 deletions(-)
 create mode 100644 tests/py/ip6/flowtable.t
 create mode 100644 tests/py/ip6/flowtable.t.payload

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index b5967d49d304..0458af953fe6 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1124,9 +1124,9 @@ static void netlink_gen_flow_stmt(struct netlink_linearize_ctx *ctx,
 	enum nft_dynset_ops op;
 	struct set *set;
 
-	sreg_key = get_register(ctx, stmt->flow.key);
-	netlink_gen_expr(ctx, stmt->flow.key, sreg_key);
-	release_register(ctx, stmt->flow.key);
+	sreg_key = get_register(ctx, stmt->flow.key->key);
+	netlink_gen_expr(ctx, stmt->flow.key->key, sreg_key);
+	release_register(ctx, stmt->flow.key->key);
 
 	set = stmt->flow.set->set;
 	if (stmt->flow.key->timeout)
diff --git a/tests/py/ip6/flowtable.t b/tests/py/ip6/flowtable.t
new file mode 100644
index 000000000000..ae408b784eab
--- /dev/null
+++ b/tests/py/ip6/flowtable.t
@@ -0,0 +1,6 @@
+:input;type filter hook input priority 0
+
+*ip6;test-ip6;input
+
+flow table acct_out { meta iif . ip6 saddr timeout 600s counter };ok;flow table acct_out { iif . ip6 saddr timeout 10m counter packets 0 bytes 0}
+flow table acct_out { ip6 saddr . meta iif timeout 600s counter };ok;flow table acct_out { ip6 saddr . iif timeout 10m counter packets 0 bytes 0}
diff --git a/tests/py/ip6/flowtable.t.payload b/tests/py/ip6/flowtable.t.payload
new file mode 100644
index 000000000000..d3da5bad6333
--- /dev/null
+++ b/tests/py/ip6/flowtable.t.payload
@@ -0,0 +1,16 @@
+# flow table acct_out { meta iif . ip6 saddr timeout 600s counter }
+acct_out test-ip6 31
+acct_out test-ip6 0
+ip6 test-ip6 input
+  [ meta load iif => reg 1 ]
+  [ payload load 16b @ network header + 8 => reg 9 ]
+  [ dynset update reg_key 1 set acct_out timeout 600000ms expr [ counter pkts 0 bytes 0 ] ]
+
+# flow table acct_out { ip6 saddr . meta iif timeout 600s counter }
+acct_out test-ip6 31
+acct_out test-ip6 0
+ip6 test-ip6 input
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ meta load iif => reg 2 ]
+  [ dynset update reg_key 1 set acct_out timeout 600000ms expr [ counter pkts 0 bytes 0 ] ]
+
-- 
2.1.4


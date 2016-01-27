From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink_delinearize: only remove protocol if equal cmp is used
Date: Wed, 27 Jan 2016 14:42:35 +0100
Message-ID: <1453902155-3077-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38638 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932385AbcA0NwA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jan 2016 08:52:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check for OP_EQ before removing a dependency, else we may zap wrong one,
changing the meaning of the rule.

Listing without patch:
ip protocol udp udp dport ssh
ip protocol udp udp dport ssh
counter packets 1 bytes 308 ip protocol udp udp dport ssh

With patch:
ip protocol != tcp udp dport ssh
ip protocol != udp udp dport ssh
ip protocol != tcp counter packets 1 bytes 308 udp dport ssh

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 NB: ip protocol != udp udp dport ... is nonsensical, not sure
 if its worth the hassle to try to reject stuff like this.

 src/netlink_delinearize.c |  1 +
 tests/py/ip/tcp.t         |  6 ++++++
 tests/py/ip/tcp.t.payload | 18 ++++++++++++++++++
 3 files changed, 25 insertions(+)
 create mode 100644 tests/py/ip/tcp.t
 create mode 100644 tests/py/ip/tcp.t.payload

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 76d598c..2732c96 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1042,6 +1042,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		 * payload expression.
 		 */
 		if (ctx->pbase == PROTO_BASE_INVALID &&
+		    expr->op == OP_EQ &&
 		    left->flags & EXPR_F_PROTOCOL) {
 			unsigned int proto = mpz_get_be16(tmp->value);
 			const struct proto_desc *desc, *next;
diff --git a/tests/py/ip/tcp.t b/tests/py/ip/tcp.t
new file mode 100644
index 0000000..4dcfcb6
--- /dev/null
+++ b/tests/py/ip/tcp.t
@@ -0,0 +1,6 @@
+:input;type filter hook input priority 0
+
+*ip;test-ip;input
+
+ip protocol tcp tcp dport ssh accept;ok;tcp dport 22 accept
+ip protocol ne tcp udp dport ssh accept;ok;ip protocol != 6 udp dport 22 accept
diff --git a/tests/py/ip/tcp.t.payload b/tests/py/ip/tcp.t.payload
new file mode 100644
index 0000000..ed0dcc8
--- /dev/null
+++ b/tests/py/ip/tcp.t.payload
@@ -0,0 +1,18 @@
+# ip protocol tcp tcp dport ssh accept
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+  [ immediate reg 0 accept ]
+
+# ip protocol ne tcp udp dport ssh accept
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp neq reg 1 0x00000006 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+  [ immediate reg 0 accept ]
+
-- 
2.4.10


Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A965F1CD13
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 11:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710846232; cv=none; b=Dnji9PG3CAiIaxSEXQKIcM9fYOlkCqtvQgmcGipuzo/mtZXtrUnc76lFMzhhfrwIbas7YJ2owOo4msCFTF17DjcZyfv0GRxpwX8Lr+bn+Gb9STbBqAd7TlnafeAGuVGeSUoJUOOppWzBded6NZJxFDygyreJ15KjTvpYCUzsrMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710846232; c=relaxed/simple;
	bh=3yPoqbemr76Amp989yiN3JMRnZb5V6PpBBywvP0XPt8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=czMwj6p4uhJWqQKA5Kr7x9idWIsMB4JYG3H/vufX/Orje6C4f6sVyf7bIThU3VRv/pPJZ1oYiVTVhFuv5q2VnhrY/lWXEGyE22NJ7OV+9oi7Fg/bUeWGmaSmpseUf234zxifNCUBxhOmfQ1jqEBRBOuKV/aTpflkmwE91bdaDG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_delinearize: restore binop syntax when listing ruleset for flags
Date: Tue, 19 Mar 2024 12:03:37 +0100
Message-Id: <20240319110337.42486-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

c3d57114f119 ("parser_bison: add shortcut syntax for matching flags
without binary operations") provides a similar syntax to iptables using
a prefix representation for flag matching.

Restore original representation using binop when listing the ruleset.
The parser still accepts the prefix notation for backward compatibility.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c                     | 65 ++++++-------------
 tests/py/inet/tcp.t                           | 16 ++---
 .../testcases/nft-f/dumps/sample-ruleset.nft  |  4 +-
 tests/shell/testcases/packetpath/tcp_options  | 16 ++---
 4 files changed, 37 insertions(+), 64 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 1d30a78c3441..405a065bc98f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2517,56 +2517,29 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 
 	if (binop->op == OP_AND && (expr->op == OP_NEQ || expr->op == OP_EQ) &&
 	    right->dtype->basetype &&
-	    right->dtype->basetype->type == TYPE_BITMASK) {
-		switch (right->etype) {
-		case EXPR_VALUE:
-			if (!mpz_cmp_ui(right->value, 0)) {
-				/* Flag comparison: data & flags != 0
-				 *
-				 * Split the flags into a list of flag values and convert the
-				 * op to OP_EQ.
-				 */
-				expr_free(right);
-
-				expr->left  = expr_get(binop->left);
-				expr->right = binop_tree_to_list(NULL, binop->right);
-				switch (expr->op) {
-				case OP_NEQ:
-					expr->op = OP_IMPLICIT;
-					break;
-				case OP_EQ:
-					expr->op = OP_NEG;
-					break;
-				default:
-					BUG("unknown operation type %d\n", expr->op);
-				}
-				expr_free(binop);
-			} else if (binop->right->etype == EXPR_VALUE &&
-				   right->etype == EXPR_VALUE &&
-				   !mpz_cmp(right->value, binop->right->value)) {
-				/* Skip flag / flag representation for:
-				 * data & flag == flag
-				 * data & flag != flag
-				 */
-				;
-			} else {
-				*exprp = flagcmp_expr_alloc(&expr->location, expr->op,
-							    expr_get(binop->left),
-							    binop_tree_to_list(NULL, binop->right),
-							    expr_get(right));
-				expr_free(expr);
-			}
+	    right->dtype->basetype->type == TYPE_BITMASK &&
+	    right->etype == EXPR_VALUE &&
+	    !mpz_cmp_ui(right->value, 0)) {
+		/* Flag comparison: data & flags != 0
+		 *
+		 * Split the flags into a list of flag values and convert the
+		 * op to OP_EQ.
+		 */
+		expr_free(right);
+
+		expr->left  = expr_get(binop->left);
+		expr->right = binop_tree_to_list(NULL, binop->right);
+		switch (expr->op) {
+		case OP_NEQ:
+			expr->op = OP_IMPLICIT;
 			break;
-		case EXPR_BINOP:
-			*exprp = flagcmp_expr_alloc(&expr->location, expr->op,
-						    expr_get(binop->left),
-						    binop_tree_to_list(NULL, binop->right),
-						    binop_tree_to_list(NULL, right));
-			expr_free(expr);
+		case OP_EQ:
+			expr->op = OP_NEG;
 			break;
 		default:
-			break;
+			BUG("unknown operation type %d\n", expr->op);
 		}
+		expr_free(binop);
 	} else if (binop->left->dtype->flags & DTYPE_F_PREFIX &&
 		   binop->op == OP_AND && expr->right->etype == EXPR_VALUE &&
 		   expr_mask_is_prefix(binop->right)) {
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index f51ebd36b503..913bf99e3480 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -68,8 +68,8 @@ tcp flags != { fin, urg, ecn, cwr} drop;ok
 tcp flags cwr;ok
 tcp flags != cwr;ok
 tcp flags == syn;ok
-tcp flags fin,syn / fin,syn;ok
-tcp flags != syn / fin,syn;ok
+tcp flags fin,syn / fin,syn;ok;tcp flags (fin | syn) == (fin | syn)
+tcp flags != syn / fin,syn;ok;tcp flags (fin | syn) == syn
 tcp flags & syn != 0;ok;tcp flags syn
 tcp flags & syn == 0;ok;tcp flags ! syn
 tcp flags & (syn | ack) != 0;ok;tcp flags syn,ack
@@ -77,12 +77,12 @@ tcp flags & (syn | ack) == 0;ok;tcp flags ! syn,ack
 # it should be possible to transform this to: tcp flags syn
 tcp flags & syn == syn;ok
 tcp flags & syn != syn;ok
-tcp flags & (fin | syn | rst | ack) syn;ok;tcp flags syn / fin,syn,rst,ack
-tcp flags & (fin | syn | rst | ack) == syn;ok;tcp flags syn / fin,syn,rst,ack
-tcp flags & (fin | syn | rst | ack) != syn;ok;tcp flags != syn / fin,syn,rst,ack
-tcp flags & (fin | syn | rst | ack) == (syn | ack);ok;tcp flags syn,ack / fin,syn,rst,ack
-tcp flags & (fin | syn | rst | ack) != (syn | ack);ok;tcp flags != syn,ack / fin,syn,rst,ack
-tcp flags & (syn | ack) == (syn | ack);ok;tcp flags syn,ack / syn,ack
+tcp flags & (fin | syn | rst | ack) syn;ok
+tcp flags & (fin | syn | rst | ack) == syn;ok
+tcp flags & (fin | syn | rst | ack) != syn;ok
+tcp flags & (fin | syn | rst | ack) == (syn | ack);ok
+tcp flags & (fin | syn | rst | ack) != (syn | ack);ok
+tcp flags & (syn | ack) == (syn | ack);ok
 tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr;ok;tcp flags == 0xff
 tcp flags { syn, syn | ack };ok
 tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack };ok
diff --git a/tests/shell/testcases/nft-f/dumps/sample-ruleset.nft b/tests/shell/testcases/nft-f/dumps/sample-ruleset.nft
index 480b694a8989..1a9f4e7a4afa 100644
--- a/tests/shell/testcases/nft-f/dumps/sample-ruleset.nft
+++ b/tests/shell/testcases/nft-f/dumps/sample-ruleset.nft
@@ -73,7 +73,7 @@ table inet filter {
 
 	chain ct_new_pre {
 		jump rpfilter
-		tcp flags != syn / fin,syn,rst,ack counter packets 0 bytes 0 drop
+		tcp flags & (fin | syn | rst | ack) != syn counter packets 0 bytes 0 drop
 		iifname "eth0" meta nfproto vmap { ipv4 : jump blacklist_input_ipv4, ipv6 : jump blacklist_input_ipv6 }
 	}
 
@@ -131,7 +131,7 @@ table inet filter {
 		type filter hook forward priority mangle; policy accept;
 		oifname "eth0" jump {
 			ct state new meta nfproto vmap { ipv4 : jump blacklist_output_ipv4, ipv6 : jump blacklist_output_ipv6 }
-			tcp flags syn / syn,rst tcp option maxseg size set rt mtu
+			tcp flags & (syn | rst) == syn tcp option maxseg size set rt mtu
 		}
 	}
 
diff --git a/tests/shell/testcases/packetpath/tcp_options b/tests/shell/testcases/packetpath/tcp_options
index 1c9ee5329b26..88552226ee3a 100755
--- a/tests/shell/testcases/packetpath/tcp_options
+++ b/tests/shell/testcases/packetpath/tcp_options
@@ -15,14 +15,14 @@ table inet t {
 	chain c {
 		type filter hook output priority 0;
 		tcp dport != 22345 accept
-		tcp flags syn / fin,syn,rst,ack tcp option 254  length ge 4 counter name nomatchc drop
-		tcp flags syn / fin,syn,rst,ack tcp option fastopen length ge 2 reset tcp option fastopen counter name nomatchc
-		tcp flags syn / fin,syn,rst,ack tcp option sack-perm missing counter name nomatchc
-		tcp flags syn / fin,syn,rst,ack tcp option sack-perm exists counter name sackpermc
-		tcp flags syn / fin,syn,rst,ack tcp option maxseg size gt 1400 counter name maxsegc
-		tcp flags syn / fin,syn,rst,ack tcp option nop missing counter name nomatchc
-		tcp flags syn / fin,syn,rst,ack tcp option nop exists counter name nopc
-		tcp flags syn / fin,syn,rst,ack drop
+		tcp flags & (fin | syn | rst | ack ) == syn tcp option 254  length ge 4 counter name nomatchc drop
+		tcp flags & (fin | syn | rst | ack ) == syn tcp option fastopen length ge 2 reset tcp option fastopen counter name nomatchc
+		tcp flags & (fin | syn | rst | ack ) == syn tcp option sack-perm missing counter name nomatchc
+		tcp flags & (fin | syn | rst | ack) == syn tcp option sack-perm exists counter name sackpermc
+		tcp flags & (fin | syn | rst | ack) == syn tcp option maxseg size gt 1400 counter name maxsegc
+		tcp flags & (fin | syn | rst | ack) == syn tcp option nop missing counter name nomatchc
+		tcp flags & (fin | syn | rst | ack) == syn tcp option nop exists counter name nopc
+		tcp flags & (fin | syn | rst | ack) == syn drop
 	}
 }
 EOF
-- 
2.30.2


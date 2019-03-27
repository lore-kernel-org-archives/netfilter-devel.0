Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0B7C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 07:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFA9F2075D
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 07:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732725AbfC0HaE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 03:30:04 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38632 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732384AbfC0HaE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 03:30:04 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1h930Z-0002Kz-Rt; Wed, 27 Mar 2019 08:29:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables] src: add nat support for the inet family
Date:   Wed, 27 Mar 2019 08:32:08 +0100
Message-Id: <20190327073208.9517-1-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

consider a simple ip6 nat table:

table ip6 nat { chain output {
  type nat hook output priority 0; policy accept;
  dnat to dead:2::99
}

Now consider same ruleset, but using 'table inet nat':
nft now lacks context to determine address family to parse 'to $address'.

This adds code to make the following work:

table inet nat { [ .. ]
  # detect af from network protocol context:
  ip6 daddr dead::2::1 dnat to dead:2::99

  # use new dnat ip6 keyword:
  dnat ip6 to dead:2::99
  }

On list side, the keyword is only shown in the inet family, else the
short version (dnat to ...) is used as the family is redundant when the
table already mandates the ip protocol version supported.

Address mismatches such as

table ip6 { ..
	dnat ip to 1.2.3.4

are detected/handled during the evaluation phase.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.txt                  |   2 +-
 doc/statements.txt           |  24 ++++++-
 include/statement.h          |   1 +
 src/evaluate.c               | 119 ++++++++++++++++++++++++-----------
 src/netlink_delinearize.c    |   3 +
 src/netlink_linearize.c      |   2 +-
 src/parser_bison.y           |  11 ++++
 src/statement.c              |  12 +++-
 tests/py/inet/dnat.t         |  16 +++++
 tests/py/inet/dnat.t.payload |  54 ++++++++++++++++
 tests/py/inet/snat.t         |  21 +++++++
 tests/py/inet/snat.t.payload |  42 +++++++++++++
 12 files changed, 264 insertions(+), 43 deletions(-)
 create mode 100644 tests/py/inet/dnat.t
 create mode 100644 tests/py/inet/dnat.t.payload
 create mode 100644 tests/py/inet/snat.t
 create mode 100644 tests/py/inet/snat.t.payload

diff --git a/doc/nft.txt b/doc/nft.txt
index d162dad07e06..f1dd1d1809fd 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -333,7 +333,7 @@ For base chains, *type*, *hook* and *priority* parameters are mandatory.
 |Type | Families | Hooks | Description
 |filter | all | all |
 Standard chain type to use in doubt.
-|nat | ip, ip6 |
+|nat | ip, ip6, inet |
 prerouting, input, output, postrouting |
 Chains of this type perform Native Address Translation based on conntrack
 entries. Only the first packet of a connection actually traverses this chain -
diff --git a/doc/statements.txt b/doc/statements.txt
index 0687f53f8307..d4c1a53cb1ef 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -304,8 +304,10 @@ NAT STATEMENTS
 [verse]
 *snat* to address [:port] [persistent, random, fully-random]
 *snat* to address - address [:port - port] [persistent, random, fully-random]
+*snat* to { ip | ip6 } address - address [:port - port] [persistent, random ]
 *dnat* to address [:port] [persistent, random, fully-random]
-*dnat* to address [:port - port] [persistent, random, fully-random]
+*dnat* to address [:port - port] [persistent, random ]
+*dnat* to { ip | ip6 } address [:port - port] [persistent, random ]
 *masquerade* to [:port] [persistent, random, fully-random]
 *masquerade* to [:port - port] [persistent, random, fully-random]
 *redirect* to [:port] [persistent, random, fully-random]
@@ -330,7 +332,11 @@ The *redirect* statement is a special form of dnat which always translates the
 destination address to the local host's one. It comes in handy if one only wants
 to alter the destination port of incoming traffic on different interfaces.
 
-Note that all nat statements require both prerouting and postrouting base chains
+When used in the inet family (available with kernel 5.2), the dnat and snat
+statements require the use of the ip and ip6 keyword in case an address is
+provided, see the examples below.
+
+Before kernel 4.18 nat statements require both prerouting and postrouting base chains
 to be present since otherwise packets on the return path won't be seen by
 netfilter and therefore no reverse translation will take place.
 
@@ -355,7 +361,10 @@ port number (16 bit)
 |persistent |
 Gives a client the same source-/destination-address for each connection.
 |random|
-If used then port mapping will be randomized using a random seeded MD5 hash mix using source and destination address and destination port.
+In kernel 5.0 and newer this is the same as fully-random.
+In earlier kernels the port mapping will be randomized using a seeded MD5
+hash mix using source and destination address and destination port.
+
 |fully-random|
 If used then port mapping is generated based on a 32-bit pseudo-random algorithm.
 |=============================
@@ -379,6 +388,15 @@ add rule nat postrouting oif eth0 masquerade
 
 # redirect incoming TCP traffic for port 22 to port 2222
 add rule nat prerouting tcp dport 22 redirect to :2222
+
+# inet family:
+# handle ip dnat:
+add rule inet nat prerouting dnat ip to 10.0.2.99
+# handle ip6 dnat:
+add rule inet nat prerouting dnat ip6 to fe80::dead
+# this masquerades both ipv4 and ipv6:
+add rule inet nat postrouting meta oif ppp0 masquerade
+
 ------------------------
 
 TPROXY STATEMENT
diff --git a/include/statement.h b/include/statement.h
index 442405505072..91d6e0e2cb81 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -123,6 +123,7 @@ struct nat_stmt {
 	struct expr		*addr;
 	struct expr		*proto;
 	uint32_t		flags;
+	uint8_t			family;
 };
 
 extern struct stmt *nat_stmt_alloc(const struct location *loc,
diff --git a/src/evaluate.c b/src/evaluate.c
index 54afc3340186..4914129711b8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2504,9 +2504,28 @@ static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int nat_evaluate_family(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	const struct proto_desc *nproto;
+
 	switch (ctx->pctx.family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
+		if (stmt->nat.family == NFPROTO_UNSPEC)
+			stmt->nat.family = ctx->pctx.family;
+		return 0;
+	case NFPROTO_INET:
+		if (!stmt->nat.addr)
+			return 0;
+
+		if (stmt->nat.family != NFPROTO_UNSPEC)
+			return 0;
+
+		nproto = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+
+		if (nproto == &proto_ip)
+			stmt->nat.family = NFPROTO_IPV4;
+		else if (nproto == &proto_ip6)
+			stmt->nat.family = NFPROTO_IPV6;
+
 		return 0;
 	default:
 		return stmt_error(ctx, stmt,
@@ -2548,6 +2567,53 @@ static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 				 BYTEORDER_BIG_ENDIAN, expr);
 }
 
+static int stmt_evaluate_l3proto(struct eval_ctx *ctx,
+				 struct stmt *stmt, uint8_t family)
+{
+	const struct proto_desc *nproto;
+
+	nproto = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+
+	if ((nproto == &proto_ip && family != NFPROTO_IPV4) ||
+	    (nproto == &proto_ip6 && family != NFPROTO_IPV6))
+		return stmt_error(ctx, stmt,
+				  "Conflicting network layer protocols (context %s vs. family %d)",
+				  nproto->name, family);
+	return 0;
+}
+
+static int stmt_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
+			      uint8_t family,
+			      struct expr **addr)
+{
+	const struct datatype *dtype;
+	unsigned int len;
+	int err;
+
+	if (ctx->pctx.family == NFPROTO_INET) {
+		switch (family) {
+		case NFPROTO_IPV4:
+			dtype = &ipaddr_type;
+			len   = 4 * BITS_PER_BYTE;
+			break;
+		case NFPROTO_IPV6:
+			dtype = &ip6addr_type;
+			len   = 16 * BITS_PER_BYTE;
+			break;
+		default:
+			return stmt_error(ctx, stmt,
+					  "ip or ip6 must be specified with address for inet tables.");
+		}
+
+		err = stmt_evaluate_arg(ctx, stmt, dtype, len,
+					BYTEORDER_BIG_ENDIAN, addr);
+	} else {
+		err = evaluate_addr(ctx, stmt, addr);
+	}
+
+	return err;
+}
+
 static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	int err;
@@ -2557,7 +2623,12 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 		return err;
 
 	if (stmt->nat.addr != NULL) {
-		err = evaluate_addr(ctx, stmt, &stmt->nat.addr);
+		err = stmt_evaluate_l3proto(ctx, stmt, stmt->nat.family);
+		if (err < 0)
+			return err;
+
+		err = stmt_evaluate_addr(ctx, stmt, stmt->nat.family,
+					 &stmt->nat.addr);
 		if (err < 0)
 			return err;
 	}
@@ -2573,9 +2644,7 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	const struct proto_desc *nproto;
-	const struct datatype *dtype;
-	int err, len;
+	int err;
 
 	switch (ctx->pctx.family) {
 	case NFPROTO_IPV4:
@@ -2597,43 +2666,19 @@ static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
 	if (!stmt->tproxy.addr && !stmt->tproxy.port)
 		return stmt_error(ctx, stmt, "Either address or port must be specified!");
 
-	nproto = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
-	if ((nproto == &proto_ip && stmt->tproxy.family != NFPROTO_IPV4) ||
-	    (nproto == &proto_ip6 && stmt->tproxy.family != NFPROTO_IPV6))
-		/* this prevents us from rules like
-		 * ip protocol tcp tproxy ip6 to [dead::beef]
-		 */
-		return stmt_error(ctx, stmt,
-				  "Conflicting network layer protocols.");
+	err = stmt_evaluate_l3proto(ctx, stmt, stmt->tproxy.family);
+	if (err < 0)
+		return err;
 
 	if (stmt->tproxy.addr != NULL) {
 		if (stmt->tproxy.addr->etype == EXPR_RANGE)
 			return stmt_error(ctx, stmt, "Address ranges are not supported for tproxy.");
-		if (ctx->pctx.family == NFPROTO_INET) {
-			switch (stmt->tproxy.family) {
-			case NFPROTO_IPV4:
-				dtype = &ipaddr_type;
-				len   = 4 * BITS_PER_BYTE;
-				break;
-			case NFPROTO_IPV6:
-				dtype = &ip6addr_type;
-				len   = 16 * BITS_PER_BYTE;
-				break;
-			default:
-				return stmt_error(ctx, stmt,
-						  "Family must be specified in tproxy statement with address for inet tables.");
-			}
-			err = stmt_evaluate_arg(ctx, stmt, dtype, len,
-						BYTEORDER_BIG_ENDIAN,
-						&stmt->tproxy.addr);
-			if (err < 0)
-				return err;
-		}
-		else {
-			err = evaluate_addr(ctx, stmt, &stmt->tproxy.addr);
-			if (err < 0)
-				return err;
-		}
+
+		err = stmt_evaluate_addr(ctx, stmt, stmt->tproxy.family,
+					 &stmt->tproxy.addr);
+
+		if (err < 0)
+			return err;
 	}
 
 	if (stmt->tproxy.port != NULL) {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d0eaf5b62203..7b09dba60a2c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -930,6 +930,9 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 
 	family = nftnl_expr_get_u32(nle, NFTNL_EXPR_NAT_FAMILY);
 
+	if (ctx->table->handle.family == NFPROTO_INET)
+		stmt->nat.family = family;
+
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_NAT_FLAGS))
 		stmt->nat.flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_NAT_FLAGS);
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 61149bffcc83..df40ee7b6cff 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1024,7 +1024,7 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		nle = alloc_nft_expr("nat");
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_NAT_TYPE, stmt->nat.type);
 
-		family = nftnl_rule_get_u32(ctx->nlr, NFTNL_RULE_FAMILY);
+		family = stmt->nat.family;
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_NAT_FAMILY, family);
 
 		nftnl_flag_attr = NFTNL_EXPR_NAT_FLAGS;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 65b3fb3ebac2..9764b7e13aa6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2810,6 +2810,11 @@ nat_stmt_args		:	stmt_expr
 			{
 				$<stmt>0->nat.addr = $2;
 			}
+			|	nf_key_proto	TO	stmt_expr
+			{
+				$<stmt>0->nat.family = $1;
+				$<stmt>0->nat.addr = $3;
+			}
 			|	stmt_expr	COLON	stmt_expr
 			{
 				$<stmt>0->nat.addr = $1;
@@ -2820,6 +2825,12 @@ nat_stmt_args		:	stmt_expr
 				$<stmt>0->nat.addr = $2;
 				$<stmt>0->nat.proto = $4;
 			}
+			|	nf_key_proto	TO	 stmt_expr	COLON	stmt_expr
+			{
+				$<stmt>0->nat.family = $1;
+				$<stmt>0->nat.addr = $3;
+				$<stmt>0->nat.proto = $5;
+			}
 			|	COLON		stmt_expr
 			{
 				$<stmt>0->nat.proto = $2;
diff --git a/src/statement.c b/src/statement.c
index b9324fd7b2ed..de74a15529b0 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -567,8 +567,18 @@ const char *nat_etype2str(enum nft_nat_etypes type)
 static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	nft_print(octx, "%s", nat_etype2str(stmt->nat.type));
-	if (stmt->nat.addr || stmt->nat.proto)
+	if (stmt->nat.addr || stmt->nat.proto) {
+		switch (stmt->nat.family) {
+		case NFPROTO_IPV4:
+			nft_print(octx, " ip");
+			break;
+		case NFPROTO_IPV6:
+			nft_print(octx, " ip6");
+			break;
+		}
+
 		nft_print(octx, " to");
+	}
 
 	if (stmt->nat.addr) {
 		nft_print(octx, " ");
diff --git a/tests/py/inet/dnat.t b/tests/py/inet/dnat.t
new file mode 100644
index 000000000000..fcdf9436c676
--- /dev/null
+++ b/tests/py/inet/dnat.t
@@ -0,0 +1,16 @@
+:prerouting;type nat hook prerouting priority 0
+
+*inet;test-inet;prerouting
+
+iifname "foo" tcp dport 80 redirect to :8080;ok
+
+iifname "eth0" tcp dport 443 dnat ip to 192.168.3.2;ok
+iifname "eth0" tcp dport 443 dnat ip6 to [dead::beef]:4443;ok
+
+dnat ip to ct mark map { 0x00000014 : 1.2.3.4};ok
+dnat ip to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};ok
+
+dnat ip6 to 1.2.3.4;fail
+dnat to 1.2.3.4;fail
+dnat ip6 to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};fail
+ip6 daddr dead::beef dnat to 10.1.2.3;fail
diff --git a/tests/py/inet/dnat.t.payload b/tests/py/inet/dnat.t.payload
new file mode 100644
index 000000000000..b81caf7bc66d
--- /dev/null
+++ b/tests/py/inet/dnat.t.payload
@@ -0,0 +1,54 @@
+# iifname "foo" tcp dport 80 redirect to :8080
+inet test-inet prerouting
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00005000 ]
+  [ immediate reg 1 0x0000901f ]
+  [ redir proto_min reg 1 ]
+
+# iifname "eth0" tcp dport 443 dnat ip to 192.168.3.2
+inet test-inet prerouting
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000bb01 ]
+  [ immediate reg 1 0x0203a8c0 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+
+# iifname "eth0" tcp dport 443 dnat ip6 to [dead::beef]:4443
+inet test-inet prerouting
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000bb01 ]
+  [ immediate reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
+  [ immediate reg 2 0x00005b11 ]
+  [ nat dnat ip6 addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 ]
+
+# dnat ip to ct mark map { 0x00000014 : 1.2.3.4}
+__map%d test-inet b size 1
+__map%d test-inet 0
+        element 00000014  : 04030201 0 [end]
+inet test-inet prerouting
+  [ ct load mark => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+
+# dnat ip to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
+__map%d test-inet b size 1
+__map%d test-inet 0
+        element 00000014 01010101  : 04030201 0 [end]
+inet test-inet prerouting
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ ct load mark => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
diff --git a/tests/py/inet/snat.t b/tests/py/inet/snat.t
new file mode 100644
index 000000000000..cf23b5cff1bb
--- /dev/null
+++ b/tests/py/inet/snat.t
@@ -0,0 +1,21 @@
+:postrouting;type nat hook postrouting priority 0
+
+*inet;test-inet;postrouting
+
+# explicit family: 'snat to ip':
+iifname "eth0" tcp dport 81 snat ip to 192.168.3.2;ok
+
+# infer snat target family from network header base:
+iifname "eth0" tcp dport 81 ip saddr 10.1.1.1 snat to 192.168.3.2;ok;iifname "eth0" tcp dport 81 ip saddr 10.1.1.1 snat ip to 192.168.3.2
+iifname "eth0" tcp dport 81 snat ip6 to dead::beef;ok
+
+iifname "foo" masquerade random;ok
+
+
+snat to 192.168.3.2;fail
+snat ip6 to 192.168.3.2;fail
+snat to dead::beef;fail
+snat ip to dead::beef;fail
+snat ip daddr 1.2.3.4 to dead::beef;fail
+snat ip daddr 1.2.3.4 ip6 to dead::beef;fail
+snat ip6 saddr dead::beef to 1.2.3.4;fail
diff --git a/tests/py/inet/snat.t.payload b/tests/py/inet/snat.t.payload
new file mode 100644
index 000000000000..00bb937fd843
--- /dev/null
+++ b/tests/py/inet/snat.t.payload
@@ -0,0 +1,42 @@
+# iifname "eth0" tcp dport 81 snat ip to 192.168.3.2
+inet test-inet postrouting
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00005100 ]
+  [ immediate reg 1 0x0203a8c0 ]
+  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
+
+# iifname "eth0" tcp dport 81 ip saddr 10.1.1.1 snat to 192.168.3.2
+inet test-inet postrouting
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00005100 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0101010a ]
+  [ immediate reg 1 0x0203a8c0 ]
+  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
+
+# iifname "eth0" tcp dport 81 snat ip6 to dead::beef
+inet test-inet postrouting
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00005100 ]
+  [ immediate reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
+  [ nat snat ip6 addr_min reg 1 addr_max reg 0 ]
+
+# iifname "foo" masquerade random
+inet test-inet postrouting
+  [ meta load iifname => reg 1 ]
+  [ cmp eq reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
+  [ masq flags 0x4 ]
-- 
2.19.2


From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/2] src: add nat persistent and random options
Date: Fri, 03 Oct 2014 14:46:41 +0200
Message-ID: <20141003124641.9409.9789.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60513 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752004AbaJCMqu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:46:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds more configuration options to the nat expression.

The syntax is as follow:
 % nft add rule nat postrouting <snat|dnat> <nat_arguments> [flags]

Flags are: random, persistent, random-fully.
Example:

 % nft add rule nat postrouting dnat 1.1.1.1 random,persistent

A requirement is to cache some [recent] copies of kernel headers.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 .../linux/netfilter/nf_conntrack_tuple_common.h    |   32 ++++++++++++++-
 include/linux/netfilter/nf_nat.h                   |   42 ++++++++++++++++++++
 include/statement.h                                |    1 
 src/netlink_delinearize.c                          |    4 ++
 src/netlink_linearize.c                            |    3 +
 src/parser.y                                       |   21 ++++++++++
 src/scanner.l                                      |    3 +
 src/statement.c                                    |   26 ++++++++++++
 8 files changed, 130 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/netfilter/nf_nat.h

diff --git a/include/linux/netfilter/nf_conntrack_tuple_common.h b/include/linux/netfilter/nf_conntrack_tuple_common.h
index 8e145f0..8ab3118 100644
--- a/include/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/linux/netfilter/nf_conntrack_tuple_common.h
@@ -1,13 +1,41 @@
 #ifndef _NF_CONNTRACK_TUPLE_COMMON_H
 #define _NF_CONNTRACK_TUPLE_COMMON_H
 
-enum ip_conntrack_dir
-{
+#include <linux/types.h>
+
+enum ip_conntrack_dir {
 	IP_CT_DIR_ORIGINAL,
 	IP_CT_DIR_REPLY,
 	IP_CT_DIR_MAX
 };
 
+/* The protocol-specific manipulable parts of the tuple: always in
+ * network order
+ */
+union nf_conntrack_man_proto {
+	/* Add other protocols here. */
+	__be16 all;
+
+	struct {
+		__be16 port;
+	} tcp;
+	struct {
+		__be16 port;
+	} udp;
+	struct {
+		__be16 id;
+	} icmp;
+	struct {
+		__be16 port;
+	} dccp;
+	struct {
+		__be16 port;
+	} sctp;
+	struct {
+		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
+	} gre;
+};
+
 #define CTINFO2DIR(ctinfo) ((ctinfo) >= IP_CT_IS_REPLY ? IP_CT_DIR_REPLY : IP_CT_DIR_ORIGINAL)
 
 #endif /* _NF_CONNTRACK_TUPLE_COMMON_H */
diff --git a/include/linux/netfilter/nf_nat.h b/include/linux/netfilter/nf_nat.h
new file mode 100644
index 0000000..0880781
--- /dev/null
+++ b/include/linux/netfilter/nf_nat.h
@@ -0,0 +1,42 @@
+#ifndef _NETFILTER_NF_NAT_H
+#define _NETFILTER_NF_NAT_H
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+
+#define NF_NAT_RANGE_MAP_IPS			(1 << 0)
+#define NF_NAT_RANGE_PROTO_SPECIFIED		(1 << 1)
+#define NF_NAT_RANGE_PROTO_RANDOM		(1 << 2)
+#define NF_NAT_RANGE_PERSISTENT			(1 << 3)
+#define NF_NAT_RANGE_PROTO_RANDOM_FULLY		(1 << 4)
+
+#define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
+	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+
+#define NF_NAT_RANGE_MASK					\
+	(NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |	\
+	 NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |	\
+	 NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+
+struct nf_nat_ipv4_range {
+	unsigned int			flags;
+	__be32				min_ip;
+	__be32				max_ip;
+	union nf_conntrack_man_proto	min;
+	union nf_conntrack_man_proto	max;
+};
+
+struct nf_nat_ipv4_multi_range_compat {
+	unsigned int			rangesize;
+	struct nf_nat_ipv4_range	range[1];
+};
+
+struct nf_nat_range {
+	unsigned int			flags;
+	union nf_inet_addr		min_addr;
+	union nf_inet_addr		max_addr;
+	union nf_conntrack_man_proto	min_proto;
+	union nf_conntrack_man_proto	max_proto;
+};
+
+#endif /* _NETFILTER_NF_NAT_H */
diff --git a/include/statement.h b/include/statement.h
index e2f02b8..e04ab7d 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -65,6 +65,7 @@ struct nat_stmt {
 	enum nft_nat_types	type;
 	struct expr		*addr;
 	struct expr		*proto;
+	uint32_t		flags;
 };
 
 extern struct stmt *nat_stmt_alloc(const struct location *loc);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 796b632..e2a13d3 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -491,6 +491,10 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 
 	family = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_FAMILY);
 
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_NAT_FLAGS))
+		stmt->nat.flags = nft_rule_expr_get_u32(nle,
+							NFT_EXPR_NAT_FLAGS);
+
 	reg1 = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_REG_ADDR_MIN);
 	if (reg1) {
 		addr = netlink_get_register(ctx, loc, reg1);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c46b6d4..36b56ff 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -631,6 +631,9 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 	family = nft_rule_attr_get_u32(ctx->nlr, NFT_RULE_ATTR_FAMILY);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_FAMILY, family);
 
+	if (stmt->nat.flags != 0)
+		nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_FLAGS, stmt->nat.flags);
+
 	if (stmt->nat.addr) {
 		amin_reg = get_register(ctx);
 		registers++;
diff --git a/src/parser.y b/src/parser.y
index 4a8df7b..9fda571 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -19,6 +19,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <linux/netfilter/nf_nat.h>
 #include <libnftnl/common.h>
 #include <libnftnl/set.h>
 
@@ -371,6 +372,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token SNAT			"snat"
 %token DNAT			"dnat"
+%token RANDOM			"random"
+%token RANDOM_FULLY		"random-fully"
+%token PERSISTENT		"persistent"
 
 %token QUEUE			"queue"
 %token QUEUENUM			"num"
@@ -435,6 +439,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	reject_stmt
 %type <stmt>			nat_stmt nat_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc
+%type <val>			nf_nat_flags nf_nat_flag
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_stmt_flags queue_stmt_flag
@@ -1408,6 +1413,22 @@ nat_stmt_args		:	expr
 			{
 				$<stmt>0->nat.proto = $2;
 			}
+			|	nat_stmt_args	nf_nat_flags
+			{
+				$<stmt>0->nat.flags = $2;
+			}
+			;
+
+nf_nat_flags		:	nf_nat_flag
+			|	nf_nat_flags	COMMA	nf_nat_flag
+			{
+				$$ = $1 | $3;
+			}
+			;
+
+nf_nat_flag		:	RANDOM		{ $$ = NF_NAT_RANGE_PROTO_RANDOM; }
+			|	RANDOM_FULLY	{ $$ = NF_NAT_RANGE_PROTO_RANDOM_FULLY; }
+			|	PERSISTENT 	{ $$ = NF_NAT_RANGE_PERSISTENT; }
 			;
 
 queue_stmt		:	queue_stmt_alloc
diff --git a/src/scanner.l b/src/scanner.l
index 35c9446..440b0ed 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -316,6 +316,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "snat"			{ return SNAT; }
 "dnat"			{ return DNAT; }
+"random"		{ return RANDOM; }
+"random-fully"		{ return RANDOM_FULLY; }
+"persistent"		{ return PERSISTENT; }
 
 "ll"			{ return LL_HDR; }
 "nh"			{ return NETWORK_HDR; }
diff --git a/src/statement.c b/src/statement.c
index 8e4b49e..1b2c31c 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -20,6 +20,9 @@
 #include <utils.h>
 #include <list.h>
 
+#include <netinet/in.h>
+#include <linux/netfilter/nf_nat.h>
+
 struct stmt *stmt_alloc(const struct location *loc,
 			const struct stmt_ops *ops)
 {
@@ -240,6 +243,27 @@ struct stmt *reject_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &reject_stmt_ops);
 }
 
+static void print_nf_nat_flags(uint32_t flags)
+{
+	const char *delim = " ";
+
+	if (flags == 0)
+		return;
+
+	if (flags & NF_NAT_RANGE_PROTO_RANDOM) {
+		printf("%srandom", delim);
+		delim = ",";
+	}
+
+	if (flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
+		printf("%srandom-fully", delim);
+		delim = ",";
+	}
+
+	if (flags & NF_NAT_RANGE_PERSISTENT)
+		printf("%spersistent", delim);
+}
+
 static void nat_stmt_print(const struct stmt *stmt)
 {
 	static const char *nat_types[] = {
@@ -254,6 +278,8 @@ static void nat_stmt_print(const struct stmt *stmt)
 		printf(":");
 		expr_print(stmt->nat.proto);
 	}
+
+	print_nf_nat_flags(stmt->nat.flags);
 }
 
 static void nat_stmt_destroy(struct stmt *stmt)


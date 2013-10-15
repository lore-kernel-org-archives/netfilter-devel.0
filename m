From: Florian Westphal <fw@strlen.de>
Subject: [RFC PATCH nft] src: add support for interface wildcard name
Date: Tue, 15 Oct 2013 16:23:13 +0200
Message-ID: <1381846993-30093-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42555 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759122Ab3JOOYw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:24:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Uses same syntax as iptables: itfname+.

The '+' suffix is not stored on the kernel side; this approach
is the same as the one used by iptables-nftables, i.e.
xtables-save understands 'nft .. meta oifname foo+' and vice versa.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Caveats:
  - I am not convinced '+' is a good idea -- it is ambiguous since
  'foo+' is a legal interface name.
  Maybe we should use 'foo/' (Linux forbids / in interface names) instead?
  - added a new 'itfname' data type since I felt uncomfortable
    with allowing 'non-nul-terminated' strings.
  - removes a FIXME in netlink_delinearize.  What was that about? :-}

 include/datatype.h        | 10 +++++++++-
 src/datatype.c            | 41 +++++++++++++++++++++++++++++++++++++++++
 src/evaluate.c            |  1 -
 src/meta.c                |  4 ++--
 src/netlink_delinearize.c |  9 ++++++---
 src/scanner.l             |  2 +-
 6 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 239d5ea..9a6ae33 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -40,6 +40,7 @@ enum datatypes {
 	TYPE_BITMASK,
 	TYPE_INTEGER,
 	TYPE_STRING,
+	TYPE_IFNAME,
 	TYPE_LLADDR,
 	TYPE_IPADDR,
 	TYPE_IP6ADDR,
@@ -128,7 +129,13 @@ extern void datatype_print(const struct expr *expr);
 static inline bool datatype_equal(const struct datatype *d1,
 				  const struct datatype *d2)
 {
-	return d1->type == d2->type;
+	if (d1->type == d2->type)
+		return true;
+	if (d1->basetype)
+		return datatype_equal(d1->basetype, d2);
+	if (d2->basetype)
+		return datatype_equal(d1, d2->basetype);
+	return false;
 }
 
 /**
@@ -171,6 +178,7 @@ extern const struct datatype verdict_type;
 extern const struct datatype bitmask_type;
 extern const struct datatype integer_type;
 extern const struct datatype string_type;
+extern const struct datatype ifname_type;
 extern const struct datatype lladdr_type;
 extern const struct datatype ipaddr_type;
 extern const struct datatype ip6addr_type;
diff --git a/src/datatype.c b/src/datatype.c
index 4c5a70f..e0dbe80 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -29,6 +29,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_BITMASK]		= &bitmask_type,
 	[TYPE_INTEGER]		= &integer_type,
 	[TYPE_STRING]		= &string_type,
+	[TYPE_IFNAME]		= &ifname_type,
 	[TYPE_LLADDR]		= &lladdr_type,
 	[TYPE_IPADDR]		= &ipaddr_type,
 	[TYPE_IP6ADDR]		= &ip6addr_type,
@@ -280,6 +281,46 @@ const struct datatype string_type = {
 	.parse		= string_type_parse,
 };
 
+static void ifname_type_print(const struct expr *expr)
+{
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
+	char data[len];
+
+	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	printf("\"%.*s", len, data);
+	if (len && data[len-1] != '\0')
+		printf("+"); /* string without nul: interface wildcard match */
+	printf("\"");
+}
+
+static struct error_record *ifname_type_parse(const struct expr *sym,
+					      struct expr **res)
+{
+	size_t len = strlen(sym->identifier);
+
+	assert(len > 0);
+
+	if (sym->identifier[len-1] != '+')
+		len++; /* exact match: count \0, too */
+	else
+		len--;	/* match "name*", ignore '+' */
+
+	*res = constant_expr_alloc(&sym->location, &string_type,
+				   BYTEORDER_HOST_ENDIAN,
+				   len * BITS_PER_BYTE,
+				   sym->identifier);
+	return NULL;
+}
+
+const struct datatype ifname_type = {
+	.type		= TYPE_IFNAME,
+	.name		= "ifname",
+	.desc		= "ifname",
+	.print		= ifname_type_print,
+	.parse		= ifname_type_parse,
+	.basetype	= &string_type,
+};
+
 static void lladdr_type_print(const struct expr *expr)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
diff --git a/src/evaluate.c b/src/evaluate.c
index 94fee64..2625c2b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -243,7 +243,6 @@ static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
 				return expr_error(ctx, *expr,
 						  "String exceeds maximum length of %u",
 						  ctx->ectx.len / BITS_PER_BYTE);
-			(*expr)->len = ctx->ectx.len;
 		}
 		break;
 	default:
diff --git a/src/meta.c b/src/meta.c
index 9606a44..d8c6409 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -293,14 +293,14 @@ static const struct meta_template meta_templates[] = {
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_IIF]		= META_TEMPLATE("iif",       &ifindex_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_IIFNAME]	= META_TEMPLATE("iifname",   &string_type,
+	[NFT_META_IIFNAME]	= META_TEMPLATE("iifname",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_IIFTYPE]	= META_TEMPLATE("iiftype",   &arphrd_type,
 						2 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_OIF]		= META_TEMPLATE("oif",	     &ifindex_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_OIFNAME]	= META_TEMPLATE("oifname",   &string_type,
+	[NFT_META_OIFNAME]	= META_TEMPLATE("oifname",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_OIFTYPE]	= META_TEMPLATE("oiftype",   &arphrd_type,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d80fc78..adf34bf 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -117,6 +117,11 @@ static enum ops netlink_parse_cmp_op(const struct nft_rule_expr *nle)
 	}
 }
 
+static bool relational_expr_check_size(struct expr *expr)
+{
+	return expr->len && expr_basetype(expr)->type != TYPE_STRING;
+}
+
 static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nft_rule_expr *nle)
@@ -137,9 +142,7 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	op = netlink_parse_cmp_op(nle);
 	right = netlink_alloc_value(loc, &nld);
 
-	// FIXME
-	if (left->len && left->dtype && left->dtype->type != TYPE_STRING &&
-	    left->len != right->len)
+	if (relational_expr_check_size(left) && left->len != right->len)
 		return netlink_error(ctx, loc,
 				     "Relational expression size mismatch");
 
diff --git a/src/scanner.l b/src/scanner.l
index cee6aa6..fe93b8b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -111,7 +111,7 @@ decstring	{digit}+
 hexstring	0[xX]{hexdigit}+
 range		({decstring}?:{decstring}?)
 letter		[a-zA-Z]
-string		({letter})({letter}|{digit}|[/\-_\.])*
+string		({letter})({letter}|{digit}|[/\-_\.\+])*
 quotedstring	\"[^"]*\"
 comment		#.*$
 slash		\/
-- 
1.8.1.5


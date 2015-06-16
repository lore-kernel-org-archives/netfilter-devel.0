From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnfnl] chain: add netdev family support
Date: Tue, 16 Jun 2015 17:30:23 +0200
Message-ID: <1434468623-4912-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51950 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbbFPPZM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 11:25:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for the new NFT_CHAIN_ATTR_DEV attribute that indicates that the
basechain is attached to a net_device.

This partially reworks 1dd9ba1ea23c ("table: add netdev family support").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/chain.h            |    1 +
 include/libnftnl/table.h            |    1 -
 include/linux/netfilter/nf_tables.h |    4 +--
 src/chain.c                         |   47 +++++++++++++++++++++++++++++++++--
 src/table.c                         |   37 ++-------------------------
 tests/nft-chain-test.c              |    4 +++
 tests/nft-table-test.c              |    9 +++----
 7 files changed, 57 insertions(+), 46 deletions(-)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index c11cb5e..3968e6b 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -29,6 +29,7 @@ enum {
 	NFT_CHAIN_ATTR_PACKETS	= 8,
 	NFT_CHAIN_ATTR_HANDLE,
 	NFT_CHAIN_ATTR_TYPE,
+	NFT_CHAIN_ATTR_DEV,
 	__NFT_CHAIN_ATTR_MAX
 };
 #define NFT_CHAIN_ATTR_MAX (__NFT_CHAIN_ATTR_MAX - 1)
diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index 16df5fa..fac79e7 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -22,7 +22,6 @@ enum {
 	NFT_TABLE_ATTR_FAMILY,
 	NFT_TABLE_ATTR_FLAGS,
 	NFT_TABLE_ATTR_USE,
-	NFT_TABLE_ATTR_DEV,
 	__NFT_TABLE_ATTR_MAX
 };
 #define NFT_TABLE_ATTR_MAX (__NFT_TABLE_ATTR_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 89a671e..a99e6a9 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -122,11 +122,13 @@ enum nft_list_attributes {
  *
  * @NFTA_HOOK_HOOKNUM: netfilter hook number (NLA_U32)
  * @NFTA_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
+ * @NFTA_HOOK_DEV: netdevice name (NLA_STRING)
  */
 enum nft_hook_attributes {
 	NFTA_HOOK_UNSPEC,
 	NFTA_HOOK_HOOKNUM,
 	NFTA_HOOK_PRIORITY,
+	NFTA_HOOK_DEV,
 	__NFTA_HOOK_MAX
 };
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
@@ -146,14 +148,12 @@ enum nft_table_flags {
  * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
  * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
  * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
- * @NFTA_TABLE_DEV: net device name (NLA_STRING)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
 	NFTA_TABLE_NAME,
 	NFTA_TABLE_FLAGS,
 	NFTA_TABLE_USE,
-	NFTA_TABLE_DEV,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
diff --git a/src/chain.c b/src/chain.c
index 74e5925..ed9d9e4 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -35,6 +35,7 @@ struct nft_chain {
 	char		name[NFT_CHAIN_MAXNAMELEN];
 	const char	*type;
 	const char	*table;
+	const char	*dev;
 	uint32_t	family;
 	uint32_t	policy;
 	uint32_t	hooknum;
@@ -98,6 +99,8 @@ void nft_chain_free(struct nft_chain *c)
 		xfree(c->table);
 	if (c->type != NULL)
 		xfree(c->type);
+	if (c->dev != NULL)
+		xfree(c->dev);
 
 	xfree(c);
 }
@@ -138,6 +141,12 @@ void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr)
 	case NFT_CHAIN_ATTR_HANDLE:
 	case NFT_CHAIN_ATTR_FAMILY:
 		break;
+	case NFT_CHAIN_ATTR_DEV:
+		if (c->dev) {
+			xfree(c->dev);
+			c->dev = NULL;
+		}
+		break;
 	default:
 		return;
 	}
@@ -204,6 +213,12 @@ void nft_chain_attr_set_data(struct nft_chain *c, uint16_t attr,
 
 		c->type = strdup(data);
 		break;
+	case NFT_CHAIN_ATTR_DEV:
+		if (c->dev)
+			xfree(c->dev);
+
+		c->dev = strdup(data);
+		break;
 	}
 	c->flags |= (1 << attr);
 }
@@ -283,6 +298,8 @@ const void *nft_chain_attr_get_data(struct nft_chain *c, uint16_t attr,
 	case NFT_CHAIN_ATTR_TYPE:
 		*data_len = sizeof(uint32_t);
 		return c->type;
+	case NFT_CHAIN_ATTR_DEV:
+		return c->dev;
 	}
 	return NULL;
 }
@@ -358,6 +375,8 @@ void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain
 		nest = mnl_attr_nest_start(nlh, NFTA_CHAIN_HOOK);
 		mnl_attr_put_u32(nlh, NFTA_HOOK_HOOKNUM, htonl(c->hooknum));
 		mnl_attr_put_u32(nlh, NFTA_HOOK_PRIORITY, htonl(c->prio));
+		if (c->flags & (1 << NFT_CHAIN_ATTR_DEV))
+			mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, c->dev);
 		mnl_attr_nest_end(nlh, nest);
 	}
 	if (c->flags & (1 << NFT_CHAIN_ATTR_POLICY))
@@ -467,6 +486,10 @@ static int nft_chain_parse_hook_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	case NFTA_HOOK_DEV:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -488,6 +511,10 @@ static int nft_chain_parse_hook(struct nlattr *attr, struct nft_chain *c)
 		c->prio = ntohl(mnl_attr_get_u32(tb[NFTA_HOOK_PRIORITY]));
 		c->flags |= (1 << NFT_CHAIN_ATTR_PRIO);
 	}
+	if (tb[NFTA_HOOK_DEV]) {
+		c->dev = strdup(mnl_attr_get_str(tb[NFTA_HOOK_DEV]));
+		c->flags |= (1 << NFT_CHAIN_ATTR_DEV);
+	}
 
 	return 0;
 }
@@ -563,7 +590,7 @@ int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 	uint64_t handle, bytes, packets;
 	int policy_num;
 	int32_t family, prio, hooknum, use;
-	const char *name, *table, *type, *hooknum_str, *policy;
+	const char *name, *table, *type, *hooknum_str, *policy, *dev;
 
 	root = nft_jansson_get_node(tree, "chain", err);
 	if (root == NULL)
@@ -626,6 +653,10 @@ int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 			nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY,
 					       policy_num);
 		}
+
+		dev = nft_jansson_parse_str(root, "device", err);
+		if (dev != NULL)
+			nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_DEV, dev);
 	}
 
 	return 0;
@@ -660,7 +691,7 @@ static int nft_chain_json_parse(struct nft_chain *c, const void *json,
 int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 			 struct nft_parse_err *err)
 {
-	const char *table, *name, *hooknum_str, *policy_str, *type;
+	const char *table, *name, *hooknum_str, *policy_str, *type, *dev;
 	int family, hooknum, policy;
 	uint64_t handle, bytes, packets, prio, use;
 
@@ -729,6 +760,11 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 			nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY,
 					       policy);
 		}
+		dev = nft_mxml_str_parse(tree, "device", MXML_DESCEND_FIRST,
+					 NFT_XML_MAND, err);
+
+		if (table != NULL)
+			nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_DEV, dev);
 	}
 
 	return 0;
@@ -824,6 +860,8 @@ static int nft_chain_export(char *buf, size_t size, struct nft_chain *c,
 			nft_buf_s32(&b, type, c->prio, PRIO);
 		if (c->flags & (1 << NFT_CHAIN_ATTR_POLICY))
 			nft_buf_str(&b, type, nft_verdict2str(c->policy), POLICY);
+		if (c->flags & (1 << NFT_CHAIN_ATTR_DEV))
+			nft_buf_str(&b, type, c->dev, DEVICE);
 	}
 
 	nft_buf_close(&b, type, CHAIN);
@@ -848,6 +886,11 @@ static int nft_chain_snprintf_default(char *buf, size_t size,
 			       c->prio, nft_verdict2str(c->policy),
 			       c->packets, c->bytes);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		if (c->flags & (1 << NFT_CHAIN_ATTR_DEV)) {
+			ret = snprintf(buf+offset, len, " dev %s ", c->dev);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
 	}
 
 	return offset;
diff --git a/src/table.c b/src/table.c
index f748d6d..ab0a8ea 100644
--- a/src/table.c
+++ b/src/table.c
@@ -32,7 +32,6 @@ struct nft_table {
 	const char	*name;
 	uint32_t	family;
 	uint32_t	table_flags;
-	const char	*dev;
 	uint32_t	use;
 	uint32_t	flags;
 };
@@ -75,12 +74,6 @@ void nft_table_attr_unset(struct nft_table *t, uint16_t attr)
 		break;
 	case NFT_TABLE_ATTR_USE:
 		break;
-	case NFT_TABLE_ATTR_DEV:
-		if (t->dev) {
-			xfree(t->dev);
-			t->dev = NULL;
-		}
-		break;
 	}
 	t->flags &= ~(1 << attr);
 }
@@ -115,12 +108,6 @@ void nft_table_attr_set_data(struct nft_table *t, uint16_t attr,
 	case NFT_TABLE_ATTR_USE:
 		t->use = *((uint32_t *)data);
 		break;
-	case NFT_TABLE_ATTR_DEV:
-		if (t->dev)
-			xfree(t->dev);
-
-		t->dev = strdup(data);
-		break;
 	}
 	t->flags |= (1 << attr);
 }
@@ -168,8 +155,6 @@ const void *nft_table_attr_get_data(struct nft_table *t, uint16_t attr,
 	case NFT_TABLE_ATTR_USE:
 		*data_len = sizeof(uint32_t);
 		return &t->use;
-	case NFT_TABLE_ATTR_DEV:
-		return t->dev;
 	}
 	return NULL;
 }
@@ -208,8 +193,6 @@ void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table
 		mnl_attr_put_strz(nlh, NFTA_TABLE_NAME, t->name);
 	if (t->flags & (1 << NFT_TABLE_ATTR_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_TABLE_FLAGS, htonl(t->table_flags));
-	if (t->flags & (1 << NFT_TABLE_ATTR_DEV))
-		mnl_attr_put_str(nlh, NFTA_TABLE_DEV, t->dev);
 }
 EXPORT_SYMBOL(nft_table_nlmsg_build_payload);
 
@@ -223,7 +206,6 @@ static int nft_table_parse_attr_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_TABLE_NAME:
-	case NFTA_TABLE_DEV:
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
@@ -258,10 +240,6 @@ int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t)
 		t->use = ntohl(mnl_attr_get_u32(tb[NFTA_TABLE_USE]));
 		t->flags |= (1 << NFT_TABLE_ATTR_USE);
 	}
-	if (tb[NFTA_TABLE_DEV]) {
-		t->dev = strdup(mnl_attr_get_str(tb[NFTA_TABLE_DEV]));
-		t->flags |= (1 << NFT_TABLE_ATTR_DEV);
-	}
 
 	t->family = nfg->nfgen_family;
 	t->flags |= (1 << NFT_TABLE_ATTR_FAMILY);
@@ -274,7 +252,7 @@ EXPORT_SYMBOL(nft_table_nlmsg_parse);
 int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
 			 struct nft_parse_err *err)
 {
-	const char *name, *dev;
+	const char *name;
 	int family;
 	uint32_t flags, use;
 
@@ -292,11 +270,6 @@ int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
 			       &flags, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
 		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
 
-	dev = nft_mxml_str_parse(tree, "device", MXML_DESCEND_FIRST,
-				 NFT_XML_MAND, err);
-	if (dev != NULL)
-		nft_table_attr_set_str(t, NFT_TABLE_ATTR_DEV, dev);
-
 	if (nft_mxml_num_parse(tree, "use", MXML_DESCEND, BASE_DEC,
 			       &use, NFT_TYPE_U32, NFT_XML_MAND, err) == 0)
 		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_USE, use);
@@ -330,7 +303,7 @@ int nft_jansson_parse_table(struct nft_table *t, json_t *tree,
 {
 	json_t *root;
 	uint32_t flags, use;
-	const char *str, *dev;
+	const char *str;
 	int family;
 
 	root = nft_jansson_get_node(tree, "table", err);
@@ -348,10 +321,6 @@ int nft_jansson_parse_table(struct nft_table *t, json_t *tree,
 				  err) == 0)
 		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
 
-	dev = nft_jansson_parse_str(root, "device", err);
-	if (dev != NULL)
-		nft_table_attr_set_str(t, NFT_TABLE_ATTR_DEV, dev);
-
 	if (nft_jansson_parse_val(root, "use", NFT_TYPE_U32, &use, err) == 0)
 		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_USE, use);
 
@@ -435,8 +404,6 @@ static int nft_table_export(char *buf, size_t size, struct nft_table *t,
 		nft_buf_str(&b, type, nft_family2str(t->family), FAMILY);
 	if (t->flags & (1 << NFT_TABLE_ATTR_FLAGS))
 		nft_buf_u32(&b, type, t->table_flags, FLAGS);
-	if (t->flags & (1 << NFT_TABLE_ATTR_DEV))
-		nft_buf_str(&b, type, t->dev, DEVICE);
 	if (t->flags & (1 << NFT_TABLE_ATTR_USE))
 		nft_buf_u32(&b, type, t->use, USE);
 
diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
index 1ff8334..ff8afed 100644
--- a/tests/nft-chain-test.c
+++ b/tests/nft-chain-test.c
@@ -59,6 +59,9 @@ static void cmp_nft_chain(struct nft_chain *a, struct nft_chain *b)
 	if (strcmp(nft_chain_attr_get_str(a, NFT_CHAIN_ATTR_TYPE),
 		   nft_chain_attr_get_str(b, NFT_CHAIN_ATTR_TYPE)) != 0)
 		print_err("Chain type mismatches");
+	if (strcmp(nft_chain_attr_get_str(a, NFT_CHAIN_ATTR_DEV),
+		   nft_chain_attr_get_str(b, NFT_CHAIN_ATTR_DEV)) != 0)
+		print_err("Chain device mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -83,6 +86,7 @@ int main(int argc, char *argv[])
 	nft_chain_attr_set_u64(a, NFT_CHAIN_ATTR_BYTES, 0x1234567812345678);
 	nft_chain_attr_set_u64(a, NFT_CHAIN_ATTR_HANDLE, 0x1234567812345678);
 	nft_chain_attr_set_str(a, NFT_CHAIN_ATTR_TYPE, "Prueba");
+	nft_chain_attr_set_str(a, NFT_CHAIN_ATTR_DEV, "eth0");
 
 	/* cmd extracted from include/linux/netfilter/nf_tables.h */
 	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET,
diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
index 4714131..2096ea5 100644
--- a/tests/nft-table-test.c
+++ b/tests/nft-table-test.c
@@ -35,27 +35,24 @@ static void cmp_nft_table(struct nft_table *a, struct nft_table *b)
 	if (nft_table_attr_get_u32(a, NFT_TABLE_ATTR_FAMILY) !=
 	    nft_table_attr_get_u32(b, NFT_TABLE_ATTR_FAMILY))
 		print_err("tabke family mismatches");
-	if (strcmp(nft_table_attr_get_str(a, NFT_TABLE_ATTR_DEV),
-		   nft_table_attr_get_str(b, NFT_TABLE_ATTR_DEV)) != 0)
-		print_err("table name mismatches");
 }
 
 int main(int argc, char *argv[])
 {
 	char buf[4096];
 	struct nlmsghdr *nlh;
-	struct nft_table *a;
-	struct nft_table *b;
 
+	struct nft_table *a = NULL;
+	struct nft_table *b = NULL;
 	a = nft_table_alloc();
 	b = nft_table_alloc();
+
 	if (a == NULL || b == NULL)
 		print_err("OOM");
 
 	nft_table_attr_set_str(a, NFT_TABLE_ATTR_NAME, "test");
 	nft_table_attr_set_u32(a, NFT_TABLE_ATTR_FAMILY, AF_INET);
 	nft_table_attr_set_u32(a, NFT_TABLE_ATTR_FLAGS, 0);
-	nft_table_attr_set_str(a, NFT_TABLE_ATTR_DEV, "test");
 
 	/* cmd extracted from include/linux/netfilter/nf_tables.h */
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, AF_INET, 0,
-- 
1.7.10.4


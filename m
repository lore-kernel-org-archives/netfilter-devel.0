From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables - PATCH] chain: Add support for NFTA_CHAIN_NEW_NAME attribute
Date: Wed, 31 Oct 2012 11:30:59 +0200
Message-ID: <1351675859-14264-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:32758 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab2JaJbD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:31:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/libnftables/chain.h         |  1 +
 include/linux/netfilter/nf_tables.h |  1 +
 src/chain.c                         | 21 +++++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index 4325fad..39e4b9a 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -22,6 +22,7 @@ enum {
 	NFT_CHAIN_ATTR_USE,
 	NFT_CHAIN_ATTR_BYTES,
 	NFT_CHAIN_ATTR_PACKETS	= 8,
+	NFT_CHAIN_ATTR_NEW_NAME,
 };
 
 void nft_chain_attr_set(struct nft_chain *t, uint16_t attr, void *data);
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 791072b..64ef974 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -67,6 +67,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_HOOK,
 	NFTA_CHAIN_POLICY,
 	NFTA_CHAIN_USE,
+	NFTA_CHAIN_NEW_NAME,
 	NFTA_CHAIN_COUNTERS,
 	__NFTA_CHAIN_MAX
 };
diff --git a/src/chain.c b/src/chain.c
index fd95a64..162677e 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -36,6 +36,7 @@ struct nft_chain {
 	uint64_t	packets;
 	uint64_t	bytes;
 	uint32_t	flags;
+	char            *new_name;
 };
 
 struct nft_chain *nft_chain_alloc(void)
@@ -88,6 +89,12 @@ void nft_chain_attr_set(struct nft_chain *c, uint16_t attr, void *data)
 	case NFT_CHAIN_ATTR_PACKETS:
 		c->bytes = *((uint64_t *)data);
 		break;
+	case NFT_CHAIN_ATTR_NEW_NAME:
+		if (c->new_name)
+			free(c->new_name);
+
+		c->new_name = strdup(data);
+		break;
 	default:
 		return;
 	}
@@ -163,6 +170,12 @@ void *nft_chain_attr_get(struct nft_chain *c, uint16_t attr)
 		else
 			return NULL;
 		break;
+	case NFT_CHAIN_ATTR_NEW_NAME:
+		if (c->flags & (1 << NFT_CHAIN_ATTR_NEW_NAME))
+			return c->new_name;
+		else
+			return NULL;
+		break;
 	default:
 		return NULL;
 	}
@@ -243,6 +256,8 @@ void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain
 		mnl_attr_put_u64(nlh, NFTA_COUNTER_BYTES, be64toh(c->bytes));
 		mnl_attr_nest_end(nlh, nest);
 	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_NEW_NAME))
+		mnl_attr_put_strz(nlh, NFTA_CHAIN_NEW_NAME, c->new_name);
 }
 EXPORT_SYMBOL(nft_chain_nlmsg_build_payload);
 
@@ -257,6 +272,7 @@ static int nft_chain_parse_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_CHAIN_NAME:
 	case NFTA_CHAIN_TABLE:
+	case NFTA_CHAIN_NEW_NAME:
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -390,6 +406,11 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *c)
 	}
 	if (tb[NFTA_CHAIN_COUNTERS])
 		ret = nft_chain_parse_counters(tb[NFTA_CHAIN_COUNTERS], c);
+	if (tb[NFTA_CHAIN_NEW_NAME]) {
+		c->new_name = strdup(mnl_attr_get_str(
+						tb[NFTA_CHAIN_NEW_NAME]));
+		c->flags |= (1 << NFT_CHAIN_ATTR_NEW_NAME);
+	}
 
 	c->family = nfg->nfgen_family;
 
-- 
1.7.12.4


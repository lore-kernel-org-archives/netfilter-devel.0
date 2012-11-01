From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables - v2 PATCH 2/2] chain: Add support for NFTA_CHAIN_NEW_NAME attribute
Date: Thu,  1 Nov 2012 14:20:37 +0200
Message-ID: <1351772437-9015-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351772437-9015-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11359 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933620Ab2KAMUp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:20:45 -0400
In-Reply-To: <1351772437-9015-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/libnftables/chain.h         |  1 +
 include/linux/netfilter/nf_tables.h |  1 +
 src/chain.c                         | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+)

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
index a41f73a..aa84cea 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -69,6 +69,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_HOOK,
 	NFTA_CHAIN_POLICY,
 	NFTA_CHAIN_USE,
+	NFTA_CHAIN_NEW_NAME,
 	NFTA_CHAIN_COUNTERS,
 	__NFTA_CHAIN_MAX
 };
diff --git a/src/chain.c b/src/chain.c
index bdda01c..3b61d92 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -36,6 +36,7 @@ struct nft_chain {
 	uint64_t	packets;
 	uint64_t	bytes;
 	uint32_t	flags;
+	char            new_name[NFT_CHAIN_MAXNAMELEN];
 };
 
 struct nft_chain *nft_chain_alloc(void)
@@ -83,6 +84,9 @@ void nft_chain_attr_set(struct nft_chain *c, uint16_t attr, void *data)
 	case NFT_CHAIN_ATTR_PACKETS:
 		c->bytes = *((uint64_t *)data);
 		break;
+	case NFT_CHAIN_ATTR_NEW_NAME:
+		strncpy(c->new_name, data, NFT_CHAIN_MAXNAMELEN);
+		break;
 	default:
 		return;
 	}
@@ -158,6 +162,12 @@ void *nft_chain_attr_get(struct nft_chain *c, uint16_t attr)
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
@@ -238,6 +248,8 @@ void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain
 		mnl_attr_put_u64(nlh, NFTA_COUNTER_BYTES, be64toh(c->bytes));
 		mnl_attr_nest_end(nlh, nest);
 	}
+	if (c->flags & (1 << NFT_CHAIN_ATTR_NEW_NAME))
+		mnl_attr_put_strz(nlh, NFTA_CHAIN_NEW_NAME, c->new_name);
 }
 EXPORT_SYMBOL(nft_chain_nlmsg_build_payload);
 
@@ -252,6 +264,7 @@ static int nft_chain_parse_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_CHAIN_NAME:
 	case NFTA_CHAIN_TABLE:
+	case NFTA_CHAIN_NEW_NAME:
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -386,6 +399,11 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *c)
 	}
 	if (tb[NFTA_CHAIN_COUNTERS])
 		ret = nft_chain_parse_counters(tb[NFTA_CHAIN_COUNTERS], c);
+	if (tb[NFTA_CHAIN_NEW_NAME]) {
+		strncpy(c->new_name, mnl_attr_get_str(tb[NFTA_CHAIN_NEW_NAME]),
+			NFT_CHAIN_MAXNAMELEN);
+		c->flags |= (1 << NFT_CHAIN_ATTR_NEW_NAME);
+	}
 
 	c->family = nfg->nfgen_family;
 
-- 
1.7.12.4


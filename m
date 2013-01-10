From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC PATCH 3/6] nft: Use handle's family attribute instead of hardcoded AF_INET one
Date: Thu, 10 Jan 2013 16:29:36 +0200
Message-ID: <1357828179-18664-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:14646 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab3AJO3r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:29:47 -0500
In-Reply-To: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This permits to deal with the right family in use, provided by xtables.c

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 9296b88..78a100e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -248,7 +248,7 @@ nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
 					NFT_TABLE_F_DORMANT);
 	}
 
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, AF_INET,
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, h->family,
 					NLM_F_ACK|NLM_F_EXCL, h->seq);
 	nft_table_nlmsg_build_payload(nlh, t);
 	nft_table_free(t);
@@ -294,7 +294,7 @@ nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
 		return;
 
 	/* NLM_F_CREATE requests module autoloading */
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET,
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
 					NLM_F_ACK|NLM_F_EXCL|NLM_F_CREATE,
 					h->seq);
 	nft_chain_nlmsg_build_payload(nlh, c);
@@ -410,7 +410,7 @@ int nft_table_add(struct nft_handle *h, const struct nft_table *t)
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, AF_INET,
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, h->family,
 					NLM_F_ACK|NLM_F_EXCL, h->seq);
 	nft_table_nlmsg_build_payload(nlh, t);
 
@@ -422,7 +422,7 @@ int nft_chain_add(struct nft_handle *h, const struct nft_chain *c)
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET,
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
 					NLM_F_ACK|NLM_F_EXCL, h->seq);
 	nft_chain_nlmsg_build_payload(nlh, c);
 
@@ -464,7 +464,7 @@ int nft_table_wake_dormant(struct nft_handle *h, const char *table)
 	nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, (char *)table);
 	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, 0);
 
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, AF_INET,
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, h->family,
 					NLM_F_ACK, h->seq);
 	nft_table_nlmsg_build_payload(nlh, t);
 	nft_table_free(t);
@@ -525,7 +525,7 @@ __nft_chain_set(struct nft_handle *h, const char *table,
 					counters->pcnt);
 	}
 
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET,
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
 					NLM_F_ACK, h->seq);
 	nft_chain_nlmsg_build_payload(nlh, c);
 
@@ -877,7 +877,7 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 	}
 
 	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
-				       AF_INET, flags, h->seq);
+				       h->family, flags, h->seq);
 
 	nft_rule_nlmsg_build_payload(nlh, r);
 
@@ -1328,7 +1328,7 @@ static struct nft_chain_list *nft_chain_list_get(struct nft_handle *h)
 		return 0;
 	}
 
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, AF_INET,
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
 					NLM_F_DUMP, h->seq);
 
 	ret = mnl_talk(h, nlh, nft_chain_list_cb, list);
@@ -1440,7 +1440,7 @@ static struct nft_rule_list *nft_rule_list_get(struct nft_handle *h)
 		return 0;
 	}
 
-	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, AF_INET,
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, h->family,
 					NLM_F_DUMP, h->seq);
 
 	ret = mnl_talk(h, nlh, nft_rule_list_cb, list);
@@ -1506,7 +1506,7 @@ __nft_rule_flush(struct nft_handle *h, const char *table, const char *chain)
 	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, (char *)chain);
 
 	/* Delete all rules in this table + chain */
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_DELRULE, AF_INET,
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_DELRULE, h->family,
 					NLM_F_ACK, h->seq);
 	nft_rule_nlmsg_build_payload(nlh, r);
 	nft_rule_free(r);
@@ -1583,7 +1583,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	nft_chain_attr_set(c, NFT_CHAIN_ATTR_TABLE, (char *)table);
 	nft_chain_attr_set(c, NFT_CHAIN_ATTR_NAME, (char *)chain);
 
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET,
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
 					NLM_F_ACK|NLM_F_EXCL, h->seq);
 	nft_chain_nlmsg_build_payload(nlh, c);
 	nft_chain_free(c);
@@ -1604,7 +1604,7 @@ static int __nft_chain_del(struct nft_handle *h, struct nft_chain *c)
 	struct nlmsghdr *nlh;
 	int ret;
 
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN, AF_INET,
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN, h->family,
 					NLM_F_ACK, h->seq);
 	nft_chain_nlmsg_build_payload(nlh, c);
 
@@ -1750,7 +1750,7 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	nft_chain_attr_set(c, NFT_CHAIN_ATTR_NAME, (char *)newname);
 	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_HANDLE, handle);
 
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET,
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
 					NLM_F_ACK, h->seq);
 	nft_chain_nlmsg_build_payload(nlh, c);
 	nft_chain_free(c);
@@ -1803,7 +1803,7 @@ static struct nft_table_list *nft_table_list_get(struct nft_handle *h)
 		return 0;
 	}
 
-	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, AF_INET,
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, h->family,
 					NLM_F_DUMP, h->seq);
 
 	ret = mnl_talk(h, nlh, nft_table_list_cb, list);
@@ -2342,7 +2342,7 @@ __nft_rule_del(struct nft_handle *h, struct nft_rule *r)
 	struct nlmsghdr *nlh;
 	int ret;
 
-	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_DELRULE, AF_INET,
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_DELRULE, h->family,
 					NLM_F_ACK, h->seq);
 	nft_rule_nlmsg_build_payload(nlh, r);
 
-- 
1.8.0.2


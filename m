From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables - v2 PATCH 1/2] chain: Handle fixed sized name
Date: Thu,  1 Nov 2012 14:20:36 +0200
Message-ID: <1351772437-9015-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351772437-9015-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11359 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933492Ab2KAMUo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:20:44 -0400
In-Reply-To: <1351772437-9015-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 include/linux/netfilter/nf_tables.h |  2 ++
 src/chain.c                         | 12 ++++--------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 791072b..a41f73a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
+#define NFT_CHAIN_MAXNAMELEN 32
+
 enum nft_registers {
 	NFT_REG_VERDICT,
 	NFT_REG_1,
diff --git a/src/chain.c b/src/chain.c
index fd95a64..bdda01c 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -26,7 +26,7 @@
 struct nft_chain {
 	struct list_head head;
 
-	char		*name;
+	char		name[NFT_CHAIN_MAXNAMELEN];
 	char		*table;
 	uint8_t		family;
 	uint32_t	policy;
@@ -46,8 +46,6 @@ EXPORT_SYMBOL(nft_chain_alloc);
 
 void nft_chain_free(struct nft_chain *c)
 {
-	if (c->name != NULL)
-		free(c->name);
 	if (c->table != NULL)
 		free(c->table);
 
@@ -59,10 +57,7 @@ void nft_chain_attr_set(struct nft_chain *c, uint16_t attr, void *data)
 {
 	switch(attr) {
 	case NFT_CHAIN_ATTR_NAME:
-		if (c->name)
-			free(c->name);
-
-		c->name = strdup(data);
+		strncpy(c->name, data, NFT_CHAIN_MAXNAMELEN);
 		break;
 	case NFT_CHAIN_ATTR_TABLE:
 		if (c->table)
@@ -371,7 +366,8 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_chain *c)
 
 	mnl_attr_parse(nlh, sizeof(*nfg), nft_chain_parse_attr_cb, tb);
 	if (tb[NFTA_CHAIN_NAME]) {
-		c->name = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_NAME]));
+		strncpy(c->name, mnl_attr_get_str(tb[NFTA_CHAIN_NAME]),
+			NFT_CHAIN_MAXNAMELEN);
 		c->flags |= (1 << NFT_CHAIN_ATTR_NAME);
 	}
 	if (tb[NFTA_CHAIN_TABLE]) {
-- 
1.7.12.4


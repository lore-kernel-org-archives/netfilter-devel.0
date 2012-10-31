From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 2/5] nft: Add support for chain rename options (-E)
Date: Wed, 31 Oct 2012 11:31:05 +0200
Message-ID: <1351675868-14302-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351675868-14302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33152 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab2JaJbO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:31:14 -0400
In-Reply-To: <1351675868-14302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nf_tables.h |  1 +
 iptables/nft.c                      | 33 ++++++++++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 74a521a..63480b3 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -67,6 +67,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_HOOK,
 	NFTA_CHAIN_POLICY,
 	NFTA_CHAIN_USE,
+	NFTA_CHAIN_NEW_NAME,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
diff --git a/iptables/nft.c b/iptables/nft.c
index 6d2de99..0454725 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1570,14 +1570,37 @@ err:
 int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 			  const char *table, const char *newname)
 {
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_chain *c;
 	int ret;
 
-	/* XXX need new operation in nf_tables to support this */
-	ret = nft_chain_user_del(h, chain, table);
-	if (ret < 0)
-		return ret;
+	/* If built-in chains don't exist for this table, create them */
+	nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
 
-	return nft_chain_user_add(h, newname, table);
+	c = nft_chain_alloc();
+	if (c == NULL) {
+		DEBUGP("cannot allocate chain\n");
+		return -1;
+	}
+
+	nft_chain_attr_set(c, NFT_CHAIN_ATTR_TABLE, (char *)table);
+	nft_chain_attr_set(c, NFT_CHAIN_ATTR_NAME, (char *)chain);
+	nft_chain_attr_set(c, NFT_CHAIN_ATTR_NEW_NAME, (char *)newname);
+
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET,
+					NLM_F_ACK|NLM_F_REPLACE, h->seq);
+	nft_chain_nlmsg_build_payload(nlh, c);
+	nft_chain_free(c);
+
+	ret = mnl_talk(h, nlh, NULL, NULL);
+	if (ret < 0) {
+		if (errno != EEXIST)
+			perror("mnl_talk:nft_chain_rename");
+	}
+
+	/* the core expects 1 for success and 0 for error */
+	return ret == 0 ? 1 : 0;
 }
 
 static int nft_table_list_cb(const struct nlmsghdr *nlh, void *data)
-- 
1.7.12.4


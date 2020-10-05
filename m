Return-Path: <SRS0=VfFo=DM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50727C4363A
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 14:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2330C20776
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 14:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgJEO2k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Oct 2020 10:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJEO2h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Oct 2020 10:28:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45DCC0613CE
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2020 07:28:36 -0700 (PDT)
Received: from localhost ([::1]:58620 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kPRTf-0005Hm-DO; Mon, 05 Oct 2020 16:28:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 1/3] nft: Make batch_add_chain() return the added batch object
Date:   Mon,  5 Oct 2020 16:48:56 +0200
Message-Id: <20201005144858.11578-2-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005144858.11578-1-phil@nwl.cc>
References: <20201005144858.11578-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do this so in a later patch the 'skip' field can be adjusted.

While being at it, simplify a few callers and eliminate the need for a
'ret' variable.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 775ace385c184..09421cf4eaaec 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -388,10 +388,11 @@ batch_set_add(struct nft_handle *h, enum obj_update_type type,
 	return batch_add(h, type, s);
 }
 
-static int batch_chain_add(struct nft_handle *h, enum obj_update_type type,
+static struct obj_update *
+batch_chain_add(struct nft_handle *h, enum obj_update_type type,
 			   struct nftnl_chain *c)
 {
-	return batch_add(h, type, c) ? 0 : -1;
+	return batch_add(h, type, c);
 }
 
 static struct obj_update *
@@ -905,7 +906,6 @@ int nft_chain_set(struct nft_handle *h, const char *table,
 		  const struct xt_counters *counters)
 {
 	struct nftnl_chain *c = NULL;
-	int ret;
 
 	nft_fn = nft_chain_set;
 
@@ -932,10 +932,11 @@ int nft_chain_set(struct nft_handle *h, const char *table,
 	if (c == NULL)
 		return 0;
 
-	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_UPDATE, c);
+	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_UPDATE, c))
+		return 0;
 
 	/* the core expects 1 for success and 0 for error */
-	return ret == 0 ? 1 : 0;
+	return 1;
 }
 
 static int __add_match(struct nftnl_expr *e, struct xt_entry_match *m)
@@ -1725,7 +1726,6 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 {
 	struct nftnl_chain_list *list;
 	struct nftnl_chain *c;
-	int ret;
 
 	nft_fn = nft_chain_user_add;
 
@@ -1745,14 +1745,15 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	if (h->family == NFPROTO_BRIDGE)
 		nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, NF_ACCEPT);
 
-	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
+	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c))
+		return 0;
 
 	list = nft_chain_list_get(h, table, chain);
 	if (list)
 		nftnl_chain_list_add(c, list);
 
 	/* the core expects 1 for success and 0 for error */
-	return ret == 0 ? 1 : 0;
+	return 1;
 }
 
 int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table)
@@ -1760,7 +1761,6 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 	struct nftnl_chain_list *list;
 	struct nftnl_chain *c;
 	bool created = false;
-	int ret;
 
 	nft_xt_builtin_init(h, table);
 
@@ -1787,14 +1787,15 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 	if (!created)
 		return 1;
 
-	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
+	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c))
+		return 0;
 
 	list = nft_chain_list_get(h, table, chain);
 	if (list)
 		nftnl_chain_list_add(c, list);
 
 	/* the core expects 1 for success and 0 for error */
-	return ret == 0 ? 1 : 0;
+	return 1;
 }
 
 /* From linux/netlink.h */
@@ -1812,7 +1813,6 @@ static int __nft_chain_user_del(struct nftnl_chain *c, void *data)
 {
 	struct chain_user_del_data *d = data;
 	struct nft_handle *h = d->handle;
-	int ret;
 
 	/* don't delete built-in chain */
 	if (nft_chain_builtin(c))
@@ -1824,8 +1824,7 @@ static int __nft_chain_user_del(struct nftnl_chain *c, void *data)
 
 	/* XXX This triggers a fast lookup from the kernel. */
 	nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
-	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_DEL, c);
-	if (ret)
+	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_DEL, c))
 		return -1;
 
 	nftnl_chain_list_del(c);
@@ -1900,7 +1899,6 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 {
 	struct nftnl_chain *c;
 	uint64_t handle;
-	int ret;
 
 	nft_fn = nft_chain_user_rename;
 
@@ -1929,10 +1927,11 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, newname);
 	nftnl_chain_set_u64(c, NFTNL_CHAIN_HANDLE, handle);
 
-	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_RENAME, c);
+	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_RENAME, c))
+		return 0;
 
 	/* the core expects 1 for success and 0 for error */
-	return ret == 0 ? 1 : 0;
+	return 1;
 }
 
 bool nft_table_find(struct nft_handle *h, const char *tablename)
@@ -3296,7 +3295,7 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 		nftnl_chain_set_u64(c, NFTNL_CHAIN_PACKETS, 0);
 		nftnl_chain_set_u64(c, NFTNL_CHAIN_BYTES, 0);
 		nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
-		if (batch_chain_add(h, NFT_COMPAT_CHAIN_ZERO, c))
+		if (!batch_chain_add(h, NFT_COMPAT_CHAIN_ZERO, c))
 			return -1;
 	}
 
-- 
2.28.0


Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CB1C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 17:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357523AbiBDRAQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 12:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiBDRAP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 12:00:15 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB10C061714
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Feb 2022 09:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sEM5KISJ69HloS3gbhsv9mwpysu3dbuiJCf6r0pj2R8=; b=P9U5E1JSOPUkada5GYgCrF8+ae
        fSvmavKPHor94Yw9LwSzLD8WaMLR1gcFjFEFpe4vtwLsYAJc+v9X+5R6vAujE2S8/1sr6SxdSbcmu
        i5OSMPYT3achG+DCGlA0KZP21ySDVMArruyYTmo8BO+rQadMmy1zNbARGlFRqsZyy1pqkorGot30l
        7uteB3fn75BpxPVFStp1kBbdRihA7SdgqWdfL6goSLyIHbbeSmZSWoCn+CYxDJa5oBCnHnqThuh0j
        6R0W06xf4gQ8Fuq1kmV041WkqdoExwVriF03v7N/+NhxZRKXGS2qGrTto76Z5cjhs56wm+rWmY+xm
        puLTMEpg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nG1wT-00049T-6M; Fri, 04 Feb 2022 18:00:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/4] nft: Set NFTNL_CHAIN_FAMILY in new chains
Date:   Fri,  4 Feb 2022 17:59:58 +0100
Message-Id: <20220204170001.27198-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel doesn't need it, but debug output improves significantly. Before
this patch:

| # iptables-nft -vv -A INPUT
| [...]
| unknown filter INPUT use 0 type filter hook unknown prio 0 policy accept packets 0 bytes 0
| [...]

and after:

| # iptables-nft -vv -A INPUT
| [...]
| ip filter INPUT use 0 type filter hook input prio 0 policy accept packets 0 bytes 0
| [...]

While being at it, make nft_chain_builtin_alloc() take only the builtin
table's name as parameter - it's the only field it accesses.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 7cc6ca5258150..301d6c342f982 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -665,7 +665,7 @@ static int nft_table_builtin_add(struct nft_handle *h,
 }
 
 static struct nftnl_chain *
-nft_chain_builtin_alloc(const struct builtin_table *table,
+nft_chain_builtin_alloc(int family, const char *tname,
 			const struct builtin_chain *chain, int policy)
 {
 	struct nftnl_chain *c;
@@ -674,7 +674,8 @@ nft_chain_builtin_alloc(const struct builtin_table *table,
 	if (c == NULL)
 		return NULL;
 
-	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table->name);
+	nftnl_chain_set_u32(c, NFTNL_CHAIN_FAMILY, family);
+	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, tname);
 	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain->name);
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_HOOKNUM, chain->hook);
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_PRIO, chain->prio);
@@ -693,7 +694,7 @@ static void nft_chain_builtin_add(struct nft_handle *h,
 {
 	struct nftnl_chain *c;
 
-	c = nft_chain_builtin_alloc(table, chain, NF_ACCEPT);
+	c = nft_chain_builtin_alloc(h->family, table->name, chain, NF_ACCEPT);
 	if (c == NULL)
 		return;
 
@@ -959,7 +960,7 @@ static struct nftnl_chain *nft_chain_new(struct nft_handle *h,
 	_c = nft_chain_builtin_find(_t, chain);
 	if (_c != NULL) {
 		/* This is a built-in chain */
-		c = nft_chain_builtin_alloc(_t, _c, policy);
+		c = nft_chain_builtin_alloc(h->family, _t->name, _c, policy);
 		if (c == NULL)
 			return NULL;
 	} else {
@@ -1999,6 +2000,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	if (c == NULL)
 		return 0;
 
+	nftnl_chain_set_u32(c, NFTNL_CHAIN_FAMILY, h->family);
 	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
 	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
 	if (h->family == NFPROTO_BRIDGE)
@@ -2029,6 +2031,7 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 		if (!c)
 			return 0;
 
+		nftnl_chain_set_u32(c, NFTNL_CHAIN_FAMILY, h->family);
 		nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
 		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
 		created = true;
@@ -2190,6 +2193,7 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	if (c == NULL)
 		return 0;
 
+	nftnl_chain_set_u32(c, NFTNL_CHAIN_FAMILY, h->family);
 	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
 	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, newname);
 	nftnl_chain_set_u64(c, NFTNL_CHAIN_HANDLE, handle);
-- 
2.34.1


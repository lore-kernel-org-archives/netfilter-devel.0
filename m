From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 4/7] netfilter: nf_tables: add flush field to struct nft_set_iter
Date: Wed, 18 Jan 2017 18:30:10 +0100
Message-ID: <1484760613-17236-5-git-send-email-pablo@netfilter.org>
References: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36652 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752583AbdARRaZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 12:30:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 520BF1392A2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37FCAA7DB8
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6B94FF148
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:20 +0100 (CET)
In-Reply-To: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This provides context to walk callback iterator, thus, we know if the
walk happens from the set flush path. This is required by the new bitmap
set type coming in a follow up patch which has no real struct
nft_set_ext, so it has to allocate it based on the two bit compact
element representation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 1 +
 net/netfilter/nf_tables_api.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1c3bf162cef8..deff701137e8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -203,6 +203,7 @@ struct nft_set_elem {
 struct nft_set;
 struct nft_set_iter {
 	u8		genmask;
+	bool		flush;
 	unsigned int	count;
 	unsigned int	skip;
 	int		err;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 26238dba6314..b5f6cb70d3df 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3937,6 +3937,7 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
 		struct nft_set_iter iter = {
 			.genmask	= genmask,
 			.fn		= nft_flush_set,
+			.flush		= true,
 		};
 		set->ops->walk(&ctx, set, &iter);
 
-- 
2.1.4


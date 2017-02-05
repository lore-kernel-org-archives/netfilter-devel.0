From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 2/7] netfilter: nf_tables: use struct nft_set_iter in set element flush
Date: Sun,  5 Feb 2017 21:34:40 +0100
Message-ID: <1486326885-13766-2-git-send-email-pablo@netfilter.org>
References: <1486326885-13766-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41730 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752209AbdBEUfD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Feb 2017 15:35:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31336131CAA
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:34:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23241DA848
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:34:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B884DA729
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Feb 2017 21:34:54 +0100 (CET)
In-Reply-To: <1486326885-13766-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of struct nft_set_dump_args, remove unnecessary wrapper
structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: No changes

 net/netfilter/nf_tables_api.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3643ce345b59..790ffed82930 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3936,15 +3936,13 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
 		return -EBUSY;
 
 	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL) {
-		struct nft_set_dump_args args = {
-			.iter	= {
-				.genmask	= genmask,
-				.fn		= nft_flush_set,
-			},
+		struct nft_set_iter iter = {
+			.genmask	= genmask,
+			.fn		= nft_flush_set,
 		};
-		set->ops->walk(&ctx, set, &args.iter);
+		set->ops->walk(&ctx, set, &iter);
 
-		return args.iter.err;
+		return iter.err;
 	}
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-- 
2.1.4


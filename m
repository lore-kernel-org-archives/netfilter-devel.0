From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/7] netfilter: nf_tables: use struct nft_set_iter in set element flush
Date: Wed, 18 Jan 2017 18:30:08 +0100
Message-ID: <1484760613-17236-3-git-send-email-pablo@netfilter.org>
References: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36644 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752561AbdARRaY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 12:30:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EBDC21392AA
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9D21A7E7C
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7AB51A6B6
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:19 +0100 (CET)
In-Reply-To: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of struct nft_set_dump_args, remove unnecessary wrapper
structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6598a48ead2f..494b49420149 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3934,15 +3934,13 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
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


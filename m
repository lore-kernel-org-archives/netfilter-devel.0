From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/5] netfilter: nf_tables: fix potential oops when dumping sets
Date: Wed,  5 Feb 2014 15:03:35 +0000
Message-ID: <1391612619-30347-2-git-send-email-kaber@trash.net>
References: <1391612619-30347-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57602 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaBEPD5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:03:57 -0500
In-Reply-To: <1391612619-30347-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit c9c8e48597 (netfilter: nf_tables: dump sets in all existing families)
changed nft_ctx_init_from_setattr() to only look up the address family if it
is not NFPROTO_UNSPEC. However if it is NFPROTO_UNSPEC and a table attribute
is given, nftables_afinfo_lookup() will dereference the NULL afi pointer.

Fix by checking for non-NULL afi and also move a check added by that commit
to the proper position.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9ce3053..9579aad 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1943,6 +1943,9 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
 	}
 
 	if (nla[NFTA_SET_TABLE] != NULL) {
+		if (afi == NULL)
+			return -EAFNOSUPPORT;;
+
 		table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE]);
 		if (IS_ERR(table))
 			return PTR_ERR(table);
@@ -2428,6 +2431,8 @@ static int nf_tables_delset(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_ctx ctx;
 	int err;
 
+	if (nfmsg->nfgen_family == NFPROTO_UNSPEC)
+		return -EAFNOSUPPORT;
 	if (nla[NFTA_SET_TABLE] == NULL)
 		return -EINVAL;
 
@@ -2435,9 +2440,6 @@ static int nf_tables_delset(struct sock *nlsk, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	if (nfmsg->nfgen_family == NFPROTO_UNSPEC)
-		return -EAFNOSUPPORT;
-
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME]);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
-- 
1.8.5.3


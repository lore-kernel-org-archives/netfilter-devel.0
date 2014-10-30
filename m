From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next] netfilter: fix spelling errors
Date: Wed, 29 Oct 2014 22:57:19 -0700
Message-ID: <20141029225719.37985b40@urahara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55977 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaJ3F52 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2014 01:57:28 -0400
Received: by mail-pa0-f43.google.com with SMTP id eu11so4764399pac.30
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2014 22:57:28 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>


--- a/net/netfilter/nf_conntrack_helper.c	2014-03-21 08:16:54.297654128 -0700
+++ b/net/netfilter/nf_conntrack_helper.c	2014-10-27 20:33:42.471629995 -0700
@@ -250,7 +250,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
 
-/* appropiate ct lock protecting must be taken by caller */
+/* appropriate ct lock protecting must be taken by caller */
 static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 			 const struct nf_conntrack_helper *me)
 {
--- a/net/netfilter/nf_tables_api.c	2014-10-26 10:43:41.762315418 -0700
+++ b/net/netfilter/nf_tables_api.c	2014-10-27 20:33:27.479554628 -0700
@@ -2477,7 +2477,7 @@ static int nf_tables_getset(struct sock
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	int err;
 
-	/* Verify existance before starting dump */
+	/* Verify existence before starting dump */
 	err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla);
 	if (err < 0)
 		return err;

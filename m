From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] netns nf_conntrack: elegantly simplify nf_ct_exp_net()
Date: Thu, 11 Feb 2010 21:40:41 +0200
Message-ID: <20100211194041.GA7515@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:50030 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab0BKTkn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:40:43 -0500
Received: by fxm7 with SMTP id 7so1661051fxm.28
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 11:40:42 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove #ifdef at nf_ct_exp_net() by using nf_ct_net().

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/net/netfilter/nf_conntrack_expect.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -56,11 +56,7 @@ struct nf_conntrack_expect {
 
 static inline struct net *nf_ct_exp_net(struct nf_conntrack_expect *exp)
 {
-#ifdef CONFIG_NET_NS
-	return exp->master->ct_net;	/* by definition */
-#else
-	return &init_net;
-#endif
+	return nf_ct_net(exp->master);
 }
 
 struct nf_conntrack_expect_policy {

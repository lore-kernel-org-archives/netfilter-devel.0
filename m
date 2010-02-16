From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 48/62: nf_conntrack: elegantly simplify nf_ct_exp_net()
Date: Tue, 16 Feb 2010 15:56:25 +0100 (MET)
Message-ID: <20100216145622.2796.37673.sendpatchset@x2.localnet>
References: <20100216145517.2796.40634.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52086 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab0BPO40 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:56:26 -0500
In-Reply-To: <20100216145517.2796.40634.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 857b409a48bdc33e824dff2d730e271b964e78bd
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Fri Feb 12 06:24:46 2010 +0100

    netfilter: nf_conntrack: elegantly simplify nf_ct_exp_net()
    
    Remove #ifdef at nf_ct_exp_net() by using nf_ct_net().
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 917e170..4b47ec1 100644
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

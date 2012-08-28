From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] netfilter: remove pointless conditional before kfree_skb()
Date: Tue, 28 Aug 2012 21:14:43 +0800
Message-ID: <CAPgLHd_+fxJET1PkriFRqws5gFr5220zqcZCuEU59M2gAB-9KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org
To: pablo@netfilter.org, kaber@trash.net, kuznet@ms2.inr.ac.ru,
	jmorris@namei.org, yoshfuji@linux-ipv6.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33557 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab2H1NOn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:14:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove pointless conditional before kfree_skb().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index c9c78c2..58cf705 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -112,8 +112,7 @@ static unsigned int nf_hashfn(struct inet_frag_queue *q)
 
 static void nf_skb_free(struct sk_buff *skb)
 {
-	if (NFCT_FRAG6_CB(skb)->orig)
-		kfree_skb(NFCT_FRAG6_CB(skb)->orig);
+	kfree_skb(NFCT_FRAG6_CB(skb)->orig);
 }
 
 /* Destruction primitives. */



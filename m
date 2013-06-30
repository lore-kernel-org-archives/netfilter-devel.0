From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/12] netns: exclude ipvs from struct net when IPVS disabled
Date: Mon,  1 Jul 2013 01:54:40 +0200
Message-ID: <1372636481-3705-12-git-send-email-pablo@netfilter.org>
References: <1372636481-3705-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59915 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3F3XzM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jun 2013 19:55:12 -0400
In-Reply-To: <1372636481-3705-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: JunweiZhang <junwei.zhang@6wind.com>

no real problem is fixed, just save a few bytes in
net_namespace structure.

Signed-off-by: JunweiZhang <junwei.zhang@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 include/net/net_namespace.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 495bc57..84e37b1 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -115,7 +115,9 @@ struct net {
 #ifdef CONFIG_XFRM
 	struct netns_xfrm	xfrm;
 #endif
+#if IS_ENABLED(CONFIG_IP_VS)
 	struct netns_ipvs	*ipvs;
+#endif
 	struct sock		*diag_nlsk;
 	atomic_t		rt_genid;
 	atomic_t		fnhe_genid;
-- 
1.7.10.4


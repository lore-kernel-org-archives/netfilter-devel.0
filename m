From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: bridge: unshare bridge info before change
 it
Date: Thu, 20 Nov 2014 12:42:22 +0100
Message-ID: <20141120114222.GA3765@salvia>
References: <1416366453-12090-1-git-send-email-gaofeng@cn.fujitsu.com>
 <20141119130751.GA10748@salvia>
 <546D40DC.6060505@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48627 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaKTLkZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:40:25 -0500
Content-Disposition: inline
In-Reply-To: <546D40DC.6060505@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 20, 2014 at 09:16:12AM +0800, Gao feng wrote:
> On 11/19/2014 09:07 PM, Pablo Neira Ayuso wrote:
> > On Wed, Nov 19, 2014 at 11:07:32AM +0800, Gao feng wrote:
> >> diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
> >> index c755e49..dca7337 100644
> >> --- a/include/linux/netfilter_bridge.h
> >> +++ b/include/linux/netfilter_bridge.h
> >> @@ -81,14 +81,64 @@ static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
> >>  	return 0;
> >>  }
> >>  
> >> +static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
> >> +{
> >> +	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
> >> +	if (likely(skb->nf_bridge))
> >> +		atomic_set(&(skb->nf_bridge->use), 1);
> >> +
> >> +	return skb->nf_bridge;
> >> +}
> >> +
> >> +static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
> >> +{
> >> +	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
> >> +
> >> +	if (atomic_read(&nf_bridge->use) > 1) {
> >> +		struct nf_bridge_info *tmp = nf_bridge_alloc(skb);
> > 
> > nf_bridge_alloc() overwrites the original skb->nf_bridge when
> > unsharing, so this leaks and likely breaks other things.
> > 
> 
> overwrite is what we expected, we store the original nfbridge in the var
> nf_bridge, copy the original to the new. and release the reference of original
> nfbridge. I cannot find anything wrong.

You're right. I overlook we already work with the fetched pointer in
_unshare().

I'm attaching a patch to clean up this. You can use it as starter in
your patch series to split this.

Thanks.

--PNTmBPCT7hxwcZjr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-br_netfilter-cleanup-nf_bridge_alloc-and-nf_bridge_u.patch"

>From 1c6141898a7b82484370ec9c61e3acdaf22eaa91 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 20 Nov 2014 12:28:39 +0100
Subject: [PATCH] br_netfilter: cleanup nf_bridge_alloc() and
 nf_bridge_unshare()

Set skb->nf_bridge out of nf_bridge_alloc() and rework clone logic
in nf_bridge_unshare(). This comes in preparation of Gao feng's
patches.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 1a4f32c..79dc6f7 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -129,27 +129,32 @@ static inline struct net_device *bridge_parent(const struct net_device *dev)
 
 static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
 {
-	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
-	if (likely(skb->nf_bridge))
-		atomic_set(&(skb->nf_bridge->use), 1);
+	struct nf_bridge_info *nf_bridge;
+
+	nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
+	if (nf_bridge == NULL)
+		return NULL;
 
-	return skb->nf_bridge;
+	atomic_set(&nf_bridge->use, 1);
+	return nf_bridge;
 }
 
 static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
 {
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	struct nf_bridge_info *nf_bridge;
 
-	if (atomic_read(&nf_bridge->use) > 1) {
-		struct nf_bridge_info *tmp = nf_bridge_alloc(skb);
+	if (atomic_read(&skb->nf_bridge->use) == 1)
+		return skb->nf_bridge;
+
+	nf_bridge = nf_bridge_alloc(skb);
+	if (nf_bridge == NULL)
+		return NULL;
+
+	memcpy(nf_bridge, skb->nf_bridge, sizeof(struct nf_bridge_info));
+	atomic_set(&nf_bridge->use, 1);
+	nf_bridge_put(skb->nf_bridge);
+	skb->nf_bridge = nf_bridge;
 
-		if (tmp) {
-			memcpy(tmp, nf_bridge, sizeof(struct nf_bridge_info));
-			atomic_set(&tmp->use, 1);
-		}
-		nf_bridge_put(nf_bridge);
-		nf_bridge = tmp;
-	}
 	return nf_bridge;
 }
 
@@ -556,7 +561,8 @@ static unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
 		return NF_DROP;
 
 	nf_bridge_put(skb->nf_bridge);
-	if (!nf_bridge_alloc(skb))
+	skb->nf_bridge = nf_bridge_alloc(skb);
+	if (skb->nf_bridge == NULL)
 		return NF_DROP;
 	if (!setup_pre_routing(skb))
 		return NF_DROP;
@@ -612,7 +618,8 @@ static unsigned int br_nf_pre_routing(const struct nf_hook_ops *ops,
 		return NF_DROP;
 
 	nf_bridge_put(skb->nf_bridge);
-	if (!nf_bridge_alloc(skb))
+	skb->nf_bridge = nf_bridge_alloc(skb);
+	if (skb->nf_bridge == NULL)
 		return NF_DROP;
 	if (!setup_pre_routing(skb))
 		return NF_DROP;
-- 
1.7.10.4


--PNTmBPCT7hxwcZjr--

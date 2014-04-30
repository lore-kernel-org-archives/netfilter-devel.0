From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH] bridge: Superfluous skb->nfct check in br_nf_dev_queue_xmit
Date: Wed, 30 Apr 2014 12:54:50 +0400
Message-ID: <5360BA5A.7020200@parallels.com>
References: <20140428131646.GP31953@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Saikiran Madugula <hummerbliss@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:40337 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758430AbaD3I40 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:56:26 -0400
In-Reply-To: <20140428131646.GP31953@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently bridge can silently drop ipv4 fragments.
If node have loaded nf_defrag_ipv4 module but have no nf_conntrack_ipv4,
br_nf_pre_routing defragments incoming ipv4 fragments
but nfct check in br_nf_dev_queue_xmit does not allow re-fragment combined packet back,
and therefore it is dropped in br_dev_queue_push_xmit without incrementing of any failcounters

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 80e1b0f..6a8407c 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -864,7 +864,7 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 {
 	int ret;
 
-	if (skb->nfct != NULL && skb->protocol == htons(ETH_P_IP) &&
+	if (skb->protocol == htons(ETH_P_IP) &&
 	    skb->len + nf_bridge_mtu_reduction(skb) > skb->dev->mtu &&
 	    !skb_is_gso(skb)) {
 		if (br_parse_ip_options(skb))
-- 
1.7.5.4


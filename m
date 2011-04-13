From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 4/5] netfilter: ipset: bitmap:ip,mac type requires "src" for MAC
Date: Wed, 13 Apr 2011 21:52:35 +0200
Message-ID: <1302724356-19590-5-git-send-email-kadlec@blackhole.kfki.hu>
References: <1302724356-19590-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1302724356-19590-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1302724356-19590-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1302724356-19590-4-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:44664 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758262Ab1DMTwh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:52:37 -0400
In-Reply-To: <1302724356-19590-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Enforce that the second "src/dst" parameter of the set match and SET target
must be "src", because we have access to the source MAC only in the packet.
The previous behaviour, that the type required the second parameter
but actually ignored the value was counter-intuitive and confusing.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 35b4879..913a461 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -344,6 +344,10 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct ipmac data;
 
+	/* MAC can be src only */
+	if (!(flags & IPSET_DIM_TWO_SRC))
+		return 0;
+
 	data.id = ntohl(ip4addr(skb, flags & IPSET_DIM_ONE_SRC));
 	if (data.id < map->first_ip || data.id > map->last_ip)
 		return -IPSET_ERR_BITMAP_RANGE;
-- 
1.7.0.4


From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCHv4 nf-next] netfilter: bridge: fix IPv6 packets not being bridged with CONFIG_IPV6=n
Date: Thu, 13 Aug 2015 08:58:15 +0200
Message-ID: <1439449095-21947-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.134]:54864 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbbHMG7e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2015 02:59:34 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id D9FF2613A4
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2015 08:59:31 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

230ac490f7fba introduced a dependency to CONFIG_IPV6 which breaks bridging
of IPv6 packets on a bridge with CONFIG_IPV6=n.

Sysctl entry /proc/sys/net/bridge/bridge-nf-call-ip6tables defaults to 1,
for this reason packets are handled by br_nf_pre_routing_ipv6(). When compiled
with CONFIG_IPV6=n this function returns NF_DROP but should return NF_ACCEPT
to let packets through.

Change CONFIG_IPV6=n br_nf_pre_routing_ipv6() return value to NF_ACCEPT.

Tested with a simple bridge with two interfaces and IPv6 packets trying
to pass from host on left side to host on right side of the bridge.

Fixes: 230ac490f7fba ("netfilter: bridge: split ipv6 code into separated file")

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
NOTE:
With CONFIG_IPV6=n /proc/sys/net/bridge/bridge-nf-call-ip6tables is ineffective
as regardless of value packets will not be available to ip6tables which is not
available in this case anyway.
This patch is the easier solution to the original problem without introducing
new code (and complexity) for exposing ip6tables related sysfs and sysctl
entries only when CONFIG_IPV6=y.

Patch history

v4
* complete re-write to a simpler solution only changing NF_DROP
  to NF_ACCEPT in br_nf_pre_routing_ipv6() when CONFIG_IPV6=n

v3
* fix checkpatch error in separate patch
* changes to reduce #ifdef pollution

v2
* do not expose sysfs and sysctl if CONFIG_IP6_NF_IPTABLES=n 
* change dependency to CONFIG_IP6_NF_IPTABLES as suggested by Florian Westphal
* removed changes to br_validate_ipv6() in br_netfilter.h as test show it may
  not be needed

v1
* sysfs and sysctl entry were exposed but not writeable if CONFIG_IPV6=n

 include/net/netfilter/br_netfilter.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index bab824b..d4c6b5f 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -59,7 +59,7 @@ static inline unsigned int
 br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops, struct sk_buff *skb,
 		       const struct nf_hook_state *state)
 {
-	return NF_DROP;
+	return NF_ACCEPT;
 }
 #endif
 
-- 
1.7.10.4


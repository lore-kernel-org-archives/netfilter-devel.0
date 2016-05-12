From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nfnetlink_queue: fix timestamp attribute
Date: Thu, 12 May 2016 14:43:54 +0200
Message-ID: <1463057034-27694-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40891 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097AbcELMnh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2016 08:43:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since 4.4 we erronously use timestamp of the netlink skb (which is zero).

Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1066
Fixes: b28b1e826f818c30ea7 ("netfilter: nfnetlink_queue: use y2038 safe timestamp")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index cb5b630..e34256a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -499,7 +499,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 
 	if (entskb->tstamp.tv64) {
 		struct nfqnl_msg_packet_timestamp ts;
-		struct timespec64 kts = ktime_to_timespec64(skb->tstamp);
+		struct timespec64 kts = ktime_to_timespec64(entskb->tstamp);
 
 		ts.sec = cpu_to_be64(kts.tv_sec);
 		ts.usec = cpu_to_be64(kts.tv_nsec / NSEC_PER_USEC);
-- 
2.7.3


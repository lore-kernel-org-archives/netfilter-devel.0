From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/7] netfilter: nfnetlink_queue: fix timestamp attribute
Date: Wed,  1 Jun 2016 14:03:18 +0200
Message-ID: <1464782604-19346-2-git-send-email-pablo@netfilter.org>
References: <1464782604-19346-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52859 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430AbcFAMDe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 08:03:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0C76D11D9BD2
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 14:03:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F0F072310AF
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 14:03:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 995062310AF
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 14:03:30 +0200 (CEST)
In-Reply-To: <1464782604-19346-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Since 4.4 we erronously use timestamp of the netlink skb (which is zero).

Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1066
Fixes: b28b1e826f818c30ea7 ("netfilter: nfnetlink_queue: use y2038 safe timestamp")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4


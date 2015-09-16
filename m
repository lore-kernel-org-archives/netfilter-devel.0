From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH next 12/30] ipv4: Explicitly compute net in ip_fragment
Date: Tue, 15 Sep 2015 20:04:00 -0500
Message-ID: <1442365458-16349-12-git-send-email-ebiederm@xmission.com>
References: <87mvwn18my.fsf@x220.int.ebiederm.org>
Cc: netfilter-devel@vger.kernel.org, <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:35198 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbbIPBNi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Sep 2015 21:13:38 -0400
In-Reply-To: <87mvwn18my.fsf@x220.int.ebiederm.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/ipv4/ip_output.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 85b72d450184..095754c99061 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -500,10 +500,9 @@ static int ip_fragment(struct sock *sk, struct sk_buff *skb,
 	if (unlikely(!skb->ignore_df ||
 		     (IPCB(skb)->frag_max_size &&
 		      IPCB(skb)->frag_max_size > mtu))) {
-		struct rtable *rt = skb_rtable(skb);
-		struct net_device *dev = rt->dst.dev;
+		struct net *net = dev_net(skb_rtable(skb)->dst.dev);
 
-		IP_INC_STATS(dev_net(dev), IPSTATS_MIB_FRAGFAILS);
+		IP_INC_STATS(net, IPSTATS_MIB_FRAGFAILS);
 		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 			  htonl(mtu));
 		kfree_skb(skb);
-- 
2.2.1


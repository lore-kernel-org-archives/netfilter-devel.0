From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 13/13] Don't lookup the socket if there's a socket attached to
	the skb
Date: Tue, 02 Oct 2007 22:46:24 +0200
Message-ID: <20071002204624.11052.18114.stgit@nessa.odu>
References: <20071002203942.11052.7303.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:53338 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbXJBUqZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:46:25 -0400
Received: from nessa.odu ([152.66.208.5])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTP id <0JPA00DPBXMRE1D0@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Tue, 02 Oct 2007 22:44:51 +0200 (CEST)
In-reply-to: <20071002203942.11052.7303.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Use the socket cached in the TPROXY target if it's present.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---

 net/ipv4/udp.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2fb3b7c..d1fefb6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1151,6 +1151,14 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct hlist_head udptable[],
 	if (rt->rt_flags & (RTCF_BROADCAST|RTCF_MULTICAST))
 		return __udp4_lib_mcast_deliver(skb, uh, saddr, daddr, udptable);
 
+#if defined(CONFIG_NETFILTER_TPROXY) || defined (CONFIG_NETFILTER_TPROXY_MODULE)
+	if (unlikely(skb->sk)) {
+		/* steal reference */
+		sk = skb->sk;
+		skb->destructor = NULL;
+		skb->sk = NULL;
+	} else
+#endif
 	sk = __udp4_lib_lookup(saddr, uh->source, daddr, uh->dest,
 			       skb->dev->ifindex, udptable        );
 


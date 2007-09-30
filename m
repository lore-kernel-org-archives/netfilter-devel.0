From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 13/13] Don't lookup the socket if there's a socket attached to
	the skb
Date: Sun, 30 Sep 2007 22:53:56 +0200
Message-ID: <20070930205356.10969.48182.stgit@nessa.odu>
References: <20070930205141.10969.27205.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:40428 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbXI3VLy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:11:54 -0400
In-Reply-To: <20070930205141.10969.27205.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Use the socket cached in the TPROXY target if it's present.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---

 net/ipv4/udp.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2fb3b7c..2bdf034 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1151,6 +1151,14 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct hlist_head udptable[],
 	if (rt->rt_flags & (RTCF_BROADCAST|RTCF_MULTICAST))
 		return __udp4_lib_mcast_deliver(skb, uh, saddr, daddr, udptable);
 
+#if defined(CONFIG_IP_NF_TPROXY) || defined (CONFIG_IP_NF_TPROXY_MODULE)
+	if (unlikely(skb->sk)) {
+		/* steal reference */
+		sk = skb->sk;
+		skb->destructor = NULL;
+		skb->sk = NULL;
+	} else
+#endif
 	sk = __udp4_lib_lookup(saddr, uh->source, daddr, uh->dest,
 			       skb->dev->ifindex, udptable        );
 


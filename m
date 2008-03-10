From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/09]: nfnetlink_queue: fix computation of allocated size for netlink skb.
Date: Mon, 10 Mar 2008 19:26:16 +0100 (MET)
Message-ID: <20080310182618.20404.7439.sendpatchset@localhost.localdomain>
References: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34257 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbYCJS0R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:26:17 -0400
In-Reply-To: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: fix computation of allocated size for netlink skb.

Size of the netlink skb was wrongly computed because the formula was using
NLMSG_ALIGN instead of NLMSG_SPACE. NLMSG_ALIGN does not add the room for
netlink header as NLMSG_SPACE does. This was causing a failure of message
building in some cases.

On my test system, all messages for packets in range [8*k+41, 8*k+48] where k
is an integer were invalid and the corresponding packets were dropped.

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fab7718e07093ec0e51b1193560bae72d29b2ef1
tree 03084ce20b7f13470e8eb046326ac9592572e9f4
parent a0866e6699bd8bd0f5016eaf8a194c0f4dfd5f7e
author Eric Leblond <eric@inl.fr> Mon, 10 Mar 2008 17:50:41 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 17:50:41 +0100

 net/netfilter/nfnetlink_queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 385dacd..a573baa 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -224,7 +224,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	struct net_device *indev;
 	struct net_device *outdev;
 
-	size =    NLMSG_ALIGN(sizeof(struct nfgenmsg))
+	size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */

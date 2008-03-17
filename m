From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable 02/03]: nfnetlink_queue: fix computation of allocated size for netlink skb
Date: Mon, 17 Mar 2008 15:41:46 +0100 (MET)
Message-ID: <20080317143314.20525.75176.sendpatchset@localhost.localdomain>
References: <20080317143311.20525.87504.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53637 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbYCQOlr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 10:41:47 -0400
In-Reply-To: <20080317143311.20525.87504.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: fix computation of allocated size for netlink skb

Upstream commit cabaa9bf:

Size of the netlink skb was wrongly computed because the formula was using
NLMSG_ALIGN instead of NLMSG_SPACE. NLMSG_ALIGN does not add the room for
netlink header as NLMSG_SPACE does. This was causing a failure of message
building in some cases.

On my test system, all messages for packets in range [8*k+41, 8*k+48] where k
is an integer were invalid and the corresponding packets were dropped.

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 26a01f41cb49b1d5d75832d50ac7ab6def468e37
tree b1be993bc991a756a02da285e4cb9fff9c024ec2
parent 2cfc500a853497da88ca6b097873bcb0de65e764
author Eric Leblond <eric@inl.fr> Mon, 17 Mar 2008 15:30:13 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Mar 2008 15:30:13 +0100

 net/netfilter/nfnetlink_queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 3ceeffc..15a7de2 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -353,7 +353,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 
 	QDEBUG("entered\n");
 
-	size =    NLMSG_ALIGN(sizeof(struct nfgenmsg))
+	size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */

From: Eric Leblond <eric@inl.fr>
Subject: [stable-patch 1/2] Fix computation of allocated size for netlink skb.
Date: Tue,  4 Mar 2008 10:40:58 +0100
Message-ID: <1204623659-9507-2-git-send-email-eric@inl.fr>
References: <1204623659-9507-1-git-send-email-eric@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:50004 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbYCDJlE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:41:04 -0500
In-Reply-To: <1204623659-9507-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Size of the netlink skb was wrongly computed because the formula was using
NLMSG_ALIGN instead of NLMSG_SPACE. NLMSG_ALIGN does not add the room for
netlink header as NLMSG_SPACE does. This was causing a failure of message
building in some cases.

On my test system, all messages for packets in range [8*k+41, 8*k+48] where k
is an integer were invalid and the corresponding packets were dropped.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
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
-- 
1.5.4.1


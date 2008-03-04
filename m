From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 2/2] Fix computation of netlink skb size.
Date: Tue,  4 Mar 2008 10:46:03 +0100
Message-ID: <1204623963-10600-3-git-send-email-eric@inl.fr>
References: <1204623963-10600-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:50970 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbYCDJqF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:46:05 -0500
In-Reply-To: <1204623963-10600-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is similar to nfnetlink_queue fixes. It fixes the computation
of skb size by using NLMSG_SPACE instead of NLMSG_ALIGN.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 7efa40d..c6802c0 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -556,7 +556,7 @@ nfulnl_log_packet(unsigned int pf,
 	/* FIXME: do we want to make the size calculation conditional based on
 	 * what is actually present?  way more branches and checks, but more
 	 * memory efficient... */
-	size =    NLMSG_ALIGN(sizeof(struct nfgenmsg))
+	size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hdr))
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
-- 
1.5.4.1


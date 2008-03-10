From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/09]: nfnetlink_log: fix computation of netlink skb size
Date: Mon, 10 Mar 2008 19:26:17 +0100 (MET)
Message-ID: <20080310182619.20404.45121.sendpatchset@localhost.localdomain>
References: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34261 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbYCJS0S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:26:18 -0400
In-Reply-To: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_log: fix computation of netlink skb size

This patch is similar to nfnetlink_queue fixes. It fixes the computation
of skb size by using NLMSG_SPACE instead of NLMSG_ALIGN.

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b306ccc2129dfc062653b3436df714fc758f3c45
tree 98b4d4d9819246591cd11d38e07dbbad182287b0
parent fab7718e07093ec0e51b1193560bae72d29b2ef1
author Eric Leblond <eric@inl.fr> Mon, 10 Mar 2008 17:50:41 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 17:50:41 +0100

 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 83832eb..be71091 100644
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

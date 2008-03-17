From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable 03/03]: nfnetlink_log: fix computation of netlink skb size
Date: Mon, 17 Mar 2008 15:41:47 +0100 (MET)
Message-ID: <20080317143315.20525.42891.sendpatchset@localhost.localdomain>
References: <20080317143311.20525.87504.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53637 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbYCQOls (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 10:41:48 -0400
In-Reply-To: <20080317143311.20525.87504.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_log: fix computation of netlink skb size

Upstream commit 7000d38d:

This patch is similar to nfnetlink_queue fixes. It fixes the computation
of skb size by using NLMSG_SPACE instead of NLMSG_ALIGN.

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fb462f0e14c1aeb8ca109f0681dd626f373999ef
tree f4094c018fc31b7732bbba172ba8d4bf846a0c2e
parent 26a01f41cb49b1d5d75832d50ac7ab6def468e37
author Eric Leblond <eric@inl.fr> Mon, 17 Mar 2008 15:30:14 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Mar 2008 15:30:14 +0100

 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 2c7bd2e..dc43df1 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -594,7 +594,7 @@ nfulnl_log_packet(unsigned int pf,
 	/* FIXME: do we want to make the size calculation conditional based on
 	 * what is actually present?  way more branches and checks, but more
 	 * memory efficient... */
-	size =    NLMSG_ALIGN(sizeof(struct nfgenmsg))
+	size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hdr))
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: nfnetlink_log: fix wrong skbuff size
	calculation
Date: Wed, 27 May 2009 14:54:01 +0200
Message-ID: <20090527125401.11366.31677.stgit@Decadence>
References: <20090527125242.11366.70215.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51204 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761381AbZE0NgQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 09:36:16 -0400
In-Reply-To: <20090527125242.11366.70215.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This problem was introduced in 72961ecf84d67d6359a1b30f9b2a8427f13e1e71
since no space was reserved for the new attributes NFULA_HWTYPE,
NFULA_HWLEN and NFULA_HWHEADER.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nfnetlink_log.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index fd326ac..66a6dd5 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -581,6 +581,12 @@ nfulnl_log_packet(u_int8_t pf,
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp));
 
+	if (in && skb_mac_header_was_set(skb)) {
+		size +=   nla_total_size(skb->dev->hard_header_len)
+			+ nla_total_size(sizeof(u_int16_t))	/* hwtype */
+			+ nla_total_size(sizeof(u_int16_t));	/* hwlen */
+	}
+
 	spin_lock_bh(&inst->lock);
 
 	if (inst->flags & NFULNL_CFG_F_SEQ)


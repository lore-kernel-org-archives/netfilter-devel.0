From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 05/08: nfnetlink_log: send complete hardware header
Date: Mon, 21 Jul 2008 18:17:29 +0200 (MEST)
Message-ID: <20080721161729.28572.71670.sendpatchset@localhost.localdomain>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41623 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYGUQRb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:17:31 -0400
In-Reply-To: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nfnetlink_log: send complete hardware header

This patch adds some fields to NFLOG to be able to send the complete
hardware header with all necessary informations.
It sends to userspace:
 * the type of hardware link
 * the lenght of hardware header
 * the hardware header

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a2f9df434bac7b6dd1a14fa6867e6165d7ed587a
tree 1977569724aeb5026495dc01c61b85337ac80d6d
parent 281de5230fde71e8799f18c4df1fa35f61b023d1
author Eric Leblond <eric@inl.fr> Mon, 21 Jul 2008 18:05:57 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 21 Jul 2008 18:05:57 +0200

 include/linux/netfilter/nfnetlink_log.h |    3 +++
 net/netfilter/nfnetlink_log.c           |    8 ++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_log.h b/include/linux/netfilter/nfnetlink_log.h
index a857213..f661731 100644
--- a/include/linux/netfilter/nfnetlink_log.h
+++ b/include/linux/netfilter/nfnetlink_log.h
@@ -48,6 +48,9 @@ enum nfulnl_attr_type {
 	NFULA_SEQ,			/* instance-local sequence number */
 	NFULA_SEQ_GLOBAL,		/* global sequence number */
 	NFULA_GID,			/* group id of socket */
+	NFULA_HWTYPE,			/* hardware type */
+	NFULA_HWHEADER,			/* hardware header */
+	NFULA_HWLEN,			/* hardware header length */
 
 	__NFULA_MAX
 };
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b8173af..9a35b57 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -453,6 +453,14 @@ __build_packet_message(struct nfulnl_instance *inst,
 		}
 	}
 
+	if (indev && skb_mac_header_was_set(skb)) {
+		NLA_PUT_BE16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type));
+		NLA_PUT_BE16(inst->skb, NFULA_HWLEN,
+			     htons(skb->dev->hard_header_len));
+		NLA_PUT(inst->skb, NFULA_HWHEADER, skb->dev->hard_header_len,
+			skb_mac_header(skb));
+	}
+
 	if (skb->tstamp.tv64) {
 		struct nfulnl_msg_packet_timestamp ts;
 		struct timeval tv = ktime_to_timeval(skb->tstamp);

From: Eric Leblond <eric@inl.fr>
Subject: netfilter: Send complete hardware header in NFLOG.
Date: Thu, 17 Jul 2008 11:12:14 +0200
Message-ID: <1216285934-32268-1-git-send-email-eric@inl.fr>
References: <487F0A54.5090002@trash.net>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55686 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752981AbYGQJMR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:12:17 -0400
In-Reply-To: <487F0A54.5090002@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds some fields to NFLOG to be able to send the complete
hardware header with all necessary informations.
It sends to userspace:
 * the type of hardware link
 * the length of hardware header
 * the hardware header

Signed-off-by: Eric Leblond <eric@inl.fr>
---
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
-- 
1.5.4.3


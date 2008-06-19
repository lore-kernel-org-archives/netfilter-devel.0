From: Eric Leblond <eric@inl.fr>
Subject: netfilter: Make NFLOG dump all hardware header.
Date: Thu, 19 Jun 2008 14:25:31 +0200
Message-ID: <1213878331-1074-1-git-send-email-eric@inl.fr>
References: <1213878187-909-1-git-send-email-eric@inl.fr>
Cc: chifflier@inl.fr, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:32771 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbYFSMZh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:25:37 -0400
In-Reply-To: <1213878187-909-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch synchronises behaviour of ULOG and NFLOG relatively to the
hardware header:
 * NFLOG sends MAC address to userspace (dev_parse_header content)
 * ULOG sends complete link header (skb_mac_header content)
This patch double the size of hardware header for NFLOG and fill it
with the complete hardware header.
---
 include/linux/netfilter/nfnetlink_log.h |    4 +++-
 net/netfilter/nfnetlink_log.c           |   14 ++++++++------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_log.h b/include/linux/netfilter/nfnetlink_log.h
index a857213..21b7ad5 100644
--- a/include/linux/netfilter/nfnetlink_log.h
+++ b/include/linux/netfilter/nfnetlink_log.h
@@ -21,10 +21,12 @@ struct nfulnl_msg_packet_hdr {
 	u_int8_t	_pad;
 };
 
+#define MAX_HWHEADER_LEN 16
+
 struct nfulnl_msg_packet_hw {
 	__be16		hw_addrlen;
 	u_int16_t	_pad;
-	u_int8_t	hw_addr[8];
+	u_int8_t	hw_addr[MAX_HWHEADER_LEN];
 };
 
 struct nfulnl_msg_packet_timestamp {
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 7efa40d..de4af6c 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -444,13 +444,15 @@ __build_packet_message(struct nfulnl_instance *inst,
 	if (skb->mark)
 		NLA_PUT_BE32(inst->skb, NFULA_MARK, htonl(skb->mark));
 
-	if (indev && skb->dev) {
+
+	if (indev && indev->hard_header_len > 0
+	    && skb->mac_header != skb->network_header
+	    && indev->hard_header_len <= MAX_HWHEADER_LEN * sizeof(char)) {
 		struct nfulnl_msg_packet_hw phw;
-		int len = dev_parse_header(skb, phw.hw_addr);
-		if (len > 0) {
-			phw.hw_addrlen = htons(len);
-			NLA_PUT(inst->skb, NFULA_HWADDR, sizeof(phw), &phw);
-		}
+		memcpy(phw.hw_addr, skb_mac_header(skb), indev->hard_header_len);
+
+		phw.hw_addrlen = htons(indev->hard_header_len);
+		NLA_PUT(inst->skb, NFULA_HWADDR, sizeof(phw), &phw);
 	}
 
 	if (skb->tstamp.tv64) {
-- 
1.5.5.3


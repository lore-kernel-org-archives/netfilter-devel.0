From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] netfilter: nfnetlink_log: remove unused parameter
Date: Tue, 15 Feb 2011 21:13:57 +0100
Message-ID: <1297800837-10757-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35827 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154Ab1BOUTa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Feb 2011 15:19:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 91592da..985e9b7 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -376,7 +376,6 @@ __build_packet_message(struct nfulnl_instance *inst,
 			unsigned int hooknum,
 			const struct net_device *indev,
 			const struct net_device *outdev,
-			const struct nf_loginfo *li,
 			const char *prefix, unsigned int plen)
 {
 	struct nfulnl_msg_packet_hdr pmsg;
@@ -652,7 +651,7 @@ nfulnl_log_packet(u_int8_t pf,
 	inst->qlen++;
 
 	__build_packet_message(inst, skb, data_len, pf,
-				hooknum, in, out, li, prefix, plen);
+				hooknum, in, out, prefix, plen);
 
 	if (inst->qlen >= qthreshold)
 		__nfulnl_flush(inst);
-- 
1.7.2.2


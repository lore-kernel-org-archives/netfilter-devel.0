From: kaber@trash.net
Subject: [PATCH 06/13] netfilter: nfnetlink_log: remove unused parameter
Date: Wed,  2 Mar 2011 13:12:46 +0100
Message-ID: <1299067973-15977-7-git-send-email-kaber@trash.net>
References: <1299067973-15977-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1299067973-15977-1-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
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
1.7.4


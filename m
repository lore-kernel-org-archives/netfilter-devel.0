From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/2] [NETFILTER]: Change semantic of xt_TOS mask (dev)
Date: Tue, 18 Dec 2007 16:47:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712181646220.32270@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57071 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605AbXLRPrd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:47:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This patch changes the behavior of xt_TOS v1 so that the mask value
one supplies means "zero out these bits" rather than "keep these
bits". This is more easy on the user, as (I would assume) people
keep more bits than zeroing, so, an example:

	Action: Set bit 0x01.
	before: iptables -j TOS --set-tos 0x01/0xFE
	after:  iptables -j TOS --set-tos 0x01/0x01

This is not too "tragic" with xt_TOS, but where larger fields are
used (e.g. proposed xt_MARK v2), `--set-xmark 0x01/0xFFFFFFFE` vs.
`--set-xmark 0x01/0x01` is really a worthy difference.
Other modules, such as xt_TPROXY also use &~ rather than &, so
let's find a common ground.

(We can apply this patch because xt_TOS v1 is currently only in the
development tree, not mainline.)

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/netfilter/xt_DSCP.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/net/netfilter/xt_DSCP.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_DSCP.c
+++ linux-2.6/net/netfilter/xt_DSCP.c
@@ -128,7 +128,7 @@ tos_tg(struct sk_buff *skb, const struct
 	u_int8_t orig, nv;
 
 	orig = ipv4_get_dsfield(iph);
-	nv   = (orig & info->tos_mask) ^ info->tos_value;
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))

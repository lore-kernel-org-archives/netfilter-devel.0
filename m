From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/38]: xt_TOS: Change semantic of mask value
Date: Tue, 15 Jan 2008 07:19:17 +0100 (MET)
Message-ID: <20080115061912.3184.77486.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62166 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbYAOGTS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:18 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_TOS: Change semantic of mask value

This patch changes the behavior of xt_TOS v1 so that the mask value
the user supplies means "zero out these bits" rather than "keep these
bits". This is more easy on the user, as (I would assume) people keep
more bits than zeroing, so, an example:

	Action:     Set bit 0x01.
    	before (&): iptables -j TOS --set-tos 0x01/0xFE
    	after (&~): iptables -j TOS --set-tos 0x01/0x01

This is not too "tragic" with xt_TOS, but where larger fields are used
(e.g. proposed xt_MARK v2), `--set-xmar 0x01/0x01` vs. `--set-xmark
0x01/0xFFFFFFFE` really makes a difference. Other target(!) modules,
such as xt_TPROXY also use &~ rather than &, so let's get to a common
ground.

(Since xt_TOS has not yet left the development tree en direction to
mainline, the semantic can be changed as proposed without breaking
iptables.)

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b0b6c99174c0d7d9512cd84e50da2c4426e6ae06
tree 8bf104996345ef071b26c8b64fc668d033aefb77
parent 97522ed78f619506ef818b7a7b1160735b47c367
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:12 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:23:23 +0100

 net/netfilter/xt_DSCP.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index fd7500e..9951e7f 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -128,7 +128,7 @@ tos_tg(struct sk_buff *skb, const struct net_device *in,
 	u_int8_t orig, nv;
 
 	orig = ipv4_get_dsfield(iph);
-	nv   = (orig & info->tos_mask) ^ info->tos_value;
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))

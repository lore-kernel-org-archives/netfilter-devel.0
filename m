From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/38]: xt_TOS: Properly set the TOS field
Date: Tue, 15 Jan 2008 07:19:19 +0100 (MET)
Message-ID: <20080115061914.3184.48468.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62170 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYAOGTU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:20 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_TOS: Properly set the TOS field

Fix incorrect mask value passed to ipv4_change_dsfield/ipv6_change_dsfield.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 89efd08437074cc2005dc258622866efa187c46a
tree 9614972fb51ab77899d80d89a50b363c438ff74f
parent b0b6c99174c0d7d9512cd84e50da2c4426e6ae06
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:15 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:23:23 +0100

 net/netfilter/xt_DSCP.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 9951e7f..3d216d6 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -134,7 +134,7 @@ tos_tg(struct sk_buff *skb, const struct net_device *in,
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 		iph = ip_hdr(skb);
-		ipv4_change_dsfield(iph, ~0, nv);
+		ipv4_change_dsfield(iph, 0, nv);
 	}
 
 	return XT_CONTINUE;
@@ -156,7 +156,7 @@ tos_tg6(struct sk_buff *skb, const struct net_device *in,
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 		iph = ipv6_hdr(skb);
-		ipv6_change_dsfield(iph, ~0, nv);
+		ipv6_change_dsfield(iph, 0, nv);
 	}
 
 	return XT_CONTINUE;

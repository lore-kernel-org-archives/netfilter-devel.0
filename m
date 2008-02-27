From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/05]: xt_conntrack: fix missing boolean clamping
Date: Wed, 27 Feb 2008 14:14:22 +0100 (MET)
Message-ID: <20080227131430.26831.77763.sendpatchset@localhost.localdomain>
References: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53803 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbYB0NOX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:14:23 -0500
In-Reply-To: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_conntrack: fix missing boolean clamping

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bcc67d744bd9df15cb4e2d590b30ddadebd5a867
tree 8888741a4eb78658db89b968d066837478238597
parent 2ffa8857857148a5b0c0823852d6cb2551a3ae5a
author Jan Engelhardt <jengelh@computergmbh.de> Wed, 27 Feb 2008 13:23:56 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 27 Feb 2008 13:23:56 +0100

 net/netfilter/xt_conntrack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 8533085..dd192ac 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -231,7 +231,7 @@ conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
 			if (test_bit(IPS_DST_NAT_BIT, &ct->status))
 				statebit |= XT_CONNTRACK_STATE_DNAT;
 		}
-		if ((info->state_mask & statebit) ^
+		if (!!(info->state_mask & statebit) ^
 		    !(info->invert_flags & XT_CONNTRACK_STATE))
 			return false;
 	}

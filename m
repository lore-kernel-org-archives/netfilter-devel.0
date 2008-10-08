From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 58/79: x_tables: output bad hook mask in hexadecimal
Date: Wed,  8 Oct 2008 12:47:39 +0200 (MEST)
Message-ID: <20081008104739.10423.76513.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46040 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbYJHKrk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:40 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 102befab75c438bfa356c6976026326728771ebc
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:15 2008 +0200

    netfilter: x_tables: output bad hook mask in hexadecimal
    
    It is a mask, and masks are most useful in hex.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 0e23f42..3b1fc40 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -342,7 +342,7 @@ int xt_check_match(const struct xt_match *match, unsigned short family,
 		return -EINVAL;
 	}
 	if (match->hooks && (hook_mask & ~match->hooks) != 0) {
-		printk("%s_tables: %s match: bad hook_mask %u/%u\n",
+		printk("%s_tables: %s match: bad hook_mask %#x/%#x\n",
 		       xt_prefix[family], match->name, hook_mask, match->hooks);
 		return -EINVAL;
 	}
@@ -483,7 +483,7 @@ int xt_check_target(const struct xt_target *target, unsigned short family,
 		return -EINVAL;
 	}
 	if (target->hooks && (hook_mask & ~target->hooks) != 0) {
-		printk("%s_tables: %s target: bad hook_mask %u/%u\n",
+		printk("%s_tables: %s target: bad hook_mask %#x/%#x\n",
 		       xt_prefix[family], target->name, hook_mask,
 		       target->hooks);
 		return -EINVAL;

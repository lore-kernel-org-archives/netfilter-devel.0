From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/23] netfilter: x_tables: output bad hook mask in hexadecimal
Date: Mon,  6 Oct 2008 08:15:05 -0400
Message-ID: <41ce82bb1aec59296cbdcf9bdb9ca43e54dae791.1223294924.git.jengelh@medozas.de>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57087 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYJFMP3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:29 -0400
In-Reply-To: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
In-Reply-To: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
References: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is a mask, and masks are most useful in hex.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/x_tables.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
-- 
1.6.0.1


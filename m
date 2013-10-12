From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH] nft: arp: fix STRING_OVERFLOW
Date: Sat, 12 Oct 2013 11:21:52 +0200
Message-ID: <1381569712-7835-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:49482 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3JLJVe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Oct 2013 05:21:34 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so1944477bkb.38
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2013 02:21:33 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch replace strcat with strncat and strcpy with strncpy
fixing possible string overflow.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c     |    4 ++--
 iptables/xtables-arp.c |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 08f8814..9792fda 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -459,7 +459,7 @@ nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
 			sprintf(buf, "%s", addr_to_dotted(&(fw.arp.src)));
 		else
 			sprintf(buf, "%s", addr_to_anyname(&(fw.arp.src)));
-		strcat(buf, mask_to_dotted(&(fw.arp.smsk)));
+		strncat(buf, mask_to_dotted(&(fw.arp.smsk)), sizeof(buf) - strlen(buf) -1);
 		printf("-s %s ", buf);
 	}
 
@@ -483,7 +483,7 @@ after_devsrc:
 			sprintf(buf, "%s", addr_to_dotted(&(fw.arp.tgt)));
 		else
 			sprintf(buf, "%s", addr_to_anyname(&(fw.arp.tgt)));
-		strcat(buf, mask_to_dotted(&(fw.arp.tmsk)));
+		strncat(buf, mask_to_dotted(&(fw.arp.tmsk)),  sizeof(buf) - strlen(buf) -1);
 		printf("-d %s ", buf);
 	}
 
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 411a699..18f285c 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -847,7 +847,8 @@ static struct xtables_target *command_jump(struct arpt_entry *fw,
 
 	target->t = xtables_calloc(1, size);
 	target->t->u.target_size = size;
-	strcpy(target->t->u.user.name, jumpto);
+	strncpy(target->t->u.user.name, jumpto, sizeof(target->t->u.user.name));
+	target->t->u.user.name[sizeof(target->t->u.user.name)-1] = '\0';
 	target->t->u.user.revision = target->revision;
 
 	xs_init_target(target);
-- 
1.7.8.6


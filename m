From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables-nftables] nft: fix out of bound memory copy
Date: Tue, 26 Nov 2013 13:15:13 +0100
Message-ID: <1385468113-4620-1-git-send-email-pablo@netfilter.org>
Cc: anarey@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36082 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab3KZMPX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:15:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Valgrind reports an invalid read after a memory block:

==11114== Invalid read of size 8
==11114==    at 0x4C2DB02: memcpy@@GLIBC_2.14 (mc_replace_strmem.c:877)
==11114==    by 0x41788E: add_match (nft.c:781)
==11114==    by 0x41B54C: nft_ipv4_add (nft-ipv4.c:72)
==11114==    by 0x415DF2: nft_rule_new.isra.2 (nft.c:945)
==11114==    by 0x418ACE: nft_rule_append (nft.c:1000)
==11114==    by 0x413A92: add_entry.isra.6 (xtables.c:424)
==11114==    by 0x4152DE: do_commandx (xtables.c:1184)
==11114==    by 0x4134E8: xtables_main (xtables-standalone.c:72)
==11114==    by 0x5B87994: (below main) (libc-start.c:260)
==11114==  Address 0x61399e8 is 8 bytes after a block of size 48 alloc'd
==11114==    at 0x4C2B514: calloc (vg_replace_malloc.c:593)
==11114==    by 0x52448C8: xtables_calloc (xtables.c:272)
==11114==    by 0x410AC2: command_default (xshared.c:150)
==11114==    by 0x4149A2: do_commandx (xtables.c:1075)
==11114==    by 0x4134E8: xtables_main (xtables-standalone.c:72)
==11114==    by 0x5B87994: (below main) (libc-start.c:260)

m->u.match_size also contains the size of the xt_entry_match structure.
Fix also the target path which is very similar.

Reported-by: Ana Rey Botello <anarey@gmail.com>
Tested-by: Ana Rey Botello <anarey@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 01e0264..2135b04 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -776,7 +776,7 @@ static int __add_match(struct nft_rule_expr *e, struct xt_entry_match *m)
 	if (info == NULL)
 		return -ENOMEM;
 
-	memcpy(info, m->data, m->u.match_size);
+	memcpy(info, m->data, m->u.match_size - sizeof(*m));
 	nft_rule_expr_set(e, NFT_EXPR_MT_INFO, info, m->u.match_size - sizeof(*m));
 
 	return 0;
@@ -799,20 +799,17 @@ int add_match(struct nft_rule *r, struct xt_entry_match *m)
 
 static int __add_target(struct nft_rule_expr *e, struct xt_entry_target *t)
 {
-	void *info = NULL;
+	void *info;
 
 	nft_rule_expr_set(e, NFT_EXPR_TG_NAME, t->u.user.name,
 			  strlen(t->u.user.name));
 	nft_rule_expr_set_u32(e, NFT_EXPR_TG_REV, t->u.user.revision);
 
-	if (info == NULL) {
-		info = calloc(1, t->u.target_size);
-		if (info == NULL)
-			return -ENOMEM;
-
-		memcpy(info, t->data, t->u.target_size);
-	}
+	info = calloc(1, t->u.target_size);
+	if (info == NULL)
+		return -ENOMEM;
 
+	memcpy(info, t->data, t->u.target_size - sizeof(*t));
 	nft_rule_expr_set(e, NFT_EXPR_TG_INFO, info, t->u.target_size - sizeof(*t));
 
 	return 0;
-- 
1.7.10.4


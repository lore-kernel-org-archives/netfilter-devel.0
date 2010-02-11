From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 03/10] netfilter: CONFIG_COMPAT: allow delta to exceed 32767
Date: Thu, 11 Feb 2010 15:12:33 +0100
Message-ID: <1265897559-10610-4-git-send-email-fw@strlen.de>
References: <1265897559-10610-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53717 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381Ab0BKOMk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:12:40 -0500
In-Reply-To: <1265897559-10610-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

with 32 bit userland and 64 bit kernels, it is unlikely but possible
that insertion of new rules fails even tough there are only about 2000
iptables rules.

This happens because the compat delta is using a short int.
Easily reproducible via "iptables -m limit" ; after about 2050
rules inserting new ones fails with -ELOOP.

Note that compat_delta included 2 bytes of padding on x86_64, so
structure size remains the same.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v1.
 include/linux/netfilter/x_tables.h |    2 +-
 net/netfilter/x_tables.c           |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index a0a144a..b8877f1 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -588,7 +588,7 @@ extern void xt_compat_unlock(u_int8_t af);
 
 extern int xt_compat_add_offset(u_int8_t af, unsigned int offset, short delta);
 extern void xt_compat_flush_offsets(u_int8_t af);
-extern short xt_compat_calc_jump(u_int8_t af, unsigned int offset);
+extern int xt_compat_calc_jump(u_int8_t af, unsigned int offset);
 
 extern int xt_compat_match_offset(const struct xt_match *match);
 extern int xt_compat_match_from_user(struct xt_entry_match *m,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 255ab06..76d54cd 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -39,7 +39,7 @@ MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
 struct compat_delta {
 	struct compat_delta *next;
 	unsigned int offset;
-	short delta;
+	int delta;
 };
 
 struct xt_af {
@@ -437,10 +437,10 @@ void xt_compat_flush_offsets(u_int8_t af)
 }
 EXPORT_SYMBOL_GPL(xt_compat_flush_offsets);
 
-short xt_compat_calc_jump(u_int8_t af, unsigned int offset)
+int xt_compat_calc_jump(u_int8_t af, unsigned int offset)
 {
 	struct compat_delta *tmp;
-	short delta;
+	int delta;
 
 	for (tmp = xt[af].compat_offsets, delta = 0; tmp; tmp = tmp->next)
 		if (tmp->offset < offset)
-- 
1.6.3.3


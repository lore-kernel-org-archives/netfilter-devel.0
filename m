From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/7] netfilter: CONFIG_COMPAT: allow delta to exceed 32767
Date: Fri,  5 Feb 2010 02:43:11 +0100
Message-ID: <1265334195-28120-4-git-send-email-fw@strlen.de>
References: <1265334195-28120-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59375 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756721Ab0BEBoN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:44:13 -0500
In-Reply-To: <1265334195-28120-1-git-send-email-fw@strlen.de>
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
 include/linux/netfilter/x_tables.h |    2 +-
 net/netfilter/x_tables.c           |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 365fabe..2e342ad 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -583,7 +583,7 @@ extern void xt_compat_unlock(u_int8_t af);
 
 extern int xt_compat_add_offset(u_int8_t af, unsigned int offset, short delta);
 extern void xt_compat_flush_offsets(u_int8_t af);
-extern short xt_compat_calc_jump(u_int8_t af, unsigned int offset);
+extern int xt_compat_calc_jump(u_int8_t af, unsigned int offset);
 
 extern int xt_compat_match_offset(const struct xt_match *match);
 extern int xt_compat_match_from_user(struct xt_entry_match *m,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f01955c..783ca37 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -37,7 +37,7 @@ MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
 struct compat_delta {
 	struct compat_delta *next;
 	unsigned int offset;
-	short delta;
+	int delta;
 };
 
 struct xt_af {
@@ -435,10 +435,10 @@ void xt_compat_flush_offsets(u_int8_t af)
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
1.6.4.4


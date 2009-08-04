From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 053/103] netfilter: xtables: alternate size checking in xt_check_match
Date: Tue,  4 Aug 2009 09:25:37 +0200
Message-ID: <1249370787-17583-54-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56941 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565AbZHDH1b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:31 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt2 allows for unpadded data, but needs a way to tell xt_check_match.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    3 ++-
 net/bridge/netfilter/ebtables.c    |    2 +-
 net/ipv4/netfilter/ip_tables.c     |    2 +-
 net/ipv6/netfilter/ip6_tables.c    |    3 ++-
 net/netfilter/x_tables.c           |   14 ++++++++------
 5 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 5119768..956ff8a 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -482,7 +482,8 @@ extern int xt_register_matches(struct xt_match *match, unsigned int n);
 extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
 
 extern int xt_check_match(struct xt_mtchk_param *,
-			  unsigned int size, u_int8_t proto, bool inv_proto);
+			  unsigned int size, u_int8_t proto, bool inv_proto,
+			  bool check_pad);
 extern int xt_check_target(struct xt_tgchk_param *,
 			   unsigned int size, u_int8_t proto, bool inv_proto);
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 8b8cf09..2a13e53 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -381,7 +381,7 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 	par->match     = match;
 	par->matchinfo = m->data;
 	ret = xt_check_match(par, m->match_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	      e->ethproto, e->invflags & EBT_IPROTO, true);
 	if (ret < 0) {
 		module_put(match->me);
 		return ret;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 7761470..77cef82 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -701,7 +701,7 @@ check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par)
 	par->matchinfo = m->data;
 
 	ret = xt_check_match(par, m->u.match_size - sizeof(*m),
-	      ip->proto, ip->invflags & IPT_INV_PROTO);
+	      ip->proto, ip->invflags & IPT_INV_PROTO, true);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 par.match->name);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f00ecc0..63ea701 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -698,7 +698,8 @@ static int check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par)
 	par->matchinfo = m->data;
 
 	ret = xt_check_match(par, m->u.match_size - sizeof(*m),
-			     ipv6->proto, ipv6->invflags & IP6T_INV_PROTO);
+			     ipv6->proto, ipv6->invflags & IP6T_INV_PROTO,
+			     true);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 par.match->name);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 9e001c7..1cdc982 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -373,19 +373,21 @@ static char *textify_hooks(char *buf, size_t size, unsigned int mask)
 }
 
 int xt_check_match(struct xt_mtchk_param *par,
-		   unsigned int size, u_int8_t proto, bool inv_proto)
+		   unsigned int size, u_int8_t proto, bool inv_proto,
+		   bool check_pad)
 {
-	if (XT_ALIGN(par->match->matchsize) != size &&
-	    par->match->matchsize != -1) {
+	unsigned int required = check_pad ? XT_ALIGN(par->match->matchsize) :
+	                        par->match->matchsize;
+
+	if (par->match->matchsize != -1 && required != size) {
 		/*
 		 * ebt_among is exempt from centralized matchsize checking
 		 * because it uses a dynamic-size data set.
 		 */
 		pr_err("%s_tables: %s.%u match: invalid size "
-		       "(kernel) %zu != (user) %u\n",
+		       "(kernel) %u != (user) %u\n",
 		       xt_prefix[par->family], par->match->name,
-		       par->match->revision,
-		       XT_ALIGN(par->match->matchsize), size);
+		       par->match->revision, required, size);
 		return -EINVAL;
 	}
 	if (par->match->table != NULL &&
-- 
1.6.3.3


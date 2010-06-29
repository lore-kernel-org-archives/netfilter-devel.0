From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/56] netfilter: xtables: alternate size checking in xt_check_match
Date: Tue, 29 Jun 2010 10:42:48 +0200
Message-ID: <1277801017-30600-9-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44232 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab0F2Ins (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:43:48 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Private data areas exist in unserialized form in xt2, hence they do
not need nor have any padding. xt_check_match thus needs a parameter
to know whether to select between comparison against the (un)padded
size.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    3 ++-
 net/bridge/netfilter/ebtables.c    |    4 ++--
 net/ipv4/netfilter/ip_tables.c     |    4 ++--
 net/ipv6/netfilter/ip6_tables.c    |    4 ++--
 net/netfilter/x_tables.c           |   12 +++++++-----
 5 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 2d21185..7bdbecb 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -483,7 +483,8 @@ extern int xt_register_matches(struct xt_match *match, unsigned int n);
 extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
 
 extern int xt_check_match(struct xt_mtchk_param *,
-			  unsigned int size, u_int8_t proto, bool inv_proto);
+			  unsigned int size, u_int8_t proto, bool inv_proto,
+			  bool check_pad);
 extern int xt_check_target(struct xt_tgchk_param *,
 			   unsigned int size, u_int8_t proto, bool inv_proto);
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 4553ffd..73c9cec 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -402,8 +402,8 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 
 	par->match     = match;
 	par->matchinfo = m->data;
-	ret = xt_check_match(par, m->match_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	ret = xt_check_match(par, m->match_size, e->ethproto,
+			     e->invflags & EBT_IPROTO, true);
 	if (ret < 0) {
 		module_put(match->me);
 		return ret;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c172d9e..43adafa 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -702,8 +702,8 @@ check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par)
 	par->match     = m->u.kernel.match;
 	par->matchinfo = m->data;
 
-	ret = xt_check_match(par, m->u.match_size - sizeof(*m),
-	      ip->proto, ip->invflags & IPT_INV_PROTO);
+	ret = xt_check_match(par, m->u.match_size - sizeof(*m), ip->proto,
+			     ip->invflags & IPT_INV_PROTO, true);
 	if (ret < 0) {
 		duprintf("check failed for `%s'.\n", par->match->name);
 		return ret;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index bdb1e27..0602685 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -715,8 +715,8 @@ static int check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par)
 	par->match     = m->u.kernel.match;
 	par->matchinfo = m->data;
 
-	ret = xt_check_match(par, m->u.match_size - sizeof(*m),
-			     ipv6->proto, ipv6->invflags & IP6T_INV_PROTO);
+	ret = xt_check_match(par, m->u.match_size - sizeof(*m), ipv6->proto,
+			     ipv6->invflags & IP6T_INV_PROTO, true);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 par.match->name);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f23195e..0eef61a 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -366,12 +366,15 @@ static char *textify_hooks(char *buf, size_t size, unsigned int mask)
 }
 
 int xt_check_match(struct xt_mtchk_param *par,
-		   unsigned int size, u_int8_t proto, bool inv_proto)
+		   unsigned int size, u_int8_t proto, bool inv_proto,
+		   bool check_pad)
 {
+	unsigned int required;
 	int ret;
 
-	if (XT_ALIGN(par->match->matchsize) != size &&
-	    par->match->matchsize != -1) {
+	required = check_pad ? XT_ALIGN(par->match->matchsize) :
+		   par->match->matchsize;
+	if (par->match->matchsize != -1 && required != size) {
 		/*
 		 * ebt_among is exempt from centralized matchsize checking
 		 * because it uses a dynamic-size data set.
@@ -379,8 +382,7 @@ int xt_check_match(struct xt_mtchk_param *par,
 		pr_err("%s_tables: %s.%u match: invalid size "
 		       "%u (kernel) != (user) %u\n",
 		       xt_prefix[par->family], par->match->name,
-		       par->match->revision,
-		       XT_ALIGN(par->match->matchsize), size);
+		       par->match->revision, required, size);
 		return -EINVAL;
 	}
 	if (par->match->table != NULL &&
-- 
1.7.1


From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 8/8] netfilter: xtables: consolidate code into xt_request_find_match
Date: Sat, 20 Mar 2010 02:02:21 +0100
Message-ID: <1269046942-31719-9-git-send-email-jengelh@medozas.de>
References: <1269046942-31719-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59723 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab0CTBCj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 21:02:39 -0400
In-Reply-To: <1269046942-31719-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    1 +
 net/bridge/netfilter/ebtables.c    |    5 +----
 net/ipv4/netfilter/ip_tables.c     |   18 ++++++++----------
 net/ipv6/netfilter/ip6_tables.c    |   18 ++++++++----------
 net/netfilter/x_tables.c           |   11 +++++++++++
 5 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index edba551..47eb99d 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -436,6 +436,7 @@ extern struct xt_table_info *xt_replace_table(struct xt_table *table,
 
 extern struct xt_match *xt_find_match(u8 af, const char *name, u8 revision);
 extern struct xt_target *xt_find_target(u8 af, const char *name, u8 revision);
+extern struct xt_match *xt_request_find_match(uint8_t, const char *, uint8_t);
 extern struct xt_target *xt_request_find_target(u8 af, const char *name,
 						u8 revision);
 extern int xt_find_revision(u8 af, const char *name, u8 revision,
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 6d3b256..c41f3fa 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -361,12 +361,9 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 	    left - sizeof(struct ebt_entry_match) < m->match_size)
 		return -EINVAL;
 
-	match = try_then_request_module(xt_find_match(NFPROTO_BRIDGE,
-		m->u.name, 0), "ebt_%s", m->u.name);
+	match = xt_request_find_match(NFPROTO_BRIDGE, m->u.name, 0);
 	if (IS_ERR(match))
 		return PTR_ERR(match);
-	if (match == NULL)
-		return -ENOENT;
 	m->u.match = match;
 
 	par->match     = match;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index d881a2c..dd845d8 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -629,12 +629,11 @@ find_check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par)
 	struct xt_match *match;
 	int ret;
 
-	match = try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
-						      m->u.user.revision),
-					"ipt_%s", m->u.user.name);
-	if (IS_ERR(match) || !match) {
+	match = xt_request_find_match(NFPROTO_IPV4, m->u.user.name,
+	        m->u.user.revision);
+	if (IS_ERR(match)) {
 		duprintf("find_check_match: `%s' not found\n", m->u.user.name);
-		return match ? PTR_ERR(match) : -ENOENT;
+		return PTR_ERR(match);
 	}
 	m->u.kernel.match = match;
 
@@ -1472,13 +1471,12 @@ compat_find_calc_match(struct ipt_entry_match *m,
 {
 	struct xt_match *match;
 
-	match = try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
-						      m->u.user.revision),
-					"ipt_%s", m->u.user.name);
-	if (IS_ERR(match) || !match) {
+	match = xt_request_find_match(NFPROTO_IPV4, m->u.user.name,
+	        m->u.user.revision);
+	if (IS_ERR(match)) {
 		duprintf("compat_check_calc_match: `%s' not found\n",
 			 m->u.user.name);
-		return match ? PTR_ERR(match) : -ENOENT;
+		return PTR_ERR(match);
 	}
 	m->u.kernel.match = match;
 	*size += xt_compat_match_offset(match);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f481fbb..b0d5d41 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -660,12 +660,11 @@ find_check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par)
 	struct xt_match *match;
 	int ret;
 
-	match = try_then_request_module(xt_find_match(AF_INET6, m->u.user.name,
-						      m->u.user.revision),
-					"ip6t_%s", m->u.user.name);
-	if (IS_ERR(match) || !match) {
+	match = xt_request_find_match(NFPROTO_IPV6, m->u.user.name,
+	        m->u.user.revision);
+	if (IS_ERR(match)) {
 		duprintf("find_check_match: `%s' not found\n", m->u.user.name);
-		return match ? PTR_ERR(match) : -ENOENT;
+		return PTR_ERR(match);
 	}
 	m->u.kernel.match = match;
 
@@ -1506,13 +1505,12 @@ compat_find_calc_match(struct ip6t_entry_match *m,
 {
 	struct xt_match *match;
 
-	match = try_then_request_module(xt_find_match(AF_INET6, m->u.user.name,
-						      m->u.user.revision),
-					"ip6t_%s", m->u.user.name);
-	if (IS_ERR(match) || !match) {
+	match = xt_request_find_match(NFPROTO_IPV6, m->u.user.name,
+	        m->u.user.revision);
+	if (IS_ERR(match)) {
 		duprintf("compat_check_calc_match: `%s' not found\n",
 			 m->u.user.name);
-		return match ? PTR_ERR(match) : -ENOENT;
+		return PTR_ERR(match);
 	}
 	m->u.kernel.match = match;
 	*size += xt_compat_match_offset(match);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 6bf45d6..b18e626 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -214,6 +214,17 @@ struct xt_match *xt_find_match(u8 af, const char *name, u8 revision)
 }
 EXPORT_SYMBOL(xt_find_match);
 
+struct xt_match *
+xt_request_find_match(uint8_t nfproto, const char *name, uint8_t revision)
+{
+	struct xt_match *match;
+
+	match = try_then_request_module(xt_find_match(nfproto, name, revision),
+	        "%st_%s", xt_prefix[nfproto], name);
+	return (match != NULL) ? match : ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL_GPL(xt_request_find_match);
+
 /* Find target, grabs ref.  Returns ERR_PTR() on error. */
 struct xt_target *xt_find_target(u8 af, const char *name, u8 revision)
 {
-- 
1.7.0.2


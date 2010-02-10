From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/6] netfilter: xtables: constify args in compat copying functions
Date: Wed, 10 Feb 2010 18:39:05 +0100
Message-ID: <1265823547-10358-6-git-send-email-jengelh@medozas.de>
References: <1265823547-10358-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57299 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab0BJRjT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:39:19 -0500
In-Reply-To: <1265823547-10358-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   12 ++++++------
 net/ipv4/netfilter/arp_tables.c    |    4 ++--
 net/ipv4/netfilter/ip_tables.c     |    4 ++--
 net/ipv4/netfilter/ipt_ULOG.c      |    4 ++--
 net/ipv6/netfilter/ip6_tables.c    |    4 ++--
 net/netfilter/x_tables.c           |    8 ++++----
 net/netfilter/xt_hashlimit.c       |    4 ++--
 net/netfilter/xt_limit.c           |    4 ++--
 8 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index fdd3342..3d39e6e 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -287,8 +287,8 @@ struct xt_match {
 	void (*destroy)(const struct xt_mtdtor_param *);
 #ifdef CONFIG_COMPAT
 	/* Called when userspace align differs from kernel space one */
-	void (*compat_from_user)(void *dst, void *src);
-	int (*compat_to_user)(void __user *dst, void *src);
+	void (*compat_from_user)(void *dst, const void *src);
+	int (*compat_to_user)(void __user *dst, const void *src);
 #endif
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -329,8 +329,8 @@ struct xt_target {
 	void (*destroy)(const struct xt_tgdtor_param *);
 #ifdef CONFIG_COMPAT
 	/* Called when userspace align differs from kernel space one */
-	void (*compat_from_user)(void *dst, void *src);
-	int (*compat_to_user)(void __user *dst, void *src);
+	void (*compat_from_user)(void *dst, const void *src);
+	int (*compat_to_user)(void __user *dst, const void *src);
 #endif
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -592,13 +592,13 @@ extern short xt_compat_calc_jump(u_int8_t af, unsigned int offset);
 extern int xt_compat_match_offset(const struct xt_match *match);
 extern int xt_compat_match_from_user(struct xt_entry_match *m,
 				     void **dstptr, unsigned int *size);
-extern int xt_compat_match_to_user(struct xt_entry_match *m,
+extern int xt_compat_match_to_user(const struct xt_entry_match *m,
 				   void __user **dstptr, unsigned int *size);
 
 extern int xt_compat_target_offset(const struct xt_target *target);
 extern void xt_compat_target_from_user(struct xt_entry_target *t,
 				       void **dstptr, unsigned int *size);
-extern int xt_compat_target_to_user(struct xt_entry_target *t,
+extern int xt_compat_target_to_user(const struct xt_entry_target *t,
 				    void __user **dstptr, unsigned int *size);
 
 #endif /* CONFIG_COMPAT */
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 72723ea..2303dc9 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -842,7 +842,7 @@ static int copy_entries_to_user(unsigned int total_size,
 }
 
 #ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, void *src)
+static void compat_standard_from_user(void *dst, const void *src)
 {
 	int v = *(compat_int_t *)src;
 
@@ -851,7 +851,7 @@ static void compat_standard_from_user(void *dst, void *src)
 	memcpy(dst, &v, sizeof(v));
 }
 
-static int compat_standard_to_user(void __user *dst, void *src)
+static int compat_standard_to_user(void __user *dst, const void *src)
 {
 	compat_int_t cv = *(int *)src;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2057b1b..2a4f745 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1047,7 +1047,7 @@ copy_entries_to_user(unsigned int total_size,
 }
 
 #ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, void *src)
+static void compat_standard_from_user(void *dst, const void *src)
 {
 	int v = *(compat_int_t *)src;
 
@@ -1056,7 +1056,7 @@ static void compat_standard_from_user(void *dst, void *src)
 	memcpy(dst, &v, sizeof(v));
 }
 
-static int compat_standard_to_user(void __user *dst, void *src)
+static int compat_standard_to_user(void __user *dst, const void *src)
 {
 	compat_int_t cv = *(int *)src;
 
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 399061c..09a5d3f 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -338,7 +338,7 @@ struct compat_ipt_ulog_info {
 	char		prefix[ULOG_PREFIX_LEN];
 };
 
-static void ulog_tg_compat_from_user(void *dst, void *src)
+static void ulog_tg_compat_from_user(void *dst, const void *src)
 {
 	const struct compat_ipt_ulog_info *cl = src;
 	struct ipt_ulog_info l = {
@@ -351,7 +351,7 @@ static void ulog_tg_compat_from_user(void *dst, void *src)
 	memcpy(dst, &l, sizeof(l));
 }
 
-static int ulog_tg_compat_to_user(void __user *dst, void *src)
+static int ulog_tg_compat_to_user(void __user *dst, const void *src)
 {
 	const struct ipt_ulog_info *l = src;
 	struct compat_ipt_ulog_info cl = {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index dcd7825..3ff4fd5 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1079,7 +1079,7 @@ copy_entries_to_user(unsigned int total_size,
 }
 
 #ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, void *src)
+static void compat_standard_from_user(void *dst, const void *src)
 {
 	int v = *(compat_int_t *)src;
 
@@ -1088,7 +1088,7 @@ static void compat_standard_from_user(void *dst, void *src)
 	memcpy(dst, &v, sizeof(v));
 }
 
-static int compat_standard_to_user(void __user *dst, void *src)
+static int compat_standard_to_user(void __user *dst, const void *src)
 {
 	compat_int_t cv = *(int *)src;
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 760ea3e..2120ab7 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -485,8 +485,8 @@ int xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
 }
 EXPORT_SYMBOL_GPL(xt_compat_match_from_user);
 
-int xt_compat_match_to_user(struct xt_entry_match *m, void __user **dstptr,
-			    unsigned int *size)
+int xt_compat_match_to_user(const struct xt_entry_match *m,
+			    void __user **dstptr, unsigned int *size)
 {
 	const struct xt_match *match = m->u.kernel.match;
 	struct compat_xt_entry_match __user *cm = *dstptr;
@@ -588,8 +588,8 @@ void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
 }
 EXPORT_SYMBOL_GPL(xt_compat_target_from_user);
 
-int xt_compat_target_to_user(struct xt_entry_target *t, void __user **dstptr,
-			     unsigned int *size)
+int xt_compat_target_to_user(const struct xt_entry_target *t,
+			     void __user **dstptr, unsigned int *size)
 {
 	const struct xt_target *target = t->u.kernel.target;
 	struct compat_xt_entry_target __user *ct = *dstptr;
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 017c959..e47fb80 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -775,7 +775,7 @@ struct compat_xt_hashlimit_info {
 	compat_uptr_t master;
 };
 
-static void hashlimit_mt_compat_from_user(void *dst, void *src)
+static void hashlimit_mt_compat_from_user(void *dst, const void *src)
 {
 	int off = offsetof(struct compat_xt_hashlimit_info, hinfo);
 
@@ -783,7 +783,7 @@ static void hashlimit_mt_compat_from_user(void *dst, void *src)
 	memset(dst + off, 0, sizeof(struct compat_xt_hashlimit_info) - off);
 }
 
-static int hashlimit_mt_compat_to_user(void __user *dst, void *src)
+static int hashlimit_mt_compat_to_user(void __user *dst, const void *src)
 {
 	int off = offsetof(struct compat_xt_hashlimit_info, hinfo);
 
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 2773be6..a0ca533 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -148,7 +148,7 @@ struct compat_xt_rateinfo {
 
 /* To keep the full "prev" timestamp, the upper 32 bits are stored in the
  * master pointer, which does not need to be preserved. */
-static void limit_mt_compat_from_user(void *dst, void *src)
+static void limit_mt_compat_from_user(void *dst, const void *src)
 {
 	const struct compat_xt_rateinfo *cm = src;
 	struct xt_rateinfo m = {
@@ -162,7 +162,7 @@ static void limit_mt_compat_from_user(void *dst, void *src)
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int limit_mt_compat_to_user(void __user *dst, void *src)
+static int limit_mt_compat_to_user(void __user *dst, const void *src)
 {
 	const struct xt_rateinfo *m = src;
 	struct compat_xt_rateinfo cm = {
-- 
1.6.6.1


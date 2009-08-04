From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 031/103] netfilter: xtables: constify args in compat copying functions
Date: Tue,  4 Aug 2009 09:25:15 +0200
Message-ID: <1249370787-17583-32-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50628 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551AbZHDH1H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:07 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
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
index bdcb2f6..5e434a1 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -291,8 +291,8 @@ struct xt_match
 	void (*destroy)(const struct xt_mtdtor_param *);
 
 	/* Called when userspace align differs from kernel space one */
-	void (*compat_from_user)(void *dst, void *src);
-	int (*compat_to_user)(void __user *dst, void *src);
+	void (*compat_from_user)(void *dst, const void *src);
+	int (*compat_to_user)(void __user *dst, const void *src);
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -332,8 +332,8 @@ struct xt_target
 	void (*destroy)(const struct xt_tgdtor_param *);
 
 	/* Called when userspace align differs from kernel space one */
-	void (*compat_from_user)(void *dst, void *src);
-	int (*compat_to_user)(void __user *dst, void *src);
+	void (*compat_from_user)(void *dst, const void *src);
+	int (*compat_to_user)(void __user *dst, const void *src);
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -600,13 +600,13 @@ extern short xt_compat_calc_jump(u_int8_t af, unsigned int offset);
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
index 27774c9..e6ea3e5 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -835,7 +835,7 @@ static int copy_entries_to_user(unsigned int total_size,
 }
 
 #ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, void *src)
+static void compat_standard_from_user(void *dst, const void *src)
 {
 	int v = *(compat_int_t *)src;
 
@@ -844,7 +844,7 @@ static void compat_standard_from_user(void *dst, void *src)
 	memcpy(dst, &v, sizeof(v));
 }
 
-static int compat_standard_to_user(void __user *dst, void *src)
+static int compat_standard_to_user(void __user *dst, const void *src)
 {
 	compat_int_t cv = *(int *)src;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index cde755d..4a0f22c 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1035,7 +1035,7 @@ copy_entries_to_user(unsigned int total_size,
 }
 
 #ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, void *src)
+static void compat_standard_from_user(void *dst, const void *src)
 {
 	int v = *(compat_int_t *)src;
 
@@ -1044,7 +1044,7 @@ static void compat_standard_from_user(void *dst, void *src)
 	memcpy(dst, &v, sizeof(v));
 }
 
-static int compat_standard_to_user(void __user *dst, void *src)
+static int compat_standard_to_user(void __user *dst, const void *src)
 {
 	compat_int_t cv = *(int *)src;
 
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index d32cc4b..0b02768 100644
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
index cc9f8ef..47ed731 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1067,7 +1067,7 @@ copy_entries_to_user(unsigned int total_size,
 }
 
 #ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, void *src)
+static void compat_standard_from_user(void *dst, const void *src)
 {
 	int v = *(compat_int_t *)src;
 
@@ -1076,7 +1076,7 @@ static void compat_standard_from_user(void *dst, void *src)
 	memcpy(dst, &v, sizeof(v));
 }
 
-static int compat_standard_to_user(void __user *dst, void *src)
+static int compat_standard_to_user(void __user *dst, const void *src)
 {
 	compat_int_t cv = *(int *)src;
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index ff4bd71..478e9c8 100644
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
index 219dcdb..91ddabb 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -767,7 +767,7 @@ struct compat_xt_hashlimit_info {
 	compat_uptr_t master;
 };
 
-static void hashlimit_mt_compat_from_user(void *dst, void *src)
+static void hashlimit_mt_compat_from_user(void *dst, const void *src)
 {
 	int off = offsetof(struct compat_xt_hashlimit_info, hinfo);
 
@@ -775,7 +775,7 @@ static void hashlimit_mt_compat_from_user(void *dst, void *src)
 	memset(dst + off, 0, sizeof(struct compat_xt_hashlimit_info) - off);
 }
 
-static int hashlimit_mt_compat_to_user(void __user *dst, void *src)
+static int hashlimit_mt_compat_to_user(void __user *dst, const void *src)
 {
 	int off = offsetof(struct compat_xt_hashlimit_info, hinfo);
 
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 2e8089e..dad26f9 100644
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
1.6.3.3


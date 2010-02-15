From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 7/7] netfilter: ebtables: mark: add CONFIG_COMPAT support
Date: Mon, 15 Feb 2010 22:05:39 +0100
Message-ID: <1266267939-7736-8-git-send-email-fw@strlen.de>
References: <1266267939-7736-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33317 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932089Ab0BOVG4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:06:56 -0500
In-Reply-To: <1266267939-7736-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the required handlers to convert 32 bit
ebtables mark match and match target structs to 64bit layout.

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 net/bridge/netfilter/ebt_mark.c   |   31 +++++++++++++++++++++++++++++++
 net/bridge/netfilter/ebt_mark_m.c |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 153e167..2b5ce53 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -52,6 +52,32 @@ static bool ebt_mark_tg_check(const struct xt_tgchk_param *par)
 		return false;
 	return true;
 }
+#ifdef CONFIG_COMPAT
+struct compat_ebt_mark_t_info {
+	compat_ulong_t mark;
+	compat_uint_t target;
+};
+
+static void mark_tg_compat_from_user(void *dst, const void *src)
+{
+	const struct compat_ebt_mark_t_info *user = src;
+	struct ebt_mark_t_info *kern = dst;
+
+	kern->mark = user->mark;
+	kern->target = user->target;
+}
+
+static int mark_tg_compat_to_user(void __user *dst, const void *src)
+{
+	struct compat_ebt_mark_t_info __user *user = dst;
+	const struct ebt_mark_t_info *kern = src;
+
+	if (put_user(kern->mark, &user->mark) ||
+	    put_user(kern->target, &user->target))
+		return -EFAULT;
+	return 0;
+}
+#endif
 
 static struct xt_target ebt_mark_tg_reg __read_mostly = {
 	.name		= "mark",
@@ -60,6 +86,11 @@ static struct xt_target ebt_mark_tg_reg __read_mostly = {
 	.target		= ebt_mark_tg,
 	.checkentry	= ebt_mark_tg_check,
 	.targetsize	= sizeof(struct ebt_mark_t_info),
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(struct compat_ebt_mark_t_info),
+	.compat_from_user = mark_tg_compat_from_user,
+	.compat_to_user	= mark_tg_compat_to_user,
+#endif
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 89abf40..0913638 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -35,6 +35,38 @@ static bool ebt_mark_mt_check(const struct xt_mtchk_param *par)
 	return true;
 }
 
+
+#ifdef CONFIG_COMPAT
+struct compat_ebt_mark_m_info {
+	compat_ulong_t mark, mask;
+	uint8_t invert, bitmask;
+};
+
+static void mark_mt_compat_from_user(void *dst, const void *src)
+{
+	const struct compat_ebt_mark_m_info *user = src;
+	struct ebt_mark_m_info *kern = dst;
+
+	kern->mark = user->mark;
+	kern->mask = user->mask;
+	kern->invert = user->invert;
+	kern->bitmask = user->bitmask;
+}
+
+static int mark_mt_compat_to_user(void __user *dst, const void *src)
+{
+	struct compat_ebt_mark_m_info __user *user = dst;
+	const struct ebt_mark_m_info *kern = src;
+
+	if (put_user(kern->mark, &user->mark) ||
+	    put_user(kern->mask, &user->mask) ||
+	    put_user(kern->invert, &user->invert) ||
+	    put_user(kern->bitmask,&user->bitmask))
+		return -EFAULT;
+	return 0;
+}
+#endif
+
 static struct xt_match ebt_mark_mt_reg __read_mostly = {
 	.name		= "mark_m",
 	.revision	= 0,
@@ -42,6 +74,11 @@ static struct xt_match ebt_mark_mt_reg __read_mostly = {
 	.match		= ebt_mark_mt,
 	.checkentry	= ebt_mark_mt_check,
 	.matchsize	= sizeof(struct ebt_mark_m_info),
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(struct compat_ebt_mark_m_info),
+	.compat_from_user = mark_mt_compat_from_user,
+	.compat_to_user	= mark_mt_compat_to_user,
+#endif
 	.me		= THIS_MODULE,
 };
 
-- 
1.6.4.4


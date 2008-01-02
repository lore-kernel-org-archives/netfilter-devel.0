From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 5/27] Remove CONFIG_COMPAT code in xt_hashlimit, xt_limit
Date: Wed, 2 Jan 2008 21:26:53 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022126330.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60575 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbYABU0z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:26:55 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 5dc63a190ced8162bad4709daa5442cad693ef2f
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 17:40:31 2008 +0100

    [NETFILTER]: Remove CONFIG_COMPAT code in xt_hashlimit, xt_limit
    
    The kernel parts of the structures do not need to be fixed nor
    compat-converted; all other fields already use fixed types, so the
    compat code is not needed.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 net/netfilter/xt_hashlimit.c |   34 ---------------------
 net/netfilter/xt_limit.c     |   54 ----------------------------------
 2 files changed, 0 insertions(+), 88 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index c35d220..1b48153 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -565,41 +565,12 @@ hashlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
 	htable_put(r->hinfo);
 }
 
-#ifdef CONFIG_COMPAT
-struct compat_xt_hashlimit_info {
-	char name[IFNAMSIZ];
-	struct hashlimit_cfg cfg;
-	compat_uptr_t hinfo;
-	compat_uptr_t master;
-};
-
-static void hashlimit_mt_compat_from_user(void *dst, void *src)
-{
-	int off = offsetof(struct compat_xt_hashlimit_info, hinfo);
-
-	memcpy(dst, src, off);
-	memset(dst + off, 0, sizeof(struct compat_xt_hashlimit_info) - off);
-}
-
-static int hashlimit_mt_compat_to_user(void __user *dst, void *src)
-{
-	int off = offsetof(struct compat_xt_hashlimit_info, hinfo);
-
-	return copy_to_user(dst, src, off) ? -EFAULT : 0;
-}
-#endif
-
 static struct xt_match hashlimit_mt_reg[] __read_mostly = {
 	{
 		.name		= "hashlimit",
 		.family		= AF_INET,
 		.match		= hashlimit_mt,
 		.matchsize	= sizeof(struct xt_hashlimit_info),
-#ifdef CONFIG_COMPAT
-		.compatsize	= sizeof(struct compat_xt_hashlimit_info),
-		.compat_from_user = hashlimit_mt_compat_from_user,
-		.compat_to_user	= hashlimit_mt_compat_to_user,
-#endif
 		.checkentry	= hashlimit_mt_check,
 		.destroy	= hashlimit_mt_destroy,
 		.me		= THIS_MODULE
@@ -610,11 +581,6 @@ static struct xt_match hashlimit_mt_reg[] __read_mostly = {
 		.family		= AF_INET6,
 		.match		= hashlimit_mt,
 		.matchsize	= sizeof(struct xt_hashlimit_info),
-#ifdef CONFIG_COMPAT
-		.compatsize	= sizeof(struct compat_xt_hashlimit_info),
-		.compat_from_user = hashlimit_mt_compat_from_user,
-		.compat_to_user	= hashlimit_mt_compat_to_user,
-#endif
 		.checkentry	= hashlimit_mt_check,
 		.destroy	= hashlimit_mt_destroy,
 		.me		= THIS_MODULE
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 2ef0dbf..ad89a1d 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -123,50 +123,6 @@ limit_mt_check(const char *tablename, const void *inf,
 	return true;
 }
 
-#ifdef CONFIG_COMPAT
-struct compat_xt_rateinfo {
-	u_int32_t avg;
-	u_int32_t burst;
-
-	compat_ulong_t prev;
-	u_int32_t credit;
-	u_int32_t credit_cap, cost;
-
-	u_int32_t master;
-};
-
-/* To keep the full "prev" timestamp, the upper 32 bits are stored in the
- * master pointer, which does not need to be preserved. */
-static void limit_mt_compat_from_user(void *dst, void *src)
-{
-	const struct compat_xt_rateinfo *cm = src;
-	struct xt_rateinfo m = {
-		.avg		= cm->avg,
-		.burst		= cm->burst,
-		.prev		= cm->prev | (unsigned long)cm->master << 32,
-		.credit		= cm->credit,
-		.credit_cap	= cm->credit_cap,
-		.cost		= cm->cost,
-	};
-	memcpy(dst, &m, sizeof(m));
-}
-
-static int limit_mt_compat_to_user(void __user *dst, void *src)
-{
-	const struct xt_rateinfo *m = src;
-	struct compat_xt_rateinfo cm = {
-		.avg		= m->avg,
-		.burst		= m->burst,
-		.prev		= m->prev,
-		.credit		= m->credit,
-		.credit_cap	= m->credit_cap,
-		.cost		= m->cost,
-		.master		= m->prev >> 32,
-	};
-	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
-}
-#endif /* CONFIG_COMPAT */
-
 static struct xt_match limit_mt_reg[] __read_mostly = {
 	{
 		.name		= "limit",
@@ -174,11 +130,6 @@ static struct xt_match limit_mt_reg[] __read_mostly = {
 		.checkentry	= limit_mt_check,
 		.match		= limit_mt,
 		.matchsize	= sizeof(struct xt_rateinfo),
-#ifdef CONFIG_COMPAT
-		.compatsize	= sizeof(struct compat_xt_rateinfo),
-		.compat_from_user = limit_mt_compat_from_user,
-		.compat_to_user	= limit_mt_compat_to_user,
-#endif
 		.me		= THIS_MODULE,
 	},
 	{
@@ -187,11 +138,6 @@ static struct xt_match limit_mt_reg[] __read_mostly = {
 		.checkentry	= limit_mt_check,
 		.match		= limit_mt,
 		.matchsize	= sizeof(struct xt_rateinfo),
-#ifdef CONFIG_COMPAT
-		.compatsize	= sizeof(struct compat_xt_rateinfo),
-		.compat_from_user = limit_mt_compat_from_user,
-		.compat_to_user	= limit_mt_compat_to_user,
-#endif
 		.me		= THIS_MODULE,
 	},
 };

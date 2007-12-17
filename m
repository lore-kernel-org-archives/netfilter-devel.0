From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/64]: xt_MARK: add compat support for revision 0
Date: Tue, 18 Dec 2007 00:46:36 +0100 (MET)
Message-ID: <20071217234635.23601.91188.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38930 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbXLQXqh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:37 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_MARK: add compat support for revision 0

Old userspace doesn't support revision 1, especially for IPv6, which
is only available in the SVN snapshot.

Add compat support for revision 0.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1d1b0c11ae4ac0beacfc129f003ddeb8c5b6f691
tree a02922b3ad4618c980db9759e4d04ea5df191107
parent e0b1699a604d191d46470fa8af7f211cd905bd78
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:56 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:53 +0100

 net/netfilter/xt_MARK.c |   44 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 5bf9121..57c6d55 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -94,6 +94,28 @@ mark_tg_check(const char *tablename, const void *entry,
 }
 
 #ifdef CONFIG_COMPAT
+struct compat_xt_mark_target_info {
+	compat_ulong_t	mark;
+};
+
+static void mark_tg_compat_from_user(void *dst, void *src)
+{
+	const struct compat_xt_mark_target_info *cm = src;
+	struct xt_mark_target_info m = {
+		.mark	= cm->mark,
+	};
+	memcpy(dst, &m, sizeof(m));
+}
+
+static int mark_tg_compat_to_user(void __user *dst, void *src)
+{
+	const struct xt_mark_target_info *m = src;
+	struct compat_xt_mark_target_info cm = {
+		.mark	= m->mark,
+	};
+	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
+}
+
 struct compat_xt_mark_target_info_v1 {
 	compat_ulong_t	mark;
 	u_int8_t	mode;
@@ -101,7 +123,7 @@ struct compat_xt_mark_target_info_v1 {
 	u_int16_t	__pad2;
 };
 
-static void mark_tg_compat_from_user(void *dst, void *src)
+static void mark_tg_compat_from_user_v1(void *dst, void *src)
 {
 	const struct compat_xt_mark_target_info_v1 *cm = src;
 	struct xt_mark_target_info_v1 m = {
@@ -111,7 +133,7 @@ static void mark_tg_compat_from_user(void *dst, void *src)
 	memcpy(dst, &m, sizeof(m));
 }
 
-static int mark_tg_compat_to_user(void __user *dst, void *src)
+static int mark_tg_compat_to_user_v1(void __user *dst, void *src)
 {
 	const struct xt_mark_target_info_v1 *m = src;
 	struct compat_xt_mark_target_info_v1 cm = {
@@ -130,6 +152,11 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.checkentry	= mark_tg_check_v0,
 		.target		= mark_tg_v0,
 		.targetsize	= sizeof(struct xt_mark_target_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_mark_target_info),
+		.compat_from_user = mark_tg_compat_from_user,
+		.compat_to_user	= mark_tg_compat_to_user,
+#endif
 		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
@@ -142,8 +169,8 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.targetsize	= sizeof(struct xt_mark_target_info_v1),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_mark_target_info_v1),
-		.compat_from_user = mark_tg_compat_from_user,
-		.compat_to_user	= mark_tg_compat_to_user,
+		.compat_from_user = mark_tg_compat_from_user_v1,
+		.compat_to_user	= mark_tg_compat_to_user_v1,
 #endif
 		.table		= "mangle",
 		.me		= THIS_MODULE,
@@ -155,6 +182,11 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.checkentry	= mark_tg_check_v0,
 		.target		= mark_tg_v0,
 		.targetsize	= sizeof(struct xt_mark_target_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_mark_target_info),
+		.compat_from_user = mark_tg_compat_from_user,
+		.compat_to_user	= mark_tg_compat_to_user,
+#endif
 		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
@@ -167,8 +199,8 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.targetsize	= sizeof(struct xt_mark_target_info_v1),
 #ifdef CONFIG_COMPAT
 		.compatsize	= sizeof(struct compat_xt_mark_target_info_v1),
-		.compat_from_user = mark_tg_compat_from_user,
-		.compat_to_user	= mark_tg_compat_to_user,
+		.compat_from_user = mark_tg_compat_from_user_v1,
+		.compat_to_user	= mark_tg_compat_to_user_v1,
 #endif
 		.table		= "mangle",
 		.me		= THIS_MODULE,

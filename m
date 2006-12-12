From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/06]: x_tables: add missing try to load conntrack from
	match/targets
Date: Tue, 12 Dec 2006 09:06:24 +0100 (MET)
Message-ID: <20061212080947.4788.45180.sendpatchset@localhost.localdomain>
References: <20061212080941.4788.16630.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061212080941.4788.16630.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: x_tables: add missing try to load conntrack from match/targets

CLUSTERIP, CONNMARK, CONNSECMARK, and connbytes need ip_conntrack or
layer 3 protocol module of nf_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c5cea7a103d6bc40bd6c84805ee38b0262632a4d
tree 6efd0e5354ce15b6c912eea12f95760523f0cd46
parent 806a57fff01366038e04747ea75adf2c7c5db09f
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 12 Dec 2006 08:50:46 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 12 Dec 2006 08:50:46 +0100

 net/ipv4/netfilter/ipt_CLUSTERIP.c |    8 ++++++++
 net/netfilter/xt_CONNMARK.c        |   14 +++++++++++++-
 net/netfilter/xt_CONNSECMARK.c     |   14 +++++++++++++-
 net/netfilter/xt_connbytes.c       |   14 ++++++++++++++
 4 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index fef56ae..b1c1116 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -447,6 +447,12 @@ checkentry(const char *tablename,
 		cipinfo->config = config;
 	}
 
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%d\n", target->family);
+		return 0;
+	}
+
 	return 1;
 }
 
@@ -460,6 +466,8 @@ static void destroy(const struct xt_targ
 	clusterip_config_entry_put(cipinfo->config);
 
 	clusterip_config_put(cipinfo->config);
+
+	nf_ct_l3proto_module_put(target->family);
 }
 
 static struct ipt_target clusterip_tgt = {
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index b554823..0534bfa 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -96,6 +96,11 @@ checkentry(const char *tablename,
 {
 	struct xt_connmark_target_info *matchinfo = targinfo;
 
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%d\n", target->family);
+		return 0;
+	}
 	if (matchinfo->mode == XT_CONNMARK_RESTORE) {
 		if (strcmp(tablename, "mangle") != 0) {
 			printk(KERN_WARNING "CONNMARK: restore can only be "
@@ -111,6 +116,12 @@ checkentry(const char *tablename,
 	return 1;
 }
 
+static void
+destroy(const struct xt_target *target, void *targinfo)
+{
+	nf_ct_l3proto_module_put(target->family);
+}
+
 #ifdef CONFIG_COMPAT
 struct compat_xt_connmark_target_info {
 	compat_ulong_t	mark, mask;
@@ -147,6 +158,7 @@ static struct xt_target xt_connmark_targ
 		.name		= "CONNMARK",
 		.family		= AF_INET,
 		.checkentry	= checkentry,
+		.destroy	= destroy,
 		.target		= target,
 		.targetsize	= sizeof(struct xt_connmark_target_info),
 #ifdef CONFIG_COMPAT
@@ -160,6 +172,7 @@ #endif
 		.name		= "CONNMARK",
 		.family		= AF_INET6,
 		.checkentry	= checkentry,
+		.destroy	= destroy,
 		.target		= target,
 		.targetsize	= sizeof(struct xt_connmark_target_info),
 		.me		= THIS_MODULE
@@ -168,7 +181,6 @@ #endif
 
 static int __init xt_connmark_init(void)
 {
-	need_conntrack();
 	return xt_register_targets(xt_connmark_target,
 				   ARRAY_SIZE(xt_connmark_target));
 }
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 4673862..a3fe3c3 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -93,6 +93,11 @@ static int checkentry(const char *tablen
 {
 	struct xt_connsecmark_target_info *info = targinfo;
 
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%d\n", target->family);
+		return 0;
+	}
 	switch (info->mode) {
 	case CONNSECMARK_SAVE:
 	case CONNSECMARK_RESTORE:
@@ -106,11 +111,18 @@ static int checkentry(const char *tablen
 	return 1;
 }
 
+static void
+destroy(const struct xt_target *target, void *targinfo)
+{
+	nf_ct_l3proto_module_put(target->family);
+}
+
 static struct xt_target xt_connsecmark_target[] = {
 	{
 		.name		= "CONNSECMARK",
 		.family		= AF_INET,
 		.checkentry	= checkentry,
+		.destroy	= destroy,
 		.target		= target,
 		.targetsize	= sizeof(struct xt_connsecmark_target_info),
 		.table		= "mangle",
@@ -120,6 +132,7 @@ static struct xt_target xt_connsecmark_t
 		.name		= "CONNSECMARK",
 		.family		= AF_INET6,
 		.checkentry	= checkentry,
+		.destroy	= destroy,
 		.target		= target,
 		.targetsize	= sizeof(struct xt_connsecmark_target_info),
 		.table		= "mangle",
@@ -129,7 +142,6 @@ static struct xt_target xt_connsecmark_t
 
 static int __init xt_connsecmark_init(void)
 {
-	need_conntrack();
 	return xt_register_targets(xt_connsecmark_target,
 				   ARRAY_SIZE(xt_connsecmark_target));
 }
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index dcc497e..d93cb09 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -139,15 +139,28 @@ static int check(const char *tablename,
 	    sinfo->direction != XT_CONNBYTES_DIR_BOTH)
 		return 0;
 
+	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%d\n", match->family);
+		return 0;
+	}
+
 	return 1;
 }
 
+static void
+destroy(const struct xt_match *match, void *matchinfo)
+{
+	nf_ct_l3proto_module_put(match->family);
+}
+
 static struct xt_match xt_connbytes_match[] = {
 	{
 		.name		= "connbytes",
 		.family		= AF_INET,
 		.checkentry	= check,
 		.match		= match,
+		.destroy	= destroy,
 		.matchsize	= sizeof(struct xt_connbytes_info),
 		.me		= THIS_MODULE
 	},
@@ -156,6 +169,7 @@ static struct xt_match xt_connbytes_matc
 		.family		= AF_INET6,
 		.checkentry	= check,
 		.match		= match,
+		.destroy	= destroy,
 		.matchsize	= sizeof(struct xt_connbytes_info),
 		.me		= THIS_MODULE
 	},

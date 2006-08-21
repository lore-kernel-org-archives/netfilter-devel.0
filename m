From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/18]: x_tables: make use of mass registation helpers
Date: Tue, 22 Aug 2006 00:52:34 +0200 (MEST)
Message-ID: <20060821225233.10288.88842.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: make use of mass registation helpers

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 160a7782ed42f6295b9d68b18bda7eb1f37e86a0
tree 2c97b54f8e555aa4093c9aac8a824dfefc822b37
parent 15e38196fbab0fbedc31889f45440b9fe6fdf257
author Patrick McHardy <kaber@trash.net> Sun, 13 Aug 2006 19:02:45 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 13 Aug 2006 19:02:45 +0200

 net/ipv6/netfilter/ip6t_REJECT.c |    4 -
 net/netfilter/xt_CLASSIFY.c      |   60 +++++++++------------
 net/netfilter/xt_CONNMARK.c      |   51 +++++++----------
 net/netfilter/xt_CONNSECMARK.c   |   57 ++++++++------------
 net/netfilter/xt_DSCP.c          |   51 +++++++----------
 net/netfilter/xt_MARK.c          |   84 +++++++++++------------------
 net/netfilter/xt_NFQUEUE.c       |   68 +++++++++--------------
 net/netfilter/xt_NOTRACK.c       |   47 ++++++----------
 net/netfilter/xt_SECMARK.c       |   55 ++++++++-----------
 net/netfilter/xt_comment.c       |   45 ++++++---------
 net/netfilter/xt_connbytes.c     |   47 +++++++---------
 net/netfilter/xt_connmark.c      |   53 ++++++++----------
 net/netfilter/xt_conntrack.c     |    5 --
 net/netfilter/xt_dccp.c          |   51 +++++++----------
 net/netfilter/xt_dscp.c          |   47 +++++++---------
 net/netfilter/xt_esp.c           |   51 +++++++----------
 net/netfilter/xt_helper.c        |   52 ++++++++----------
 net/netfilter/xt_length.c        |   43 ++++++---------
 net/netfilter/xt_limit.c         |   47 +++++++---------
 net/netfilter/xt_mac.c           |   52 ++++++++----------
 net/netfilter/xt_mark.c          |   47 +++++++---------
 net/netfilter/xt_multiport.c     |  111 ++++++++++++++------------------------
 net/netfilter/xt_physdev.c       |   49 +++++++----------
 net/netfilter/xt_pkttype.c       |   44 ++++++---------
 net/netfilter/xt_policy.c        |   51 ++++++++---------
 net/netfilter/xt_quota.c         |   51 +++++++----------
 net/netfilter/xt_sctp.c          |   51 +++++++----------
 net/netfilter/xt_state.c         |   53 +++++++-----------
 net/netfilter/xt_statistic.c     |   53 +++++++-----------
 net/netfilter/xt_string.c        |   50 +++++++----------
 net/netfilter/xt_tcpmss.c        |   49 +++++++----------
 net/netfilter/xt_tcpudp.c        |  107 ++++++++++++++-----------------------
 32 files changed, 679 insertions(+), 1007 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index c4eba1a..7929ff4 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -257,9 +257,7 @@ static struct ip6t_target ip6t_reject_re
 
 static int __init ip6t_reject_init(void)
 {
-	if (ip6t_register_target(&ip6t_reject_reg))
-		return -EINVAL;
-	return 0;
+	return ip6t_register_target(&ip6t_reject_reg);
 }
 
 static void __exit ip6t_reject_fini(void)
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index e54e577..2d77ebb 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -40,47 +40,41 @@ target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static struct xt_target classify_reg = { 
-	.name 		= "CLASSIFY", 
-	.target 	= target,
-	.targetsize	= sizeof(struct xt_classify_target_info),
-	.table		= "mangle",
-	.hooks		= (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
-		          (1 << NF_IP_POST_ROUTING),
-	.family		= AF_INET,
-	.me 		= THIS_MODULE,
+static struct xt_target xt_classify_target[] = {
+	{
+		.family		= AF_INET,
+		.name 		= "CLASSIFY",
+		.target 	= target,
+		.targetsize	= sizeof(struct xt_classify_target_info),
+		.table		= "mangle",
+		.hooks		= (1 << NF_IP_LOCAL_OUT) |
+				  (1 << NF_IP_FORWARD) |
+			          (1 << NF_IP_POST_ROUTING),
+		.me 		= THIS_MODULE,
+	},
+	{
+		.name 		= "CLASSIFY",
+		.family		= AF_INET6,
+		.target 	= target,
+		.targetsize	= sizeof(struct xt_classify_target_info),
+		.table		= "mangle",
+		.hooks		= (1 << NF_IP_LOCAL_OUT) |
+				  (1 << NF_IP_FORWARD) |
+			          (1 << NF_IP_POST_ROUTING),
+		.me 		= THIS_MODULE,
+	},
 };
-static struct xt_target classify6_reg = { 
-	.name 		= "CLASSIFY", 
-	.target 	= target,
-	.targetsize	= sizeof(struct xt_classify_target_info),
-	.table		= "mangle",
-	.hooks		= (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
-		          (1 << NF_IP_POST_ROUTING),
-	.family		= AF_INET6,
-	.me 		= THIS_MODULE,
-};
-
 
 static int __init xt_classify_init(void)
 {
-	int ret;
-
-	ret = xt_register_target(&classify_reg);
-	if (ret)
-		return ret;
-
-	ret = xt_register_target(&classify6_reg);
-	if (ret)
-		xt_unregister_target(&classify_reg);
-
-	return ret;
+	return xt_register_targets(xt_classify_target,
+				   ARRAY_SIZE(xt_classify_target));
 }
 
 static void __exit xt_classify_fini(void)
 {
-	xt_unregister_target(&classify_reg);
-	xt_unregister_target(&classify6_reg);
+	xt_unregister_targets(xt_classify_target,
+			      ARRAY_SIZE(xt_classify_target));
 }
 
 module_init(xt_classify_init);
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 19989a9..e577356 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -110,45 +110,36 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct xt_target connmark_reg = {
-	.name		= "CONNMARK",
-	.target		= target,
-	.targetsize	= sizeof(struct xt_connmark_target_info),
-	.checkentry	= checkentry,
-	.family		= AF_INET,
-	.me		= THIS_MODULE
-};
-
-static struct xt_target connmark6_reg = {
-	.name		= "CONNMARK",
-	.target		= target,
-	.targetsize	= sizeof(struct xt_connmark_target_info),
-	.checkentry	= checkentry,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE
+static struct xt_target xt_connmark_target[] = {
+	{
+		.name		= "CONNMARK",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.target		= target,
+		.targetsize	= sizeof(struct xt_connmark_target_info),
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "CONNMARK",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.target		= target,
+		.targetsize	= sizeof(struct xt_connmark_target_info),
+		.me		= THIS_MODULE
+	},
 };
 
 static int __init xt_connmark_init(void)
 {
-	int ret;
-
 	need_conntrack();
-
-	ret = xt_register_target(&connmark_reg);
-	if (ret)
-		return ret;
-
-	ret = xt_register_target(&connmark6_reg);
-	if (ret)
-		xt_unregister_target(&connmark_reg);
-
-	return ret;
+	return xt_register_targets(xt_connmark_target,
+				   ARRAY_SIZE(xt_connmark_target));
 }
 
 static void __exit xt_connmark_fini(void)
 {
-	xt_unregister_target(&connmark_reg);
-	xt_unregister_target(&connmark6_reg);
+	xt_unregister_targets(xt_connmark_target,
+			      ARRAY_SIZE(xt_connmark_target));
 }
 
 module_init(xt_connmark_init);
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 8c011e0..48f7fc3 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -106,49 +106,38 @@ static int checkentry(const char *tablen
 	return 1;
 }
 
-static struct xt_target ipt_connsecmark_reg = {
-	.name		= "CONNSECMARK",
-	.target		= target,
-	.targetsize	= sizeof(struct xt_connsecmark_target_info),
-	.table		= "mangle",
-	.checkentry	= checkentry,
-	.me		= THIS_MODULE,
-	.family		= AF_INET,
-	.revision	= 0,
-};
-
-static struct xt_target ip6t_connsecmark_reg = {
-	.name		= "CONNSECMARK",
-	.target		= target,
-	.targetsize	= sizeof(struct xt_connsecmark_target_info),
-	.table		= "mangle",
-	.checkentry	= checkentry,
-	.me		= THIS_MODULE,
-	.family		= AF_INET6,
-	.revision	= 0,
+static struct xt_target xt_connsecmark_target[] = {
+	{
+		.name		= "CONNSECMARK",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.target		= target,
+		.targetsize	= sizeof(struct xt_connsecmark_target_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "CONNSECMARK",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.target		= target,
+		.targetsize	= sizeof(struct xt_connsecmark_target_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_connsecmark_init(void)
 {
-	int err;
-
 	need_conntrack();
-
-	err = xt_register_target(&ipt_connsecmark_reg);
-	if (err)
-		return err;
-
-	err = xt_register_target(&ip6t_connsecmark_reg);
-	if (err)
-		xt_unregister_target(&ipt_connsecmark_reg);
-
-	return err;
+	return xt_register_targets(xt_connsecmark_targets,
+				   ARRAY_SIZE(xt_connsecmark_targets));
 }
 
 static void __exit xt_connsecmark_fini(void)
 {
-	xt_unregister_target(&ip6t_connsecmark_reg);
-	xt_unregister_target(&ipt_connsecmark_reg);
+	xt_unregister_targets(xt_connsecmark_targets,
+			      ARRAY_SIZE(xt_connsecmark_targets));
 }
 
 module_init(xt_connsecmark_init);
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 79df816..a1cd972 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -86,44 +86,35 @@ static int checkentry(const char *tablen
 	return 1;
 }
 
-static struct xt_target xt_dscp_reg = {
-	.name		= "DSCP",
-	.target		= target,
-	.targetsize	= sizeof(struct xt_DSCP_info),
-	.table		= "mangle",
-	.checkentry	= checkentry,
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_target xt_dscp6_reg = {
-	.name		= "DSCP",
-	.target		= target6,
-	.targetsize	= sizeof(struct xt_DSCP_info),
-	.table		= "mangle",
-	.checkentry	= checkentry,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_target xt_dscp_target[] = {
+	{
+		.name		= "DSCP",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.target		= target,
+		.targetsize	= sizeof(struct xt_DSCP_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "DSCP",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.target		= target6,
+		.targetsize	= sizeof(struct xt_DSCP_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_dscp_target_init(void)
 {
-	int ret;
-	ret = xt_register_target(&xt_dscp_reg);
-	if (ret)
-		return ret;
-
-	ret = xt_register_target(&xt_dscp6_reg);
-	if (ret)
-		xt_unregister_target(&xt_dscp_reg);
-
-	return ret;
+	return xt_register_targets(xt_dscp_target, ARRAY_SIZE(xt_dscp_target));
 }
 
 static void __exit xt_dscp_target_fini(void)
 {
-	xt_unregister_target(&xt_dscp_reg);
-	xt_unregister_target(&xt_dscp6_reg);
+	xt_unregister_targets(xt_dscp_target, ARRAY_SIZE(xt_dscp_target));
 }
 
 module_init(xt_dscp_target_init);
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index ee9c34e..0a61272 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -112,65 +112,47 @@ checkentry_v1(const char *tablename,
 	return 1;
 }
 
-static struct xt_target ipt_mark_reg_v0 = {
-	.name		= "MARK",
-	.target		= target_v0,
-	.targetsize	= sizeof(struct xt_mark_target_info),
-	.table		= "mangle",
-	.checkentry	= checkentry_v0,
-	.me		= THIS_MODULE,
-	.family		= AF_INET,
-	.revision	= 0,
-};
-
-static struct xt_target ipt_mark_reg_v1 = {
-	.name		= "MARK",
-	.target		= target_v1,
-	.targetsize	= sizeof(struct xt_mark_target_info_v1),
-	.table		= "mangle",
-	.checkentry	= checkentry_v1,
-	.me		= THIS_MODULE,
-	.family		= AF_INET,
-	.revision	= 1,
-};
-
-static struct xt_target ip6t_mark_reg_v0 = {
-	.name		= "MARK",
-	.target		= target_v0,
-	.targetsize	= sizeof(struct xt_mark_target_info),
-	.table		= "mangle",
-	.checkentry	= checkentry_v0,
-	.me		= THIS_MODULE,
-	.family		= AF_INET6,
-	.revision	= 0,
+static struct xt_target xt_mark_target[] = {
+	{
+		.name		= "MARK",
+		.family		= AF_INET,
+		.revision	= 0,
+		.checkentry	= checkentry_v0,
+		.target		= target_v0,
+		.targetsize	= sizeof(struct xt_mark_target_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "MARK",
+		.family		= AF_INET,
+		.revision	= 1,
+		.checkentry	= checkentry_v1,
+		.target		= target_v1,
+		.targetsize	= sizeof(struct xt_mark_target_info_v1),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "MARK",
+		.family		= AF_INET6,
+		.revision	= 0,
+		.checkentry	= checkentry_v0,
+		.target		= target_v0,
+		.targetsize	= sizeof(struct xt_mark_target_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_mark_init(void)
 {
-	int err;
-
-	err = xt_register_target(&ipt_mark_reg_v0);
-	if (err)
-		return err;
-
-	err = xt_register_target(&ipt_mark_reg_v1);
-	if (err)
-		xt_unregister_target(&ipt_mark_reg_v0);
-
-	err = xt_register_target(&ip6t_mark_reg_v0);
-	if (err) {
-		xt_unregister_target(&ipt_mark_reg_v0);
-		xt_unregister_target(&ipt_mark_reg_v1);
-	}
-
-	return err;
+	return xt_register_targets(xt_mark_target, ARRAY_SIZE(xt_mark_target));
 }
 
 static void __exit xt_mark_fini(void)
 {
-	xt_unregister_target(&ipt_mark_reg_v0);
-	xt_unregister_target(&ipt_mark_reg_v1);
-	xt_unregister_target(&ip6t_mark_reg_v0);
+	xt_unregister_targets(xt_mark_target, ARRAY_SIZE(xt_mark_target));
 }
 
 module_init(xt_mark_init);
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 86ccceb..7b98228 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -37,57 +37,39 @@ target(struct sk_buff **pskb,
 	return NF_QUEUE_NR(tinfo->queuenum);
 }
 
-static struct xt_target ipt_NFQ_reg = {
-	.name		= "NFQUEUE",
-	.target		= target,
-	.targetsize	= sizeof(struct xt_NFQ_info),
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_target ip6t_NFQ_reg = {
-	.name		= "NFQUEUE",
-	.target		= target,
-	.targetsize	= sizeof(struct xt_NFQ_info),
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_target arpt_NFQ_reg = {
-	.name		= "NFQUEUE",
-	.target		= target,
-	.targetsize	= sizeof(struct xt_NFQ_info),
-	.family		= NF_ARP,
-	.me		= THIS_MODULE,
+static struct xt_target xt_nfqueue_target[] = {
+	{
+		.name		= "NFQUEUE",
+		.family		= AF_INET,
+		.target		= target,
+		.targetsize	= sizeof(struct xt_NFQ_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "NFQUEUE",
+		.family		= AF_INET6,
+		.target		= target,
+		.targetsize	= sizeof(struct xt_NFQ_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "NFQUEUE",
+		.family		= NF_ARP,
+		.target		= target,
+		.targetsize	= sizeof(struct xt_NFQ_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_nfqueue_init(void)
 {
-	int ret;
-	ret = xt_register_target(&ipt_NFQ_reg);
-	if (ret)
-		return ret;
-	ret = xt_register_target(&ip6t_NFQ_reg);
-	if (ret)
-		goto out_ip;
-	ret = xt_register_target(&arpt_NFQ_reg);
-	if (ret)
-		goto out_ip6;
-
-	return ret;
-out_ip6:
-	xt_unregister_target(&ip6t_NFQ_reg);
-out_ip:
-	xt_unregister_target(&ipt_NFQ_reg);
-
-	return ret;
+	return xt_register_targets(xt_nfqueue_target,
+				   ARRAY_SIZE(xt_nfqueue_target));
 }
 
 static void __exit xt_nfqueue_fini(void)
 {
-	xt_unregister_target(&arpt_NFQ_reg);
-	xt_unregister_target(&ip6t_NFQ_reg);
-	xt_unregister_target(&ipt_NFQ_reg);
+	xt_register_targets(xt_nfqueue_target, ARRAY_SIZE(xt_nfqueue_target));
 }
 
 module_init(xt_nfqueue_init);
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index 98f4b53..cab881d 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -34,43 +34,32 @@ target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static struct xt_target notrack_reg = {
-	.name		= "NOTRACK",
-	.target		= target,
-	.targetsize	= 0,
-	.table		= "raw",
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_target notrack6_reg = {
-	.name		= "NOTRACK",
-	.target		= target,
-	.targetsize	= 0,
-	.table		= "raw",
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_target xt_notrack_target[] = {
+	{
+		.name		= "NOTRACK",
+		.family		= AF_INET,
+		.target		= target,
+		.table		= "raw",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "NOTRACK",
+		.family		= AF_INET6,
+		.target		= target,
+		.table		= "raw",
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_notrack_init(void)
 {
-	int ret;
-
-	ret = xt_register_target(&notrack_reg);
-	if (ret)
-		return ret;
-
-	ret = xt_register_target(&notrack6_reg);
-	if (ret)
-		xt_unregister_target(&notrack_reg);
-
-	return ret;
+	return xt_register_targets(xt_notrack_target,
+				   ARRAY_SIZE(xt_notrack_target));
 }
 
 static void __exit xt_notrack_fini(void)
 {
-	xt_unregister_target(&notrack6_reg);
-	xt_unregister_target(&notrack_reg);
+	xt_unregister_targets(xt_notrack_target, ARRAY_SIZE(xt_notrack_target));
 }
 
 module_init(xt_notrack_init);
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index de9537a..4300988 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -111,47 +111,36 @@ static int checkentry(const char *tablen
 	return 1;
 }
 
-static struct xt_target ipt_secmark_reg = {
-	.name		= "SECMARK",
-	.target		= target,
-	.targetsize	= sizeof(struct xt_secmark_target_info),
-	.table		= "mangle",
-	.checkentry	= checkentry,
-	.me		= THIS_MODULE,
-	.family		= AF_INET,
-	.revision	= 0,
-};
-
-static struct xt_target ip6t_secmark_reg = {
-	.name		= "SECMARK",
-	.target		= target,
-	.targetsize	= sizeof(struct xt_secmark_target_info),
-	.table		= "mangle",
-	.checkentry	= checkentry,
-	.me		= THIS_MODULE,
-	.family		= AF_INET6,
-	.revision	= 0,
+static struct xt_target xt_secmark_target = {
+	{
+		.name		= "SECMARK",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.target		= target,
+		.targetsize	= sizeof(struct xt_secmark_target_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "SECMARK",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.target		= target,
+		.targetsize	= sizeof(struct xt_secmark_target_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_secmark_init(void)
 {
-	int err;
-
-	err = xt_register_target(&ipt_secmark_reg);
-	if (err)
-		return err;
-
-	err = xt_register_target(&ip6t_secmark_reg);
-	if (err)
-		xt_unregister_target(&ipt_secmark_reg);
-
-	return err;
+	return xt_register_targets(xt_secmark_target,
+				   ARRAY_SIZE(xt_secmark_target));
 }
 
 static void __exit xt_secmark_fini(void)
 {
-	xt_unregister_target(&ip6t_secmark_reg);
-	xt_unregister_target(&ipt_secmark_reg);
+	xt_unregister_targets(xt_secmark_target, ARRAY_SIZE(xt_secmark_target));
 }
 
 module_init(xt_secmark_init);
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index 197609c..7db492d 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -29,41 +29,32 @@ match(const struct sk_buff *skb,
 	return 1;
 }
 
-static struct xt_match comment_match = {
-	.name		= "comment",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_comment_info),
-	.family		= AF_INET,
-	.me		= THIS_MODULE
-};
-
-static struct xt_match comment6_match = {
-	.name		= "comment",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_comment_info),
-	.family		= AF_INET6,
-	.me		= THIS_MODULE
+static struct xt_match xt_comment_match[] = {
+	{
+		.name		= "comment",
+		.family		= AF_INET,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_comment_info),
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "comment",
+		.family		= AF_INET6,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_comment_info),
+		.me		= THIS_MODULE
+	},
 };
 
 static int __init xt_comment_init(void)
 {
-	int ret;
-
-	ret = xt_register_match(&comment_match);
-	if (ret)
-		return ret;
-
-	ret = xt_register_match(&comment6_match);
-	if (ret)
-		xt_unregister_match(&comment_match);
-
-	return ret;
+	return xt_register_matches(xt_comment_match,
+				   ARRAY_SIZE(xt_comment_match));
 }
 
 static void __exit xt_comment_fini(void)
 {
-	xt_unregister_match(&comment_match);
-	xt_unregister_match(&comment6_match);
+	xt_unregister_matches(xt_comment_match, ARRAY_SIZE(xt_comment_match));
 }
 
 module_init(xt_comment_init);
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 1396fe2..2d49948 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -143,40 +143,35 @@ static int check(const char *tablename,
 	return 1;
 }
 
-static struct xt_match connbytes_match = {
-	.name		= "connbytes",
-	.match		= match,
-	.checkentry	= check,
-	.matchsize	= sizeof(struct xt_connbytes_info),
-	.family		= AF_INET,
-	.me		= THIS_MODULE
-};
-static struct xt_match connbytes6_match = {
-	.name		= "connbytes",
-	.match		= match,
-	.checkentry	= check,
-	.matchsize	= sizeof(struct xt_connbytes_info),
-	.family		= AF_INET6,
-	.me		= THIS_MODULE
+static struct xt_match xt_connbytes_match = {
+	{
+		.name		= "connbytes",
+		.family		= AF_INET,
+		.checkentry	= check,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_connbytes_info),
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "connbytes",
+		.family		= AF_INET6,
+		.checkentry	= check,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_connbytes_info),
+		.me		= THIS_MODULE
+	},
 };
 
 static int __init xt_connbytes_init(void)
 {
-	int ret;
-	ret = xt_register_match(&connbytes_match);
-	if (ret)
-		return ret;
-
-	ret = xt_register_match(&connbytes6_match);
-	if (ret)
-		xt_unregister_match(&connbytes_match);
-	return ret;
+	return xt_register_matches(xt_connbytes_match,
+				   ARRAY_SIZE(xt_connbytes_match));
 }
 
 static void __exit xt_connbytes_fini(void)
 {
-	xt_unregister_match(&connbytes_match);
-	xt_unregister_match(&connbytes6_match);
+	xt_unregister_matches(xt_connbytes_match,
+			      ARRAY_SIZE(xt_connbytes_match));
 }
 
 module_init(xt_connbytes_init);
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 56324c8..a97b2d4 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -82,46 +82,37 @@ #if defined(CONFIG_NF_CONNTRACK) || defi
 #endif
 }
 
-static struct xt_match connmark_match = {
-	.name		= "connmark",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_connmark_info),
-	.checkentry	= checkentry,
-	.destroy	= destroy,
-	.family		= AF_INET,
-	.me		= THIS_MODULE
-};
-
-static struct xt_match connmark6_match = {
-	.name		= "connmark",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_connmark_info),
-	.checkentry	= checkentry,
-	.destroy	= destroy,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE
+static struct xt_match xt_connmark_match[] = {
+	{
+		.name		= "connmark",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.match		= match,
+		.destroy	= destroy,
+		.matchsize	= sizeof(struct xt_connmark_info),
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "connmark",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.match		= match,
+		.destroy	= destroy,
+		.matchsize	= sizeof(struct xt_connmark_info),
+		.me		= THIS_MODULE
+	},
 };
 
 static int __init xt_connmark_init(void)
 {
-	int ret;
-
 	need_conntrack();
-
-	ret = xt_register_match(&connmark_match);
-	if (ret)
-		return ret;
-
-	ret = xt_register_match(&connmark6_match);
-	if (ret)
-		xt_unregister_match(&connmark_match);
-	return ret;
+	return xt_register_matches(xt_connmark_match,
+				   ARRAY_SIZE(xt_connmark_match));
 }
 
 static void __exit xt_connmark_fini(void)
 {
-	xt_unregister_match(&connmark6_match);
-	xt_unregister_match(&connmark_match);
+	xt_register_matches(xt_connmark_match, ARRAY_SIZE(xt_connmark_match));
 }
 
 module_init(xt_connmark_init);
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 145489a..1540885 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -241,11 +241,8 @@ static struct xt_match conntrack_match =
 
 static int __init xt_conntrack_init(void)
 {
-	int ret;
 	need_conntrack();
-	ret = xt_register_match(&conntrack_match);
-
-	return ret;
+	return xt_register_match(&conntrack_match);
 }
 
 static void __exit xt_conntrack_fini(void)
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 2e2f825..42d4e96 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -141,27 +141,26 @@ checkentry(const char *tablename,
 		&& !(info->invflags & ~info->flags);
 }
 
-static struct xt_match dccp_match = 
-{ 
-	.name 		= "dccp",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_dccp_info),
-	.proto		= IPPROTO_DCCP,
-	.checkentry	= checkentry,
-	.family		= AF_INET,
-	.me 		= THIS_MODULE,
+static struct xt_match xt_dccp_match[] = {
+	{
+		.name 		= "dccp",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_dccp_info),
+		.proto		= IPPROTO_DCCP,
+		.me 		= THIS_MODULE,
+	},
+	{
+		.name 		= "dccp",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_dccp_info),
+		.proto		= IPPROTO_DCCP,
+		.me 		= THIS_MODULE,
+	},
 };
-static struct xt_match dccp6_match = 
-{ 
-	.name 		= "dccp",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_dccp_info),
-	.proto		= IPPROTO_DCCP,
-	.checkentry	= checkentry,
-	.family		= AF_INET6,
-	.me 		= THIS_MODULE,
-};
-
 
 static int __init xt_dccp_init(void)
 {
@@ -173,27 +172,19 @@ static int __init xt_dccp_init(void)
 	dccp_optbuf = kmalloc(256 * 4, GFP_KERNEL);
 	if (!dccp_optbuf)
 		return -ENOMEM;
-	ret = xt_register_match(&dccp_match);
+	ret = xt_register_matches(xt_dccp_match, ARRAY_SIZE(xt_dccp_match));
 	if (ret)
 		goto out_kfree;
-	ret = xt_register_match(&dccp6_match);
-	if (ret)
-		goto out_unreg;
-
 	return ret;
 
-out_unreg:
-	xt_unregister_match(&dccp_match);
 out_kfree:
 	kfree(dccp_optbuf);
-
 	return ret;
 }
 
 static void __exit xt_dccp_fini(void)
 {
-	xt_unregister_match(&dccp6_match);
-	xt_unregister_match(&dccp_match);
+	xt_unregister_matches(xt_dccp_match, ARRAY_SIZE(xt_dccp_match));
 	kfree(dccp_optbuf);
 }
 
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 82e250d..d84075c 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -71,42 +71,33 @@ static int checkentry(const char *tablen
 	return 1;
 }
 
-static struct xt_match dscp_match = {
-	.name		= "dscp",
-	.match		= match,
-	.checkentry	= checkentry,
-	.matchsize	= sizeof(struct xt_dscp_info),
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match dscp6_match = {
-	.name		= "dscp",
-	.match		= match6,
-	.checkentry	= checkentry,
-	.matchsize	= sizeof(struct xt_dscp_info),
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_dscp_match[] = {
+	{
+		.name		= "dscp",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_dscp_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "dscp",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.match		= match6,
+		.matchsize	= sizeof(struct xt_dscp_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_dscp_match_init(void)
 {
-	int ret;
-	ret = xt_register_match(&dscp_match);
-	if (ret)
-		return ret;
-
-	ret = xt_register_match(&dscp6_match);
-	if (ret)
-		xt_unregister_match(&dscp_match);
-
-	return ret;
+	return xt_register_matches(xt_dscp_match, ARRAY_SIZE(xt_dscp_match));
 }
 
 static void __exit xt_dscp_match_fini(void)
 {
-	xt_unregister_match(&dscp_match);
-	xt_unregister_match(&dscp6_match);
+	xt_unregister_matches(xt_dscp_match, ARRAY_SIZE(xt_dscp_match));
 }
 
 module_init(xt_dscp_match_init);
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 9dad628..7b19bc9 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -92,44 +92,35 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct xt_match esp_match = {
-	.name		= "esp",
-	.family		= AF_INET,
-	.proto		= IPPROTO_ESP,
-	.match		= &match,
-	.matchsize	= sizeof(struct xt_esp),
-	.checkentry	= &checkentry,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match esp6_match = {
-	.name		= "esp",
-	.family		= AF_INET6,
-	.proto		= IPPROTO_ESP,
-	.match		= &match,
-	.matchsize	= sizeof(struct xt_esp),
-	.checkentry	= &checkentry,
-	.me		= THIS_MODULE,
+static struct xt_match xt_esp_match[] = {
+	{
+		.name		= "esp",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_esp),
+		.proto		= IPPROTO_ESP,
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "esp",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_esp),
+		.proto		= IPPROTO_ESP,
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_esp_init(void)
 {
-	int ret;
-	ret = xt_register_match(&esp_match);
-	if (ret)
-		return ret;
-
-	ret = xt_register_match(&esp6_match);
-	if (ret)
-		xt_unregister_match(&esp_match);
-
-	return ret;
+	return xt_register_matches(xt_esp_match, ARRAY_SIZE(xt_esp_match));
 }
 
 static void __exit xt_esp_cleanup(void)
 {
-	xt_unregister_match(&esp_match);
-	xt_unregister_match(&esp6_match);
+	xt_unregister_matches(xt_esp_match, ARRAY_SIZE(xt_esp_match));
 }
 
 module_init(xt_esp_init);
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 799c2a4..db453a7 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -163,45 +163,37 @@ #if defined(CONFIG_NF_CONNTRACK) || defi
 #endif
 }
 
-static struct xt_match helper_match = {
-	.name		= "helper",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_helper_info),
-	.checkentry	= check,
-	.destroy	= destroy,
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-static struct xt_match helper6_match = {
-	.name		= "helper",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_helper_info),
-	.checkentry	= check,
-	.destroy	= destroy,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_helper_match[] = {
+	{
+		.name		= "helper",
+		.family		= AF_INET,
+		.checkentry	= check,
+		.match		= match,
+		.destroy	= destroy,
+		.matchsize	= sizeof(struct xt_helper_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "helper",
+		.family		= AF_INET6,
+		.checkentry	= check,
+		.match		= match,
+		.destroy	= destroy,
+		.matchsize	= sizeof(struct xt_helper_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_helper_init(void)
 {
-	int ret;
 	need_conntrack();
-
-	ret = xt_register_match(&helper_match);
-	if (ret < 0)
-		return ret;
-
-	ret = xt_register_match(&helper6_match);
-	if (ret < 0)
-		xt_unregister_match(&helper_match);
-
-	return ret;
+	return xt_register_matches(xt_helper_match,
+				   ARRAY_SIZE(xt_helper_match));
 }
 
 static void __exit xt_helper_fini(void)
 {
-	xt_unregister_match(&helper_match);
-	xt_unregister_match(&helper6_match);
+	xt_unregister_matches(xt_helper_match, ARRAY_SIZE(xt_helper_match));
 }
 
 module_init(xt_helper_init);
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 109132c..67fd30d 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -52,39 +52,32 @@ match6(const struct sk_buff *skb,
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
 
-static struct xt_match length_match = {
-	.name		= "length",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_length_info),
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match length6_match = {
-	.name		= "length",
-	.match		= match6,
-	.matchsize	= sizeof(struct xt_length_info),
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_length_match[] = {
+	{
+		.name		= "length",
+		.family		= AF_INET,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_length_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "length",
+		.family		= AF_INET6,
+		.match		= match6,
+		.matchsize	= sizeof(struct xt_length_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_length_init(void)
 {
-	int ret;
-	ret = xt_register_match(&length_match);
-	if (ret)
-		return ret;
-	ret = xt_register_match(&length6_match);
-	if (ret)
-		xt_unregister_match(&length_match);
-
-	return ret;
+	return xt_register_matches(xt_length_match,
+				   ARRAY_SIZE(xt_length_match));
 }
 
 static void __exit xt_length_fini(void)
 {
-	xt_unregister_match(&length_match);
-	xt_unregister_match(&length6_match);
+	xt_unregister_matches(xt_length_match, ARRAY_SIZE(xt_length_match));
 }
 
 module_init(xt_length_init);
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index ce7fdb7..e8d5e7a 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -136,42 +136,33 @@ ipt_limit_checkentry(const char *tablena
 	return 1;
 }
 
-static struct xt_match ipt_limit_reg = {
-	.name		= "limit",
-	.match		= ipt_limit_match,
-	.matchsize	= sizeof(struct xt_rateinfo),
-	.checkentry	= ipt_limit_checkentry,
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-static struct xt_match limit6_reg = {
-	.name		= "limit",
-	.match		= ipt_limit_match,
-	.matchsize	= sizeof(struct xt_rateinfo),
-	.checkentry	= ipt_limit_checkentry,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_limit_match[] = {
+	{
+		.name		= "limit",
+		.family		= AF_INET,
+		.checkentry	= ipt_limit_checkentry,
+		.match		= ipt_limit_match,
+		.matchsize	= sizeof(struct xt_rateinfo),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "limit",
+		.family		= AF_INET6,
+		.checkentry	= ipt_limit_checkentry,
+		.match		= ipt_limit_match,
+		.matchsize	= sizeof(struct xt_rateinfo),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_limit_init(void)
 {
-	int ret;
-	
-	ret = xt_register_match(&ipt_limit_reg);
-	if (ret)
-		return ret;
-	
-	ret = xt_register_match(&limit6_reg);
-	if (ret)
-		xt_unregister_match(&ipt_limit_reg);
-
-	return ret;
+	return xt_register_matches(xt_limit_match, ARRAY_SIZE(xt_limit_match));
 }
 
 static void __exit xt_limit_fini(void)
 {
-	xt_unregister_match(&ipt_limit_reg);
-	xt_unregister_match(&limit6_reg);
+	xt_unregister_matches(xt_limit_match, ARRAY_SIZE(xt_limit_match));
 }
 
 module_init(xt_limit_init);
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 356290f..425fc21 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -43,43 +43,37 @@ match(const struct sk_buff *skb,
 		^ info->invert));
 }
 
-static struct xt_match mac_match = {
-	.name		= "mac",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_mac_info),
-	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN) |
-			  (1 << NF_IP_FORWARD),
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-static struct xt_match mac6_match = {
-	.name		= "mac",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_mac_info),
-	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN) |
-			  (1 << NF_IP_FORWARD),
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_mac_match[] = {
+	{
+		.name		= "mac",
+		.family		= AF_INET,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_mac_info),
+		.hooks		= (1 << NF_IP_PRE_ROUTING) |
+				  (1 << NF_IP_LOCAL_IN) |
+				  (1 << NF_IP_FORWARD),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "mac",
+		.family		= AF_INET6,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_mac_info),
+		.hooks		= (1 << NF_IP_PRE_ROUTING) |
+				  (1 << NF_IP_LOCAL_IN) |
+				  (1 << NF_IP_FORWARD),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_mac_init(void)
 {
-	int ret;
-	ret = xt_register_match(&mac_match);
-	if (ret)
-		return ret;
-
-	ret = xt_register_match(&mac6_match);
-	if (ret)
-		xt_unregister_match(&mac_match);
-
-	return ret;
+	return xt_register_matches(xt_mac_match, ARRAY_SIZE(xt_mac_match));
 }
 
 static void __exit xt_mac_fini(void)
 {
-	xt_unregister_match(&mac_match);
-	xt_unregister_match(&mac6_match);
+	xt_unregister_matches(xt_mac_match, ARRAY_SIZE(xt_mac_match));
 }
 
 module_init(xt_mac_init);
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 876bc57..39f9b07 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -51,42 +51,33 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct xt_match mark_match = {
-	.name		= "mark",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_mark_info),
-	.checkentry	= checkentry,
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match mark6_match = {
-	.name		= "mark",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_mark_info),
-	.checkentry	= checkentry,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_mark_match[] = {
+	{
+		.name		= "mark",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_mark_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "mark",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_mark_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_mark_init(void)
 {
-	int ret;
-	ret = xt_register_match(&mark_match);
-	if (ret)
-		return ret;
-
-	ret = xt_register_match(&mark6_match);
-	if (ret)
-		xt_unregister_match(&mark_match);
-
-	return ret;
+	return xt_register_matches(xt_mark_match, ARRAY_SIZE(xt_mark_match));
 }
 
 static void __exit xt_mark_fini(void)
 {
-	xt_unregister_match(&mark_match);
-	xt_unregister_match(&mark6_match);
+	xt_unregister_matches(xt_mark_match, ARRAY_SIZE(xt_mark_match));
 }
 
 module_init(xt_mark_init);
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 1ff0a25..e74f9bb 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -231,84 +231,55 @@ checkentry6_v1(const char *tablename,
 		     multiinfo->count);
 }
 
-static struct xt_match multiport_match = {
-	.name		= "multiport",
-	.revision	= 0,
-	.matchsize	= sizeof(struct xt_multiport),
-	.match		= &match,
-	.checkentry	= &checkentry,
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match multiport_match_v1 = {
-	.name		= "multiport",
-	.revision	= 1,
-	.matchsize	= sizeof(struct xt_multiport_v1),
-	.match		= &match_v1,
-	.checkentry	= &checkentry_v1,
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match multiport6_match = {
-	.name		= "multiport",
-	.revision	= 0,
-	.matchsize	= sizeof(struct xt_multiport),
-	.match		= &match,
-	.checkentry	= &checkentry6,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match multiport6_match_v1 = {
-	.name		= "multiport",
-	.revision	= 1,
-	.matchsize	= sizeof(struct xt_multiport_v1),
-	.match		= &match_v1,
-	.checkentry	= &checkentry6_v1,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_multiport_match[] = {
+	{
+		.name		= "multiport",
+		.family		= AF_INET,
+		.revision	= 0,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_multiport),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "multiport",
+		.family		= AF_INET,
+		.revision	= 1,
+		.checkentry	= checkentry_v1,
+		.match		= match_v1,
+		.matchsize	= sizeof(struct xt_multiport_v1),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "multiport",
+		.family		= AF_INET6,
+		.revision	= 0,
+		.checkentry	= checkentry6,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_multiport),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "multiport",
+		.family		= AF_INET6,
+		.revision	= 1,
+		.checkentry	= checkentry6_v1,
+		.match		= match_v1,
+		.matchsize	= sizeof(struct xt_multiport_v1),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_multiport_init(void)
 {
-	int ret;
-
-	ret = xt_register_match(&multiport_match);
-	if (ret)
-		goto out;
-
-	ret = xt_register_match(&multiport_match_v1);
-	if (ret)
-		goto out_unreg_multi_v0;
-
-	ret = xt_register_match(&multiport6_match);
-	if (ret)
-		goto out_unreg_multi_v1;
-
-	ret = xt_register_match(&multiport6_match_v1);
-	if (ret)
-		goto out_unreg_multi6_v0;
-
-	return ret;
-
-out_unreg_multi6_v0:
-	xt_unregister_match(&multiport6_match);
-out_unreg_multi_v1:
-	xt_unregister_match(&multiport_match_v1);
-out_unreg_multi_v0:
-	xt_unregister_match(&multiport_match);
-out:
-	return ret;
+	return xt_register_matches(xt_multiport_match,
+				   ARRAY_SIZE(xt_multiport_match));
 }
 
 static void __exit xt_multiport_fini(void)
 {
-	xt_unregister_match(&multiport_match);
-	xt_unregister_match(&multiport_match_v1);
-	xt_unregister_match(&multiport6_match);
-	xt_unregister_match(&multiport6_match_v1);
+	xt_unregister_matches(xt_multiport_match,
+			      ARRAY_SIZE(xt_multiport_match));
 }
 
 module_init(xt_multiport_init);
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index a9f4f6f..b1ff69a 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -131,43 +131,34 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct xt_match physdev_match = {
-	.name		= "physdev",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_physdev_info),
-	.checkentry	= checkentry,
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match physdev6_match = {
-	.name		= "physdev",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_physdev_info),
-	.checkentry	= checkentry,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_physdev_match[] = {
+	{
+		.name		= "physdev",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_physdev_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "physdev",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_physdev_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_physdev_init(void)
 {
-	int ret;
-
-	ret = xt_register_match(&physdev_match);
-	if (ret < 0)
-		return ret;
-
-	ret = xt_register_match(&physdev6_match);
-	if (ret < 0)
-		xt_unregister_match(&physdev_match);
-
-	return ret;
+	return xt_register_matches(xt_physdev_match,
+				   ARRAY_SIZE(xt_physdev_match));
 }
 
 static void __exit xt_physdev_fini(void)
 {
-	xt_unregister_match(&physdev_match);
-	xt_unregister_match(&physdev6_match);
+	xt_unregister_matches(xt_physdev_match, ARRAY_SIZE(xt_physdev_match));
 }
 
 module_init(xt_physdev_init);
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index d2f5320..16e7b08 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -43,40 +43,32 @@ static int match(const struct sk_buff *s
 	return (type == info->pkttype) ^ info->invert;
 }
 
-static struct xt_match pkttype_match = {
-	.name		= "pkttype",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_pkttype_info),
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match pkttype6_match = {
-	.name		= "pkttype",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_pkttype_info),
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_pkttype_match[] = {
+	{
+		.name		= "pkttype",
+		.family		= AF_INET,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_pkttype_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "pkttype",
+		.family		= AF_INET6,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_pkttype_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_pkttype_init(void)
 {
-	int ret;
-	ret = xt_register_match(&pkttype_match);
-	if (ret)
-		return ret;
-
-	ret = xt_register_match(&pkttype6_match);
-	if (ret)
-		xt_unregister_match(&pkttype_match);
-
-	return ret;
+	return xt_register_matches(xt_pkttype_match,
+				   ARRAY_SIZE(xt_pkttype_match));
 }
 
 static void __exit xt_pkttype_fini(void)
 {
-	xt_unregister_match(&pkttype_match);
-	xt_unregister_match(&pkttype6_match);
+	xt_unregister_matches(xt_pkttype_match, ARRAY_SIZE(xt_pkttype_match));
 }
 
 module_init(xt_pkttype_init);
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index ba1ca03..f5639c4 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -165,43 +165,36 @@ static int checkentry(const char *tablen
 	return 1;
 }
 
-static struct xt_match policy_match = {
-	.name		= "policy",
-	.family		= AF_INET,
-	.match		= match,
-	.matchsize	= sizeof(struct xt_policy_info),
-	.checkentry 	= checkentry,
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match policy6_match = {
-	.name		= "policy",
-	.family		= AF_INET6,
-	.match		= match,
-	.matchsize	= sizeof(struct xt_policy_info),
-	.checkentry	= checkentry,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_policy_match[] = {
+	{
+		.name		= "policy",
+		.family		= AF_INET,
+		.checkentry 	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_policy_info),
+		.family		= AF_INET,
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "policy",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_policy_info),
+		.family		= AF_INET6,
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init init(void)
 {
-	int ret;
-
-	ret = xt_register_match(&policy_match);
-	if (ret)
-		return ret;
-	ret = xt_register_match(&policy6_match);
-	if (ret)
-		xt_unregister_match(&policy_match);
-	return ret;
+	return xt_register_matches(xt_policy_match,
+				   ARRAY_SIZE(xt_policy_match));
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(&policy6_match);
-	xt_unregister_match(&policy_match);
+	xt_unregister_matches(xt_policy_match, ARRAY_SIZE(xt_policy_match));
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 4cdba74..cc264cc 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -50,46 +50,33 @@ checkentry(const char *tablename, const 
 	return 1;
 }
 
-static struct xt_match quota_match = {
-	.name		= "quota",
-	.family		= AF_INET,
-	.match		= match,
-	.matchsize	= sizeof(struct xt_quota_info),
-	.checkentry	= checkentry,
-	.me		= THIS_MODULE
-};
-
-static struct xt_match quota_match6 = {
-	.name		= "quota",
-	.family		= AF_INET6,
-	.match		= match,
-	.matchsize	= sizeof(struct xt_quota_info),
-	.checkentry	= checkentry,
-	.me		= THIS_MODULE
+static struct xt_match xt_quota_match[] = {
+	{
+		.name		= "quota",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_quota_info),
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "quota",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_quota_info),
+		.me		= THIS_MODULE
+	},
 };
 
 static int __init xt_quota_init(void)
 {
-	int ret;
-
-	ret = xt_register_match(&quota_match);
-	if (ret)
-		goto err1;
-	ret = xt_register_match(&quota_match6);
-	if (ret)
-		goto err2;
-	return ret;
-
-err2:
-	xt_unregister_match(&quota_match);
-err1:
-	return ret;
+	return xt_register_matches(xt_quota_match, ARRAY_SIZE(xt_quota_match));
 }
 
 static void __exit xt_quota_fini(void)
 {
-	xt_unregister_match(&quota_match6);
-	xt_unregister_match(&quota_match);
+	xt_unregister_matches(xt_quota_match, ARRAY_SIZE(xt_quota_match));
 }
 
 module_init(xt_quota_init);
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 843383e..5628621 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -178,44 +178,35 @@ checkentry(const char *tablename,
 				| SCTP_CHUNK_MATCH_ONLY)));
 }
 
-static struct xt_match sctp_match = {
-	.name		= "sctp",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_sctp_info),
-	.proto		= IPPROTO_SCTP,
-	.checkentry	= checkentry,
-	.family		= AF_INET,
-	.me		= THIS_MODULE
-};
-
-static struct xt_match sctp6_match = {
-	.name		= "sctp",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_sctp_info),
-	.proto		= IPPROTO_SCTP,
-	.checkentry	= checkentry,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE
+static struct xt_match xt_sctp_match[] = {
+	{
+		.name		= "sctp",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_sctp_info),
+		.proto		= IPPROTO_SCTP,
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "sctp",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_sctp_info),
+		.proto		= IPPROTO_SCTP,
+		.me		= THIS_MODULE
+	},
 };
 
 static int __init xt_sctp_init(void)
 {
-	int ret;
-	ret = xt_register_match(&sctp_match);
-	if (ret)
-		return ret;
-
-	ret = xt_register_match(&sctp6_match);
-	if (ret)
-		xt_unregister_match(&sctp_match);
-
-	return ret;
+	return xt_register_matches(xt_sctp_match, ARRAY_SIZE(xt_sctp_match));
 }
 
 static void __exit xt_sctp_fini(void)
 {
-	xt_unregister_match(&sctp6_match);
-	xt_unregister_match(&sctp_match);
+	xt_unregister_matches(xt_sctp_match, ARRAY_SIZE(xt_sctp_match));
 }
 
 module_init(xt_sctp_init);
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index f9e304d..5f9492e 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -69,47 +69,36 @@ #if defined(CONFIG_NF_CONNTRACK) || defi
 #endif
 }
 
-static struct xt_match state_match = {
-	.name		= "state",
-	.match		= match,
-	.checkentry	= check,
-	.destroy	= destroy,
-	.matchsize	= sizeof(struct xt_state_info),
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match state6_match = {
-	.name		= "state",
-	.match		= match,
-	.checkentry	= check,
-	.destroy	= destroy,
-	.matchsize	= sizeof(struct xt_state_info),
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_state_match[] = {
+	{
+		.name		= "state",
+		.family		= AF_INET,
+		.checkentry	= check,
+		.match		= match,
+		.destroy	= destroy,
+		.matchsize	= sizeof(struct xt_state_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "state",
+		.family		= AF_INET6,
+		.checkentry	= check,
+		.match		= match,
+		.destroy	= destroy,
+		.matchsize	= sizeof(struct xt_state_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_state_init(void)
 {
-	int ret;
-
 	need_conntrack();
-
-	ret = xt_register_match(&state_match);
-	if (ret < 0)
-		return ret;
-
-	ret = xt_register_match(&state6_match);
-	if (ret < 0)
-		xt_unregister_match(&state_match);
-
-	return ret;
+	return xt_register_matches(xt_state_match, ARRAY_SIZE(xt_state_match));
 }
 
 static void __exit xt_state_fini(void)
 {
-	xt_unregister_match(&state_match);
-	xt_unregister_match(&state6_match);
+	xt_unregister_matches(xt_state_match, ARRAY_SIZE(xt_state_match));
 }
 
 module_init(xt_state_init);
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index de1037f..5181630 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -66,46 +66,35 @@ checkentry(const char *tablename, const 
 	return 1;
 }
 
-static struct xt_match statistic_match = {
-	.name		= "statistic",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_statistic_info),
-	.checkentry	= checkentry,
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match statistic_match6 = {
-	.name		= "statistic",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_statistic_info),
-	.checkentry	= checkentry,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
+static struct xt_match xt_statistic_match[] = {
+	{
+		.name		= "statistic",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_statistic_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "statistic",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_statistic_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_statistic_init(void)
 {
-	int ret;
-
-	ret = xt_register_match(&statistic_match);
-	if (ret)
-		goto err1;
-
-	ret = xt_register_match(&statistic_match6);
-	if (ret)
-		goto err2;
-	return ret;
-err2:
-	xt_unregister_match(&statistic_match);
-err1:
-	return ret;
+	return xt_register_matches(xt_statistic_match,
+				   ARRAY_SIZE(xt_statistic_match));
 }
 
 static void __exit xt_statistic_fini(void)
 {
-	xt_unregister_match(&statistic_match6);
-	xt_unregister_match(&statistic_match);
+	xt_unregister_matches(xt_statistic_match,
+			      ARRAY_SIZE(xt_statistic_match));
 }
 
 module_init(xt_statistic_init);
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 275330f..1a1c1d1 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -75,43 +75,35 @@ static void destroy(const struct xt_matc
 	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
 }
 
-static struct xt_match string_match = {
-	.name 		= "string",
-	.match 		= match,
-	.matchsize	= sizeof(struct xt_string_info),
-	.checkentry	= checkentry,
-	.destroy 	= destroy,
-	.family		= AF_INET,
-	.me 		= THIS_MODULE
-};
-static struct xt_match string6_match = {
-	.name 		= "string",
-	.match 		= match,
-	.matchsize	= sizeof(struct xt_string_info),
-	.checkentry	= checkentry,
-	.destroy 	= destroy,
-	.family		= AF_INET6,
-	.me 		= THIS_MODULE
+static struct xt_match xt_string_match[] = {
+	{
+		.name 		= "string",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.match 		= match,
+		.destroy 	= destroy,
+		.matchsize	= sizeof(struct xt_string_info),
+		.me 		= THIS_MODULE
+	},
+	{
+		.name 		= "string",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.match 		= match,
+		.destroy 	= destroy,
+		.matchsize	= sizeof(struct xt_string_info),
+		.me 		= THIS_MODULE
+	},
 };
 
 static int __init xt_string_init(void)
 {
-	int ret;
-
-	ret = xt_register_match(&string_match);
-	if (ret)
-		return ret;
-	ret = xt_register_match(&string6_match);
-	if (ret)
-		xt_unregister_match(&string_match);
-
-	return ret;
+	return xt_register_matches(xt_string_match, ARRAY_SIZE(xt_string_match));
 }
 
 static void __exit xt_string_fini(void)
 {
-	xt_unregister_match(&string_match);
-	xt_unregister_match(&string6_match);
+	xt_unregister_matches(xt_string_match, ARRAY_SIZE(xt_string_match));
 }
 
 module_init(xt_string_init);
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index cf7d335..7baa9eb 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -93,43 +93,34 @@ match(const struct sk_buff *skb,
 			       info->invert, hotdrop);
 }
 
-static struct xt_match tcpmss_match = {
-	.name		= "tcpmss",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_tcpmss_match_info),
-	.proto		= IPPROTO_TCP,
-	.family		= AF_INET,
-	.me		= THIS_MODULE,
+static struct xt_match xt_tcpmss_match[] = {
+	{
+		.name		= "tcpmss",
+		.family		= AF_INET,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_tcpmss_match_info),
+		.proto		= IPPROTO_TCP,
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "tcpmss",
+		.family		= AF_INET6,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_tcpmss_match_info),
+		.proto		= IPPROTO_TCP,
+		.me		= THIS_MODULE,
+	},
 };
 
-static struct xt_match tcpmss6_match = {
-	.name		= "tcpmss",
-	.match		= match,
-	.matchsize	= sizeof(struct xt_tcpmss_match_info),
-	.proto		= IPPROTO_TCP,
-	.family		= AF_INET6,
-	.me		= THIS_MODULE,
-};
-
-
 static int __init xt_tcpmss_init(void)
 {
-	int ret;
-	ret = xt_register_match(&tcpmss_match);
-	if (ret)
-		return ret;
-
-	ret = xt_register_match(&tcpmss6_match);
-	if (ret)
-		xt_unregister_match(&tcpmss_match);
-
-	return ret;
+	return xt_register_matches(xt_tcpmss_match,
+				   ARRAY_SIZE(xt_tcpmss_match));
 }
 
 static void __exit xt_tcpmss_fini(void)
 {
-	xt_unregister_match(&tcpmss6_match);
-	xt_unregister_match(&tcpmss_match);
+	xt_unregister_matches(xt_tcpmss_match, ARRAY_SIZE(xt_tcpmss_match));
 }
 
 module_init(xt_tcpmss_init);
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index a9a63aa..54aab05 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -199,81 +199,54 @@ udp_checkentry(const char *tablename,
 	return !(udpinfo->invflags & ~XT_UDP_INV_MASK);
 }
 
-static struct xt_match tcp_matchstruct = {
-	.name		= "tcp",
-	.match		= tcp_match,
-	.matchsize	= sizeof(struct xt_tcp),
-	.proto		= IPPROTO_TCP,
-	.family		= AF_INET,
-	.checkentry	= tcp_checkentry,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match tcp6_matchstruct = {
-	.name		= "tcp",
-	.match		= tcp_match,
-	.matchsize	= sizeof(struct xt_tcp),
-	.proto		= IPPROTO_TCP,
-	.family		= AF_INET6,
-	.checkentry	= tcp_checkentry,
-	.me		= THIS_MODULE,
-};
-
-static struct xt_match udp_matchstruct = {
-	.name		= "udp",
-	.match		= udp_match,
-	.matchsize	= sizeof(struct xt_udp),
-	.proto		= IPPROTO_UDP,
-	.family		= AF_INET,
-	.checkentry	= udp_checkentry,
-	.me		= THIS_MODULE,
-};
-static struct xt_match udp6_matchstruct = {
-	.name		= "udp",
-	.match		= udp_match,
-	.matchsize	= sizeof(struct xt_udp),
-	.proto		= IPPROTO_UDP,
-	.family		= AF_INET6,
-	.checkentry	= udp_checkentry,
-	.me		= THIS_MODULE,
+static struct xt_match xt_tcpudp_match[] = {
+	{
+		.name		= "tcp",
+		.family		= AF_INET,
+		.checkentry	= tcp_checkentry,
+		.match		= tcp_match,
+		.matchsize	= sizeof(struct xt_tcp),
+		.proto		= IPPROTO_TCP,
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "tcp",
+		.family		= AF_INET6,
+		.checkentry	= tcp_checkentry,
+		.match		= tcp_match,
+		.matchsize	= sizeof(struct xt_tcp),
+		.proto		= IPPROTO_TCP,
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "udp",
+		.family		= AF_INET,
+		.checkentry	= udp_checkentry,
+		.match		= udp_match,
+		.matchsize	= sizeof(struct xt_udp),
+		.proto		= IPPROTO_UDP,
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "udp",
+		.family		= AF_INET6,
+		.checkentry	= udp_checkentry,
+		.match		= udp_match,
+		.matchsize	= sizeof(struct xt_udp),
+		.proto		= IPPROTO_UDP,
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init xt_tcpudp_init(void)
 {
-	int ret;
-	ret = xt_register_match(&tcp_matchstruct);
-	if (ret)
-		return ret;
-
-	ret = xt_register_match(&tcp6_matchstruct);
-	if (ret)
-		goto out_unreg_tcp;
-
-	ret = xt_register_match(&udp_matchstruct);
-	if (ret)
-		goto out_unreg_tcp6;
-	
-	ret = xt_register_match(&udp6_matchstruct);
-	if (ret)
-		goto out_unreg_udp;
-
-	return ret;
-
-out_unreg_udp:
-	xt_unregister_match(&udp_matchstruct);
-out_unreg_tcp6:
-	xt_unregister_match(&tcp6_matchstruct);
-out_unreg_tcp:
-	xt_unregister_match(&tcp_matchstruct);
-	return ret;
+	return xt_register_matches(xt_tcpudp_match,
+				   ARRAY_SIZE(xt_tcpudp_match));
 }
 
 static void __exit xt_tcpudp_fini(void)
 {
-	xt_unregister_match(&udp6_matchstruct);
-	xt_unregister_match(&udp_matchstruct);
-	xt_unregister_match(&tcp6_matchstruct);
-	xt_unregister_match(&tcp_matchstruct);
+	xt_unregister_matches(xt_tcpudp_match, ARRAY_SIZE(xt_tcpudp_match));
 }
 
 module_init(xt_tcpudp_init);

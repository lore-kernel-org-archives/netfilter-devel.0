From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/13]: Convert x_tables matches/targets to centralized
	error checking
Date: Thu, 16 Feb 2006 22:32:19 +0100 (MET)
Message-ID: <20060216213219.6933.17454.sendpatchset@localhost.localdomain>
References: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Convert x_tables matches/targets to centralized error checking

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 17605235f23efeda52fa086e6dfa6dccd9ab915e
tree 37e5c5cbcafe0563c9f8deafb425b23c94a61f87
parent dff18dfa6d3b6ad94a5c5b8d185cb37cb6d2af57
author Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:07 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:07 +0100

 net/netfilter/xt_CLASSIFY.c  |   41 +++-------------
 net/netfilter/xt_CONNMARK.c  |   25 ++++------
 net/netfilter/xt_MARK.c      |   33 ++-----------
 net/netfilter/xt_NFQUEUE.c   |   23 +--------
 net/netfilter/xt_NOTRACK.c   |   44 +++++------------
 net/netfilter/xt_comment.c   |   17 +------
 net/netfilter/xt_connbytes.c |   13 ++---
 net/netfilter/xt_connmark.c  |   26 +++++-----
 net/netfilter/xt_conntrack.c |   16 +-----
 net/netfilter/xt_dccp.c      |   43 ++++-------------
 net/netfilter/xt_helper.c    |   15 ++----
 net/netfilter/xt_length.c    |   22 ++-------
 net/netfilter/xt_limit.c     |    5 +-
 net/netfilter/xt_mac.c       |   33 +++----------
 net/netfilter/xt_mark.c      |   14 ++---
 net/netfilter/xt_physdev.c   |   12 ++---
 net/netfilter/xt_pkttype.c   |   22 ++-------
 net/netfilter/xt_realm.c     |   26 ++--------
 net/netfilter/xt_sctp.c      |   64 +++++++------------------
 net/netfilter/xt_state.c     |   20 ++------
 net/netfilter/xt_string.c    |    5 +-
 net/netfilter/xt_tcpmss.c    |   51 ++------------------
 net/netfilter/xt_tcpudp.c    |  108 +++++++++---------------------------------
 23 files changed, 167 insertions(+), 511 deletions(-)

diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 78ee266..6b36e84 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -39,47 +39,22 @@ target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static int
-checkentry(const char *tablename,
-           const void *e,
-           void *targinfo,
-           unsigned int targinfosize,
-           unsigned int hook_mask)
-{
-	if (targinfosize != XT_ALIGN(sizeof(struct xt_classify_target_info))){
-		printk(KERN_ERR "CLASSIFY: invalid size (%u != %Zu).\n",
-		       targinfosize,
-		       XT_ALIGN(sizeof(struct xt_classify_target_info)));
-		return 0;
-	}
-	
-	if (hook_mask & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
-	                  (1 << NF_IP_POST_ROUTING))) {
-		printk(KERN_ERR "CLASSIFY: only valid in LOCAL_OUT, FORWARD "
-		                "and POST_ROUTING.\n");
-		return 0;
-	}
-
-	if (strcmp(tablename, "mangle") != 0) {
-		printk(KERN_ERR "CLASSIFY: can only be called from "
-		                "\"mangle\" table, not \"%s\".\n",
-		                tablename);
-		return 0;
-	}
-
-	return 1;
-}
-
 static struct xt_target classify_reg = { 
 	.name 		= "CLASSIFY", 
 	.target 	= target,
-	.checkentry	= checkentry,
+	.targetsize	= sizeof(struct xt_classify_target_info),
+	.table		= "mangle",
+	.hooks		= (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
+		          (1 << NF_IP_POST_ROUTING),
 	.me 		= THIS_MODULE,
 };
 static struct xt_target classify6_reg = { 
 	.name 		= "CLASSIFY", 
 	.target 	= target,
-	.checkentry	= checkentry,
+	.targetsize	= sizeof(struct xt_classify_target_info),
+	.table		= "mangle",
+	.hooks		= (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
+		          (1 << NF_IP_POST_ROUTING),
 	.me 		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 22506e3..b269ba9 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -79,12 +79,6 @@ checkentry(const char *tablename,
 	   unsigned int hook_mask)
 {
 	struct xt_connmark_target_info *matchinfo = targinfo;
-	if (targinfosize != XT_ALIGN(sizeof(struct xt_connmark_target_info))) {
-		printk(KERN_WARNING "CONNMARK: targinfosize %u != %Zu\n",
-		       targinfosize,
-		       XT_ALIGN(sizeof(struct xt_connmark_target_info)));
-		return 0;
-	}
 
 	if (matchinfo->mode == XT_CONNMARK_RESTORE) {
 	    if (strcmp(tablename, "mangle") != 0) {
@@ -102,16 +96,19 @@ checkentry(const char *tablename,
 }
 
 static struct xt_target connmark_reg = {
-	.name = "CONNMARK",
-	.target = &target,
-	.checkentry = &checkentry,
-	.me = THIS_MODULE
+	.name		= "CONNMARK",
+	.target		= target,
+	.targetsize	= sizeof(struct xt_connmark_target_info),
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE
 };
+
 static struct xt_target connmark6_reg = {
-	.name = "CONNMARK",
-	.target = &target,
-	.checkentry = &checkentry,
-	.me = THIS_MODULE
+	.name		= "CONNMARK",
+	.target		= target,
+	.targetsize	= sizeof(struct xt_connmark_target_info),
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE
 };
 
 static int __init init(void)
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 0c11ee9..1bc968b 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -78,23 +78,10 @@ checkentry_v0(const char *tablename,
 {
 	struct xt_mark_target_info *markinfo = targinfo;
 
-	if (targinfosize != XT_ALIGN(sizeof(struct xt_mark_target_info))) {
-		printk(KERN_WARNING "MARK: targinfosize %u != %Zu\n",
-		       targinfosize,
-		       XT_ALIGN(sizeof(struct xt_mark_target_info)));
-		return 0;
-	}
-
-	if (strcmp(tablename, "mangle") != 0) {
-		printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
-		return 0;
-	}
-
 	if (markinfo->mark > 0xffffffff) {
 		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
 		return 0;
 	}
-
 	return 1;
 }
 
@@ -107,18 +94,6 @@ checkentry_v1(const char *tablename,
 {
 	struct xt_mark_target_info_v1 *markinfo = targinfo;
 
-	if (targinfosize != XT_ALIGN(sizeof(struct xt_mark_target_info_v1))){
-		printk(KERN_WARNING "MARK: targinfosize %u != %Zu\n",
-		       targinfosize,
-		       XT_ALIGN(sizeof(struct xt_mark_target_info_v1)));
-		return 0;
-	}
-
-	if (strcmp(tablename, "mangle") != 0) {
-		printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
-		return 0;
-	}
-
 	if (markinfo->mode != XT_MARK_SET
 	    && markinfo->mode != XT_MARK_AND
 	    && markinfo->mode != XT_MARK_OR) {
@@ -126,18 +101,18 @@ checkentry_v1(const char *tablename,
 		       markinfo->mode);
 		return 0;
 	}
-
 	if (markinfo->mark > 0xffffffff) {
 		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct xt_target ipt_mark_reg_v0 = {
 	.name		= "MARK",
 	.target		= target_v0,
+	.targetsize	= sizeof(struct xt_mark_target_info),
+	.table		= "mangle",
 	.checkentry	= checkentry_v0,
 	.me		= THIS_MODULE,
 	.revision	= 0,
@@ -146,6 +121,8 @@ static struct xt_target ipt_mark_reg_v0 
 static struct xt_target ipt_mark_reg_v1 = {
 	.name		= "MARK",
 	.target		= target_v1,
+	.targetsize	= sizeof(struct xt_mark_target_info_v1),
+	.table		= "mangle",
 	.checkentry	= checkentry_v1,
 	.me		= THIS_MODULE,
 	.revision	= 1,
@@ -154,6 +131,8 @@ static struct xt_target ipt_mark_reg_v1 
 static struct xt_target ip6t_mark_reg_v0 = {
 	.name		= "MARK",
 	.target		= target_v0,
+	.targetsize	= sizeof(struct xt_mark_target_info),
+	.table		= "mangle",
 	.checkentry	= checkentry_v0,
 	.me		= THIS_MODULE,
 	.revision	= 0,
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 8b76b6f..b1da0ad 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -36,41 +36,24 @@ target(struct sk_buff **pskb,
 	return NF_QUEUE_NR(tinfo->queuenum);
 }
 
-static int
-checkentry(const char *tablename,
-	   const void *entry,
-           void *targinfo,
-           unsigned int targinfosize,
-           unsigned int hook_mask)
-{
-	if (targinfosize != XT_ALIGN(sizeof(struct xt_NFQ_info))) {
-		printk(KERN_WARNING "NFQUEUE: targinfosize %u != %Zu\n",
-		       targinfosize,
-		       XT_ALIGN(sizeof(struct xt_NFQ_info)));
-		return 0;
-	}
-
-	return 1;
-}
-
 static struct xt_target ipt_NFQ_reg = {
 	.name		= "NFQUEUE",
 	.target		= target,
-	.checkentry	= checkentry,
+	.targetsize	= sizeof(struct xt_NFQ_info),
 	.me		= THIS_MODULE,
 };
 
 static struct xt_target ip6t_NFQ_reg = {
 	.name		= "NFQUEUE",
 	.target		= target,
-	.checkentry	= checkentry,
+	.targetsize	= sizeof(struct xt_NFQ_info),
 	.me		= THIS_MODULE,
 };
 
 static struct xt_target arpt_NFQ_reg = {
 	.name		= "NFQUEUE",
 	.target		= target,
-	.checkentry	= checkentry,
+	.targetsize	= sizeof(struct xt_NFQ_info),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index 24d477a..8bacbe1 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -33,38 +33,20 @@ target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static int
-checkentry(const char *tablename,
-	   const void *entry,
-           void *targinfo,
-           unsigned int targinfosize,
-           unsigned int hook_mask)
-{
-	if (targinfosize != 0) {
-		printk(KERN_WARNING "NOTRACK: targinfosize %u != 0\n",
-		       targinfosize);
-		return 0;
-	}
-
-	if (strcmp(tablename, "raw") != 0) {
-		printk(KERN_WARNING "NOTRACK: can only be called from \"raw\" table, not \"%s\"\n", tablename);
-		return 0;
-	}
-
-	return 1;
-}
-
-static struct xt_target notrack_reg = { 
-	.name = "NOTRACK", 
-	.target = target, 
-	.checkentry = checkentry,
-	.me = THIS_MODULE,
+static struct xt_target notrack_reg = {
+	.name		= "NOTRACK",
+	.target		= target,
+	.targetsize	= 0,
+	.table		= "raw",
+	.me		= THIS_MODULE,
 };
-static struct xt_target notrack6_reg = { 
-	.name = "NOTRACK", 
-	.target = target, 
-	.checkentry = checkentry,
-	.me = THIS_MODULE,
+
+static struct xt_target notrack6_reg = {
+	.name		= "NOTRACK",
+	.target		= target,
+	.targetsize	= 0,
+	.table		= "raw",
+	.me		= THIS_MODULE,
 };
 
 static int __init init(void)
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index 4ba6fd6..b3f07aa 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -28,30 +28,17 @@ match(const struct sk_buff *skb,
 	return 1;
 }
 
-static int
-checkentry(const char *tablename,
-           const void *ip,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
-{
-	/* Check the size */
-	if (matchsize != XT_ALIGN(sizeof(struct xt_comment_info)))
-		return 0;
-	return 1;
-}
-
 static struct xt_match comment_match = {
 	.name		= "comment",
 	.match		= match,
-	.checkentry	= checkentry,
+	.matchsize	= sizeof(struct xt_comment_info),
 	.me		= THIS_MODULE
 };
 
 static struct xt_match comment6_match = {
 	.name		= "comment",
 	.match		= match,
-	.checkentry	= checkentry,
+	.matchsize	= sizeof(struct xt_comment_info),
 	.me		= THIS_MODULE
 };
 
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 150d2a4..d985135 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -128,9 +128,6 @@ static int check(const char *tablename,
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
 
-	if (matchsize != XT_ALIGN(sizeof(struct xt_connbytes_info)))
-		return 0;
-
 	if (sinfo->what != XT_CONNBYTES_PKTS &&
 	    sinfo->what != XT_CONNBYTES_BYTES &&
 	    sinfo->what != XT_CONNBYTES_AVGPKT)
@@ -146,14 +143,16 @@ static int check(const char *tablename,
 
 static struct xt_match connbytes_match = {
 	.name		= "connbytes",
-	.match		= &match,
-	.checkentry	= &check,
+	.match		= match,
+	.checkentry	= check,
+	.matchsize	= sizeof(struct xt_connbytes_info),
 	.me		= THIS_MODULE
 };
 static struct xt_match connbytes6_match = {
 	.name		= "connbytes",
-	.match		= &match,
-	.checkentry	= &check,
+	.match		= match,
+	.checkentry	= check,
+	.matchsize	= sizeof(struct xt_connbytes_info),
 	.me		= THIS_MODULE
 };
 
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index d06e925..2bb987f 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -56,33 +56,31 @@ checkentry(const char *tablename,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
-	struct xt_connmark_info *cm = 
-				(struct xt_connmark_info *)matchinfo;
-	if (matchsize != XT_ALIGN(sizeof(struct xt_connmark_info)))
-		return 0;
+	struct xt_connmark_info *cm = (struct xt_connmark_info *)matchinfo;
 
 	if (cm->mark > 0xffffffff || cm->mask > 0xffffffff) {
 		printk(KERN_WARNING "connmark: only support 32bit mark\n");
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct xt_match connmark_match = {
-	.name = "connmark",
-	.match = &match,
-	.checkentry = &checkentry,
-	.me = THIS_MODULE
+	.name		= "connmark",
+	.match		= match,
+	.matchsize	= sizeof(struct xt_connmark_info),
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE
 };
+
 static struct xt_match connmark6_match = {
-	.name = "connmark",
-	.match = &match,
-	.checkentry = &checkentry,
-	.me = THIS_MODULE
+	.name		= "connmark",
+	.match		= match,
+	.matchsize	= sizeof(struct xt_connmark_info),
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE
 };
 
-
 static int __init init(void)
 {
 	int ret;
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index ffdebc9..45a5a7d 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -201,22 +201,10 @@ match(const struct sk_buff *skb,
 
 #endif /* CONFIG_NF_IP_CONNTRACK */
 
-static int check(const char *tablename,
-		 const void *ip,
-		 void *matchinfo,
-		 unsigned int matchsize,
-		 unsigned int hook_mask)
-{
-	if (matchsize != XT_ALIGN(sizeof(struct xt_conntrack_info)))
-		return 0;
-
-	return 1;
-}
-
 static struct xt_match conntrack_match = {
 	.name		= "conntrack",
-	.match		= &match,
-	.checkentry	= &check,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_conntrack_info),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 779f42f..06e9ef2 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -133,52 +133,29 @@ checkentry(const char *tablename,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
-	const struct ipt_ip *ip = inf;
-	const struct xt_dccp_info *info;
+	const struct xt_dccp_info *info = matchinfo;
 
-	info = (const struct xt_dccp_info *)matchinfo;
-
-	return ip->proto == IPPROTO_DCCP
-		&& !(ip->invflags & XT_INV_PROTO)
-		&& matchsize == XT_ALIGN(sizeof(struct xt_dccp_info))
-		&& !(info->flags & ~XT_DCCP_VALID_FLAGS)
+	return !(info->flags & ~XT_DCCP_VALID_FLAGS)
 		&& !(info->invflags & ~XT_DCCP_VALID_FLAGS)
 		&& !(info->invflags & ~info->flags);
 }
 
-static int
-checkentry6(const char *tablename,
-	   const void *inf,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
-{
-	const struct ip6t_ip6 *ip = inf;
-	const struct xt_dccp_info *info;
-
-	info = (const struct xt_dccp_info *)matchinfo;
-
-	return ip->proto == IPPROTO_DCCP
-		&& !(ip->invflags & XT_INV_PROTO)
-		&& matchsize == XT_ALIGN(sizeof(struct xt_dccp_info))
-		&& !(info->flags & ~XT_DCCP_VALID_FLAGS)
-		&& !(info->invflags & ~XT_DCCP_VALID_FLAGS)
-		&& !(info->invflags & ~info->flags);
-}
-
-
 static struct xt_match dccp_match = 
 { 
 	.name 		= "dccp",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_dccp_info),
+	.proto		= IPPROTO_DCCP,
+	.checkentry	= checkentry,
 	.me 		= THIS_MODULE,
 };
 static struct xt_match dccp6_match = 
 { 
 	.name 		= "dccp",
-	.match		= &match,
-	.checkentry	= &checkentry6,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_dccp_info),
+	.proto		= IPPROTO_DCCP,
+	.checkentry	= checkentry,
 	.me 		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index c451169..70bc00f 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -142,24 +142,21 @@ static int check(const char *tablename,
 	struct xt_helper_info *info = matchinfo;
 
 	info->name[29] = '\0';
-
-	/* verify size */
-	if (matchsize != XT_ALIGN(sizeof(struct xt_helper_info)))
-		return 0;
-
 	return 1;
 }
 
 static struct xt_match helper_match = {
 	.name		= "helper",
-	.match		= &match,
-	.checkentry	= &check,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_helper_info),
+	.checkentry	= check,
 	.me		= THIS_MODULE,
 };
 static struct xt_match helper6_match = {
 	.name		= "helper",
-	.match		= &match,
-	.checkentry	= &check,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_helper_info),
+	.checkentry	= check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 39c8fae..11a2812 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -50,29 +50,17 @@ match6(const struct sk_buff *skb,
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
 
-static int
-checkentry(const char *tablename,
-           const void *ip,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
-{
-	if (matchsize != XT_ALIGN(sizeof(struct xt_length_info)))
-		return 0;
-
-	return 1;
-}
-
 static struct xt_match length_match = {
 	.name		= "length",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_length_info),
 	.me		= THIS_MODULE,
 };
+
 static struct xt_match length6_match = {
 	.name		= "length",
-	.match		= &match6,
-	.checkentry	= &checkentry,
+	.match		= match6,
+	.matchsize	= sizeof(struct xt_length_info),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 15e4050..dec3f02 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -113,9 +113,6 @@ ipt_limit_checkentry(const char *tablena
 {
 	struct xt_rateinfo *r = matchinfo;
 
-	if (matchsize != XT_ALIGN(sizeof(struct xt_rateinfo)))
-		return 0;
-
 	/* Check for overflow. */
 	if (r->burst == 0
 	    || user2credits(r->avg * r->burst) < user2credits(r->avg)) {
@@ -140,12 +137,14 @@ ipt_limit_checkentry(const char *tablena
 static struct xt_match ipt_limit_reg = {
 	.name		= "limit",
 	.match		= ipt_limit_match,
+	.matchsize	= sizeof(struct xt_rateinfo),
 	.checkentry	= ipt_limit_checkentry,
 	.me		= THIS_MODULE,
 };
 static struct xt_match limit6_reg = {
 	.name		= "limit",
 	.match		= ipt_limit_match,
+	.matchsize	= sizeof(struct xt_rateinfo),
 	.checkentry	= ipt_limit_checkentry,
 	.me		= THIS_MODULE,
 };
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 0461dcb..e207726 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -42,37 +42,20 @@ match(const struct sk_buff *skb,
 		^ info->invert));
 }
 
-static int
-ipt_mac_checkentry(const char *tablename,
-		   const void *inf,
-		   void *matchinfo,
-		   unsigned int matchsize,
-		   unsigned int hook_mask)
-{
-	/* FORWARD isn't always valid, but it's nice to be able to do --RR */
-	if (hook_mask
-	    & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN)
-		| (1 << NF_IP_FORWARD))) {
-		printk("xt_mac: only valid for PRE_ROUTING, LOCAL_IN or FORWARD.\n");
-		return 0;
-	}
-
-	if (matchsize != XT_ALIGN(sizeof(struct xt_mac_info)))
-		return 0;
-
-	return 1;
-}
-
 static struct xt_match mac_match = {
 	.name		= "mac",
-	.match		= &match,
-	.checkentry	= &ipt_mac_checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_mac_info),
+	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN) |
+			  (1 << NF_IP_FORWARD),
 	.me		= THIS_MODULE,
 };
 static struct xt_match mac6_match = {
 	.name		= "mac",
-	.match		= &match,
-	.checkentry	= &ipt_mac_checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_mac_info),
+	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN) |
+			  (1 << NF_IP_FORWARD),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 2a0ac62..b21b94a 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -42,28 +42,26 @@ checkentry(const char *tablename,
 {
 	struct xt_mark_info *minfo = (struct xt_mark_info *) matchinfo;
 
-	if (matchsize != XT_ALIGN(sizeof(struct xt_mark_info)))
-		return 0;
-
 	if (minfo->mark > 0xffffffff || minfo->mask > 0xffffffff) {
 		printk(KERN_WARNING "mark: only supports 32bit mark\n");
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct xt_match mark_match = {
 	.name		= "mark",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_mark_info),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
 static struct xt_match mark6_match = {
 	.name		= "mark",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_mark_info),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 19bb57c..5afc417 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -108,8 +108,6 @@ checkentry(const char *tablename,
 {
 	const struct xt_physdev_info *info = matchinfo;
 
-	if (matchsize != XT_ALIGN(sizeof(struct xt_physdev_info)))
-		return 0;
 	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
 	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
 		return 0;
@@ -118,15 +116,17 @@ checkentry(const char *tablename,
 
 static struct xt_match physdev_match = {
 	.name		= "physdev",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_physdev_info),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
 static struct xt_match physdev6_match = {
 	.name		= "physdev",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_physdev_info),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index ab1b263..872bb2a 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -32,32 +32,20 @@ static int match(const struct sk_buff *s
 	return (skb->pkt_type == info->pkttype) ^ info->invert;
 }
 
-static int checkentry(const char *tablename,
-		   const void *ip,
-		   void *matchinfo,
-		   unsigned int matchsize,
-		   unsigned int hook_mask)
-{
-	if (matchsize != XT_ALIGN(sizeof(struct xt_pkttype_info)))
-		return 0;
-
-	return 1;
-}
-
 static struct xt_match pkttype_match = {
 	.name		= "pkttype",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_pkttype_info),
 	.me		= THIS_MODULE,
 };
+
 static struct xt_match pkttype6_match = {
 	.name		= "pkttype",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_pkttype_info),
 	.me		= THIS_MODULE,
 };
 
-
 static int __init init(void)
 {
 	int ret;
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 2b7e178..249e0a3 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -38,30 +38,12 @@ match(const struct sk_buff *skb,
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
 }
 
-static int check(const char *tablename,
-                 const void *ip,
-                 void *matchinfo,
-                 unsigned int matchsize,
-                 unsigned int hook_mask)
-{
-	if (hook_mask
-	    & ~((1 << NF_IP_POST_ROUTING) | (1 << NF_IP_FORWARD) |
-	        (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_LOCAL_IN))) {
-		printk("xt_realm: only valid for POST_ROUTING, LOCAL_OUT, "
-		       "LOCAL_IN or FORWARD.\n");
-		return 0;
-	}
-	if (matchsize != XT_ALIGN(sizeof(struct xt_realm_info))) {
-		printk("xt_realm: invalid matchsize.\n");
-		return 0;
-	}
-	return 1;
-}
-
 static struct xt_match realm_match = {
 	.name		= "realm",
-	.match		= match, 
-	.checkentry	= check,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_realm_info),
+	.hooks		= (1 << NF_IP_POST_ROUTING) | (1 << NF_IP_FORWARD) |
+			  (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_LOCAL_IN),
 	.me		= THIS_MODULE
 };
 
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 10fbfc5..f0a25e5 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -166,40 +166,9 @@ checkentry(const char *tablename,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
-	const struct xt_sctp_info *info;
-	const struct ipt_ip *ip = inf;
+	const struct xt_sctp_info *info = matchinfo;
 
-	info = (const struct xt_sctp_info *)matchinfo;
-
-	return ip->proto == IPPROTO_SCTP
-		&& !(ip->invflags & XT_INV_PROTO)
-		&& matchsize == XT_ALIGN(sizeof(struct xt_sctp_info))
-		&& !(info->flags & ~XT_SCTP_VALID_FLAGS)
-		&& !(info->invflags & ~XT_SCTP_VALID_FLAGS)
-		&& !(info->invflags & ~info->flags)
-		&& ((!(info->flags & XT_SCTP_CHUNK_TYPES)) || 
-			(info->chunk_match_type &
-				(SCTP_CHUNK_MATCH_ALL 
-				| SCTP_CHUNK_MATCH_ANY
-				| SCTP_CHUNK_MATCH_ONLY)));
-}
-
-static int
-checkentry6(const char *tablename,
-	   const void *inf,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
-{
-	const struct xt_sctp_info *info;
-	const struct ip6t_ip6 *ip = inf;
-
-	info = (const struct xt_sctp_info *)matchinfo;
-
-	return ip->proto == IPPROTO_SCTP
-		&& !(ip->invflags & XT_INV_PROTO)
-		&& matchsize == XT_ALIGN(sizeof(struct xt_sctp_info))
-		&& !(info->flags & ~XT_SCTP_VALID_FLAGS)
+	return !(info->flags & ~XT_SCTP_VALID_FLAGS)
 		&& !(info->invflags & ~XT_SCTP_VALID_FLAGS)
 		&& !(info->invflags & ~info->flags)
 		&& ((!(info->flags & XT_SCTP_CHUNK_TYPES)) || 
@@ -209,22 +178,23 @@ checkentry6(const char *tablename,
 				| SCTP_CHUNK_MATCH_ONLY)));
 }
 
-
-static struct xt_match sctp_match = 
-{ 
-	.name = "sctp",
-	.match = &match,
-	.checkentry = &checkentry,
-	.me = THIS_MODULE
-};
-static struct xt_match sctp6_match = 
-{ 
-	.name = "sctp",
-	.match = &match,
-	.checkentry = &checkentry6,
-	.me = THIS_MODULE
+static struct xt_match sctp_match = {
+	.name		= "sctp",
+	.match		= match,
+	.matchsize	= sizeof(struct xt_sctp_info),
+	.proto		= IPPROTO_SCTP,
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE
 };
 
+static struct xt_match sctp6_match = {
+	.name		= "sctp",
+	.match		= match,
+	.matchsize	= sizeof(struct xt_sctp_info),
+	.proto		= IPPROTO_SCTP,
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE
+};
 
 static int __init init(void)
 {
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 39ce808..9a7d6df 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -43,29 +43,17 @@ match(const struct sk_buff *skb,
 	return (sinfo->statemask & statebit);
 }
 
-static int check(const char *tablename,
-		 const void *ip,
-		 void *matchinfo,
-		 unsigned int matchsize,
-		 unsigned int hook_mask)
-{
-	if (matchsize != XT_ALIGN(sizeof(struct xt_state_info)))
-		return 0;
-
-	return 1;
-}
-
 static struct xt_match state_match = {
 	.name		= "state",
-	.match		= &match,
-	.checkentry	= &check,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_state_info),
 	.me		= THIS_MODULE,
 };
 
 static struct xt_match state6_match = {
 	.name		= "state",
-	.match		= &match,
-	.checkentry	= &check,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_state_info),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 7c7d5c8..c3efd37 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -50,9 +50,6 @@ static int checkentry(const char *tablen
 	struct xt_string_info *conf = matchinfo;
 	struct ts_config *ts_conf;
 
-	if (matchsize != XT_ALIGN(sizeof(struct xt_string_info)))
-		return 0;
-
 	/* Damn, can't handle this case properly with iptables... */
 	if (conf->from_offset > conf->to_offset)
 		return 0;
@@ -75,6 +72,7 @@ static void destroy(void *matchinfo, uns
 static struct xt_match string_match = {
 	.name 		= "string",
 	.match 		= match,
+	.matchsize	= sizeof(struct xt_string_info),
 	.checkentry	= checkentry,
 	.destroy 	= destroy,
 	.me 		= THIS_MODULE
@@ -82,6 +80,7 @@ static struct xt_match string_match = {
 static struct xt_match string6_match = {
 	.name 		= "string",
 	.match 		= match,
+	.matchsize	= sizeof(struct xt_string_info),
 	.checkentry	= checkentry,
 	.destroy 	= destroy,
 	.me 		= THIS_MODULE
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index acf7f53..95d8611 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -92,58 +92,19 @@ match(const struct sk_buff *skb,
 			       info->invert, hotdrop);
 }
 
-static int
-checkentry(const char *tablename,
-           const void *ipinfo,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
-{
-	const struct ipt_ip *ip = ipinfo;
-	if (matchsize != XT_ALIGN(sizeof(struct xt_tcpmss_match_info)))
-		return 0;
-
-	/* Must specify -p tcp */
-	if (ip->proto != IPPROTO_TCP || (ip->invflags & IPT_INV_PROTO)) {
-		printk("tcpmss: Only works on TCP packets\n");
-		return 0;
-	}
-
-	return 1;
-}
-
-static int
-checkentry6(const char *tablename,
-	   const void *ipinfo,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
-{
-	const struct ip6t_ip6 *ip = ipinfo;
-
-	if (matchsize != XT_ALIGN(sizeof(struct xt_tcpmss_match_info)))
-		return 0;
-
-	/* Must specify -p tcp */
-	if (ip->proto != IPPROTO_TCP || (ip->invflags & XT_INV_PROTO)) {
-		printk("tcpmss: Only works on TCP packets\n");
-		return 0;
-	}
-
-	return 1;
-}
-
 static struct xt_match tcpmss_match = {
 	.name		= "tcpmss",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_tcpmss_match_info),
+	.proto		= IPPROTO_TCP,
 	.me		= THIS_MODULE,
 };
 
 static struct xt_match tcpmss6_match = {
 	.name		= "tcpmss",
-	.match		= &match,
-	.checkentry	= &checkentry6,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_tcpmss_match_info),
+	.proto		= IPPROTO_TCP,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 669c811..9d01f07 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -142,35 +142,12 @@ tcp_checkentry(const char *tablename,
 	       unsigned int matchsize,
 	       unsigned int hook_mask)
 {
-	const struct ipt_ip *ip = info;
 	const struct xt_tcp *tcpinfo = matchinfo;
 
-	/* Must specify proto == TCP, and no unknown invflags */
-	return ip->proto == IPPROTO_TCP
-		&& !(ip->invflags & XT_INV_PROTO)
-		&& matchsize == XT_ALIGN(sizeof(struct xt_tcp))
-		&& !(tcpinfo->invflags & ~XT_TCP_INV_MASK);
+	/* Must specify no unknown invflags */
+	return !(tcpinfo->invflags & ~XT_TCP_INV_MASK);
 }
 
-/* Called when user tries to insert an entry of this type. */
-static int
-tcp6_checkentry(const char *tablename,
-	       const void *entry,
-	       void *matchinfo,
-	       unsigned int matchsize,
-	       unsigned int hook_mask)
-{
-	const struct ip6t_ip6 *ipv6 = entry;
-	const struct xt_tcp *tcpinfo = matchinfo;
-
-	/* Must specify proto == TCP, and no unknown invflags */
-	return ipv6->proto == IPPROTO_TCP
-		&& !(ipv6->invflags & XT_INV_PROTO)
-		&& matchsize == XT_ALIGN(sizeof(struct xt_tcp))
-		&& !(tcpinfo->invflags & ~XT_TCP_INV_MASK);
-}
-
-
 static int
 udp_match(const struct sk_buff *skb,
 	  const struct net_device *in,
@@ -209,86 +186,47 @@ static int
 udp_checkentry(const char *tablename,
 	       const void *info,
 	       void *matchinfo,
-	       unsigned int matchinfosize,
-	       unsigned int hook_mask)
-{
-	const struct ipt_ip *ip = info;
-	const struct xt_udp *udpinfo = matchinfo;
-
-	/* Must specify proto == UDP, and no unknown invflags */
-	if (ip->proto != IPPROTO_UDP || (ip->invflags & XT_INV_PROTO)) {
-		duprintf("ipt_udp: Protocol %u != %u\n", ip->proto,
-			 IPPROTO_UDP);
-		return 0;
-	}
-	if (matchinfosize != XT_ALIGN(sizeof(struct xt_udp))) {
-		duprintf("ipt_udp: matchsize %u != %u\n",
-			 matchinfosize, XT_ALIGN(sizeof(struct xt_udp)));
-		return 0;
-	}
-	if (udpinfo->invflags & ~XT_UDP_INV_MASK) {
-		duprintf("ipt_udp: unknown flags %X\n",
-			 udpinfo->invflags);
-		return 0;
-	}
-
-	return 1;
-}
-
-/* Called when user tries to insert an entry of this type. */
-static int
-udp6_checkentry(const char *tablename,
-	       const void *entry,
-	       void *matchinfo,
-	       unsigned int matchinfosize,
+	       unsigned int matchsize,
 	       unsigned int hook_mask)
 {
-	const struct ip6t_ip6 *ipv6 = entry;
-	const struct xt_udp *udpinfo = matchinfo;
+	const struct xt_tcp *udpinfo = matchinfo;
 
-	/* Must specify proto == UDP, and no unknown invflags */
-	if (ipv6->proto != IPPROTO_UDP || (ipv6->invflags & XT_INV_PROTO)) {
-		duprintf("ip6t_udp: Protocol %u != %u\n", ipv6->proto,
-			 IPPROTO_UDP);
-		return 0;
-	}
-	if (matchinfosize != XT_ALIGN(sizeof(struct xt_udp))) {
-		duprintf("ip6t_udp: matchsize %u != %u\n",
-			 matchinfosize, XT_ALIGN(sizeof(struct xt_udp)));
-		return 0;
-	}
-	if (udpinfo->invflags & ~XT_UDP_INV_MASK) {
-		duprintf("ip6t_udp: unknown flags %X\n",
-			 udpinfo->invflags);
-		return 0;
-	}
-
-	return 1;
+	/* Must specify no unknown invflags */
+	return !(udpinfo->invflags & ~XT_UDP_INV_MASK);
 }
 
 static struct xt_match tcp_matchstruct = {
 	.name		= "tcp",
-	.match		= &tcp_match,
-	.checkentry	= &tcp_checkentry,
+	.match		= tcp_match,
+	.matchsize	= sizeof(struct xt_tcp),
+	.proto		= IPPROTO_TCP,
+	.checkentry	= tcp_checkentry,
 	.me		= THIS_MODULE,
 };
+
 static struct xt_match tcp6_matchstruct = {
 	.name		= "tcp",
-	.match		= &tcp_match,
-	.checkentry	= &tcp6_checkentry,
+	.match		= tcp_match,
+	.matchsize	= sizeof(struct xt_tcp),
+	.proto		= IPPROTO_TCP,
+	.checkentry	= tcp_checkentry,
 	.me		= THIS_MODULE,
 };
 
 static struct xt_match udp_matchstruct = {
 	.name		= "udp",
-	.match		= &udp_match,
-	.checkentry	= &udp_checkentry,
+	.match		= udp_match,
+	.matchsize	= sizeof(struct xt_udp),
+	.proto		= IPPROTO_UDP,
+	.checkentry	= udp_checkentry,
 	.me		= THIS_MODULE,
 };
 static struct xt_match udp6_matchstruct = {
 	.name		= "udp",
-	.match		= &udp_match,
-	.checkentry	= &udp6_checkentry,
+	.match		= udp_match,
+	.matchsize	= sizeof(struct xt_udp),
+	.proto		= IPPROTO_UDP,
+	.checkentry	= udp_checkentry,
 	.me		= THIS_MODULE,
 };
 

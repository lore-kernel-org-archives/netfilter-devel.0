From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/09]: nfnetlink: make subsystem and callbacks const
Date: Thu, 27 Sep 2007 15:46:00 +0200 (MEST)
Message-ID: <20070927134600.10198.30749.sendpatchset@localhost.localdomain>
References: <20070927134559.10198.64673.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58735 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbXI0NqC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:46:02 -0400
In-Reply-To: <20070927134559.10198.64673.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink: make subsystem and callbacks const

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 51a4f2a104898dd615d91bae8283dc61de0544e4
tree de6f515c5e2705f85fb86777db0fb8f1b6b5dbbf
parent 5f81f1c0a4e68593feb6b95dbacab87f1718ea6e
author Patrick McHardy <kaber@trash.net> Thu, 27 Sep 2007 13:03:05 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 27 Sep 2007 13:03:05 +0200

 include/linux/netfilter/nfnetlink.h  |   10 +++++-----
 net/netfilter/nf_conntrack_netlink.c |    8 ++++----
 net/netfilter/nfnetlink.c            |   18 +++++++++---------
 net/netfilter/nfnetlink_log.c        |    4 ++--
 net/netfilter/nfnetlink_queue.c      |    4 ++--
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 0f9311d..e32418b 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -118,9 +118,9 @@ struct nfnl_callback
 struct nfnetlink_subsystem
 {
 	const char *name;
-	__u8 subsys_id;		/* nfnetlink subsystem ID */
-	__u8 cb_count;		/* number of callbacks */
-	struct nfnl_callback *cb; /* callback for individual types */
+	__u8 subsys_id;			/* nfnetlink subsystem ID */
+	__u8 cb_count;			/* number of callbacks */
+	const struct nfnl_callback *cb;	/* callback for individual types */
 };
 
 extern void __nfa_fill(struct sk_buff *skb, int attrtype,
@@ -129,8 +129,8 @@ extern void __nfa_fill(struct sk_buff *skb, int attrtype,
 ({ if (skb_tailroom(skb) < (int)NFA_SPACE(attrlen)) goto nfattr_failure; \
    __nfa_fill(skb, attrtype, attrlen, data); })
 
-extern int nfnetlink_subsys_register(struct nfnetlink_subsystem *n);
-extern int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n);
+extern int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
+extern int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n);
 
 extern void nfattr_parse(struct nfattr *tb[], int maxattr, 
 			struct nfattr *nfa, int len);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2863e72..5080045 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1548,7 +1548,7 @@ static struct notifier_block ctnl_notifier_exp = {
 };
 #endif
 
-static struct nfnl_callback ctnl_cb[IPCTNL_MSG_MAX] = {
+static const struct nfnl_callback ctnl_cb[IPCTNL_MSG_MAX] = {
 	[IPCTNL_MSG_CT_NEW]		= { .call = ctnetlink_new_conntrack,
 					    .attr_count = CTA_MAX, },
 	[IPCTNL_MSG_CT_GET] 		= { .call = ctnetlink_get_conntrack,
@@ -1559,7 +1559,7 @@ static struct nfnl_callback ctnl_cb[IPCTNL_MSG_MAX] = {
 					    .attr_count = CTA_MAX, },
 };
 
-static struct nfnl_callback ctnl_exp_cb[IPCTNL_MSG_EXP_MAX] = {
+static const struct nfnl_callback ctnl_exp_cb[IPCTNL_MSG_EXP_MAX] = {
 	[IPCTNL_MSG_EXP_GET]		= { .call = ctnetlink_get_expect,
 					    .attr_count = CTA_EXPECT_MAX, },
 	[IPCTNL_MSG_EXP_NEW]		= { .call = ctnetlink_new_expect,
@@ -1568,14 +1568,14 @@ static struct nfnl_callback ctnl_exp_cb[IPCTNL_MSG_EXP_MAX] = {
 					    .attr_count = CTA_EXPECT_MAX, },
 };
 
-static struct nfnetlink_subsystem ctnl_subsys = {
+static const struct nfnetlink_subsystem ctnl_subsys = {
 	.name				= "conntrack",
 	.subsys_id			= NFNL_SUBSYS_CTNETLINK,
 	.cb_count			= IPCTNL_MSG_MAX,
 	.cb				= ctnl_cb,
 };
 
-static struct nfnetlink_subsystem ctnl_exp_subsys = {
+static const struct nfnetlink_subsystem ctnl_exp_subsys = {
 	.name				= "conntrack_expect",
 	.subsys_id			= NFNL_SUBSYS_CTNETLINK_EXP,
 	.cb_count			= IPCTNL_MSG_EXP_MAX,
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4aa56e7..032224c 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -41,7 +41,7 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
 static char __initdata nfversion[] = "0.30";
 
 static struct sock *nfnl = NULL;
-static struct nfnetlink_subsystem *subsys_table[NFNL_SUBSYS_COUNT];
+static const struct nfnetlink_subsystem *subsys_table[NFNL_SUBSYS_COUNT];
 static DEFINE_MUTEX(nfnl_mutex);
 
 static void nfnl_lock(void)
@@ -66,7 +66,7 @@ static void nfnl_unlock(void)
 		nfnl->sk_data_ready(nfnl, 0);
 }
 
-int nfnetlink_subsys_register(struct nfnetlink_subsystem *n)
+int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n)
 {
 	nfnl_lock();
 	if (subsys_table[n->subsys_id]) {
@@ -80,7 +80,7 @@ int nfnetlink_subsys_register(struct nfnetlink_subsystem *n)
 }
 EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
 
-int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n)
+int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n)
 {
 	nfnl_lock();
 	subsys_table[n->subsys_id] = NULL;
@@ -90,7 +90,7 @@ int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n)
 }
 EXPORT_SYMBOL_GPL(nfnetlink_subsys_unregister);
 
-static inline struct nfnetlink_subsystem *nfnetlink_get_subsys(u_int16_t type)
+static inline const struct nfnetlink_subsystem *nfnetlink_get_subsys(u_int16_t type)
 {
 	u_int8_t subsys_id = NFNL_SUBSYS_ID(type);
 
@@ -100,8 +100,8 @@ static inline struct nfnetlink_subsystem *nfnetlink_get_subsys(u_int16_t type)
 	return subsys_table[subsys_id];
 }
 
-static inline struct nfnl_callback *
-nfnetlink_find_client(u_int16_t type, struct nfnetlink_subsystem *ss)
+static inline const struct nfnl_callback *
+nfnetlink_find_client(u_int16_t type, const struct nfnetlink_subsystem *ss)
 {
 	u_int8_t cb_id = NFNL_MSG_TYPE(type);
 
@@ -147,7 +147,7 @@ EXPORT_SYMBOL_GPL(nfattr_parse);
  *
  */
 static int
-nfnetlink_check_attributes(struct nfnetlink_subsystem *subsys,
+nfnetlink_check_attributes(const struct nfnetlink_subsystem *subsys,
 			   struct nlmsghdr *nlh, struct nfattr *cda[])
 {
 	int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
@@ -197,8 +197,8 @@ EXPORT_SYMBOL_GPL(nfnetlink_unicast);
 /* Process one complete nfnetlink message. */
 static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
-	struct nfnl_callback *nc;
-	struct nfnetlink_subsystem *ss;
+	const struct nfnl_callback *nc;
+	const struct nfnetlink_subsystem *ss;
 	int type, err;
 
 	if (security_netlink_recv(skb, CAP_NET_ADMIN))
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 8e4001b..1c47b9a 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -882,14 +882,14 @@ out:
 	return ret;
 }
 
-static struct nfnl_callback nfulnl_cb[NFULNL_MSG_MAX] = {
+static const struct nfnl_callback nfulnl_cb[NFULNL_MSG_MAX] = {
 	[NFULNL_MSG_PACKET]	= { .call = nfulnl_recv_unsupp,
 				    .attr_count = NFULA_MAX, },
 	[NFULNL_MSG_CONFIG]	= { .call = nfulnl_recv_config,
 				    .attr_count = NFULA_CFG_MAX, },
 };
 
-static struct nfnetlink_subsystem nfulnl_subsys = {
+static const struct nfnetlink_subsystem nfulnl_subsys = {
 	.name		= "log",
 	.subsys_id	= NFNL_SUBSYS_ULOG,
 	.cb_count	= NFULNL_MSG_MAX,
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c97369f..db371a5 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -962,7 +962,7 @@ out_put:
 	return ret;
 }
 
-static struct nfnl_callback nfqnl_cb[NFQNL_MSG_MAX] = {
+static const struct nfnl_callback nfqnl_cb[NFQNL_MSG_MAX] = {
 	[NFQNL_MSG_PACKET]	= { .call = nfqnl_recv_unsupp,
 				    .attr_count = NFQA_MAX, },
 	[NFQNL_MSG_VERDICT]	= { .call = nfqnl_recv_verdict,
@@ -971,7 +971,7 @@ static struct nfnl_callback nfqnl_cb[NFQNL_MSG_MAX] = {
 				    .attr_count = NFQA_CFG_MAX, },
 };
 
-static struct nfnetlink_subsystem nfqnl_subsys = {
+static const struct nfnetlink_subsystem nfqnl_subsys = {
 	.name		= "nf_queue",
 	.subsys_id	= NFNL_SUBSYS_QUEUE,
 	.cb_count	= NFQNL_MSG_MAX,

From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/22]: nfnetlink: remove early debugging messages from
	nfnetlink
Date: Wed, 14 Mar 2007 09:50:31 +0100 (MET)
Message-ID: <20070314085015.15282.36815.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink: remove early debugging messages from nfnetlink

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 750623a576cf1a6cd62d138be4da5b95a8419c35
tree 1ae7982c1e123a23f56e890c0d8110cfd23bf13a
parent f8184abb940940e7503c5b089e89d2d88b4eb34c
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 08 Mar 2007 18:25:20 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:30:46 +0100

 net/netfilter/nfnetlink.c |   42 ++++++------------------------------------
 1 files changed, 6 insertions(+), 36 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 5be6ac4..c8b4f0d 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -3,7 +3,7 @@
  *
  * (C) 2001 by Jay Schulist <jschlst@samba.org>,
  * (C) 2002-2005 by Harald Welte <laforge@gnumonks.org>
- * (C) 2005 by Pablo Neira Ayuso <pablo@eurodev.net>
+ * (C) 2005,2007 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Initial netfilter messages via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -42,14 +42,6 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NE
 
 static char __initdata nfversion[] = "0.30";
 
-#if 0
-#define DEBUGP(format, args...)	\
-		printk(KERN_DEBUG "%s(%d):%s(): " format, __FILE__, \
-			__LINE__, __FUNCTION__, ## args)
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static struct sock *nfnl = NULL;
 static struct nfnetlink_subsystem *subsys_table[NFNL_SUBSYS_COUNT];
 static DEFINE_MUTEX(nfnl_mutex);
@@ -78,8 +70,6 @@ static void nfnl_unlock(void)
 
 int nfnetlink_subsys_register(struct nfnetlink_subsystem *n)
 {
-	DEBUGP("registering subsystem ID %u\n", n->subsys_id);
-
 	nfnl_lock();
 	if (subsys_table[n->subsys_id]) {
 		nfnl_unlock();
@@ -93,8 +83,6 @@ int nfnetlink_subsys_register(struct nfn
 
 int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n)
 {
-	DEBUGP("unregistering subsystem ID %u\n", n->subsys_id);
-
 	nfnl_lock();
 	subsys_table[n->subsys_id] = NULL;
 	nfnl_unlock();
@@ -118,10 +106,8 @@ nfnetlink_find_client(u_int16_t type, st
 {
 	u_int8_t cb_id = NFNL_MSG_TYPE(type);
 
-	if (cb_id >= ss->cb_count) {
-		DEBUGP("msgtype %u >= %u, returning\n", type, ss->cb_count);
+	if (cb_id >= ss->cb_count)
 		return NULL;
-	}
 
 	return &ss->cb[cb_id];
 }
@@ -167,11 +153,8 @@ nfnetlink_check_attributes(struct nfnetl
 	u_int16_t attr_count;
 	u_int8_t cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
 
-	if (unlikely(cb_id >= subsys->cb_count)) {
-		DEBUGP("msgtype %u >= %u, returning\n",
-			cb_id, subsys->cb_count);
+	if (unlikely(cb_id >= subsys->cb_count))
 		return -EINVAL;
-	}
 
 	min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
 	if (unlikely(nlh->nlmsg_len < min_len))
@@ -235,27 +218,18 @@ static int nfnetlink_rcv_msg(struct sk_b
 	struct nfnetlink_subsystem *ss;
 	int type, err = 0;
 
-	DEBUGP("entered; subsys=%u, msgtype=%u\n",
-		 NFNL_SUBSYS_ID(nlh->nlmsg_type),
-		 NFNL_MSG_TYPE(nlh->nlmsg_type));
-
 	if (security_netlink_recv(skb, CAP_NET_ADMIN)) {
-		DEBUGP("missing CAP_NET_ADMIN\n");
 		*errp = -EPERM;
 		return -1;
 	}
 
 	/* Only requests are handled by kernel now. */
-	if (!(nlh->nlmsg_flags & NLM_F_REQUEST)) {
-		DEBUGP("received non-request message\n");
+	if (!(nlh->nlmsg_flags & NLM_F_REQUEST))
 		return 0;
-	}
 
 	/* All the messages must at least contain nfgenmsg */
-	if (nlh->nlmsg_len < NLMSG_SPACE(sizeof(struct nfgenmsg))) {
-		DEBUGP("received message was too short\n");
+	if (nlh->nlmsg_len < NLMSG_SPACE(sizeof(struct nfgenmsg)))
 		return 0;
-	}
 
 	type = nlh->nlmsg_type;
 	ss = nfnetlink_get_subsys(type);
@@ -273,10 +247,8 @@ #endif
 	}
 
 	nc = nfnetlink_find_client(type, ss);
-	if (!nc) {
-		DEBUGP("unable to find client for type %d\n", type);
+	if (!nc)
 		goto err_inval;
-	}
 
 	{
 		u_int16_t attr_count =
@@ -289,14 +261,12 @@ #endif
 		if (err < 0)
 			goto err_inval;
 
-		DEBUGP("calling handler\n");
 		err = nc->call(nfnl, skb, nlh, cda, errp);
 		*errp = err;
 		return err;
 	}
 
 err_inval:
-	DEBUGP("returning -EINVAL\n");
 	*errp = -EINVAL;
 	return -1;
 }

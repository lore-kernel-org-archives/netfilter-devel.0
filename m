From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/7] Remove debugging messages from nfnetlink
Date: Mon, 12 Feb 2007 23:45:51 +0100
Message-ID: <45D0EE1F.6060400@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050708060306020108080108"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------050708060306020108080108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Remove early debugging messages from nfnetlink

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------050708060306020108080108
Content-Type: text/plain;
 name="01.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.patch"

[PATCH] Remove debugging messages from nfnetlink

Remove early debugging messages from nfnetlink

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nfnetlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nfnetlink.c	2007-02-07 16:47:03.000000000 +0100
+++ net-2.6.git/net/netfilter/nfnetlink.c	2007-02-07 16:47:19.000000000 +0100
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
 DECLARE_MUTEX(nfnl_sem);
@@ -66,8 +58,6 @@ void nfnl_unlock(void)
 
 int nfnetlink_subsys_register(struct nfnetlink_subsystem *n)
 {
-	DEBUGP("registering subsystem ID %u\n", n->subsys_id);
-
 	nfnl_lock();
 	if (subsys_table[n->subsys_id]) {
 		nfnl_unlock();
@@ -81,8 +71,6 @@ int nfnetlink_subsys_register(struct nfn
 
 int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n)
 {
-	DEBUGP("unregistering subsystem ID %u\n", n->subsys_id);
-
 	nfnl_lock();
 	subsys_table[n->subsys_id] = NULL;
 	nfnl_unlock();
@@ -106,10 +94,8 @@ nfnetlink_find_client(u_int16_t type, st
 {
 	u_int8_t cb_id = NFNL_MSG_TYPE(type);
 	
-	if (cb_id >= ss->cb_count) {
-		DEBUGP("msgtype %u >= %u, returning\n", type, ss->cb_count);
+	if (cb_id >= ss->cb_count)
 		return NULL;
-	}
 
 	return &ss->cb[cb_id];
 }
@@ -155,11 +141,8 @@ nfnetlink_check_attributes(struct nfnetl
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
@@ -224,27 +207,18 @@ static int nfnetlink_rcv_msg(struct sk_b
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
@@ -262,10 +236,8 @@ static int nfnetlink_rcv_msg(struct sk_b
 	}
 
 	nc = nfnetlink_find_client(type, ss);
-	if (!nc) {
-		DEBUGP("unable to find client for type %d\n", type);
+	if (!nc)
 		goto err_inval;
-	}
 
 	{
 		u_int16_t attr_count = 
@@ -278,14 +250,12 @@ static int nfnetlink_rcv_msg(struct sk_b
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

--------------050708060306020108080108--

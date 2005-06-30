From: Pablo Neira <pablo@eurodev.net>
Subject: [RFC][PATCH] nfnetlink parses attributes
Date: Thu, 30 Jun 2005 20:05:43 +0200
Message-ID: <42C43477.40307@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050403020506080607000401"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------050403020506080607000401
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Please do not apply this patch, just a RFC.

I think that we can could nfnetlink_check_attributes from nfnetlink 
itself, so the subsystems receive the attributes already parsed. Almost 
  all the operations in ip_conntrack_netlink always call 
check_attributes first to parse attributes.

--
Pablo

--------------050403020506080607000401
Content-Type: text/x-patch;
 name="attributes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="attributes.patch"

Index: davem-2.6/net/netfilter/nfnetlink.c
===================================================================
--- davem-2.6.orig/net/netfilter/nfnetlink.c	2005-06-30 19:31:47.000000000 +0200
+++ davem-2.6/net/netfilter/nfnetlink.c	2005-06-30 19:49:20.000000000 +0200
@@ -103,19 +103,23 @@
 	return 0;
 }
 
-struct nfnl_callback *nfnetlink_find_client(u_int16_t nlmsg_type)
+static inline struct nfnetlink_subsystem *nfnetlink_get_subsys(u_int16_t type)
 {
-	struct nfnetlink_subsystem *ss;
-	u_int8_t subsys_id = NFNL_SUBSYS_ID(nlmsg_type);
-	u_int8_t type = NFNL_MSG_TYPE(nlmsg_type);
+	u_int8_t subsys_id = NFNL_SUBSYS_ID(type);
 
 	if (subsys_id >= NFNL_SUBSYS_COUNT
 	    || subsys_table[subsys_id] == NULL)
 		return NULL;
 
-	ss = subsys_table[subsys_id];
+	return subsys_table[subsys_id];
+}
 
-	if (type >= ss->cb_count) {
+static inline struct nfnl_callback *
+nfnetlink_find_client(u_int16_t type, struct nfnetlink_subsystem *ss)
+{
+	u_int8_t cb_id = NFNL_MSG_TYPE(type);
+	
+	if (cb_id >= ss->cb_count) {
 		DEBUGP("msgtype %u >= %u, returning\n", type, ss->cb_count);
 		return NULL;
 	}
@@ -209,6 +213,7 @@
 				    struct nlmsghdr *nlh, int *errp)
 {
 	struct nfnl_callback *nc;
+	struct nfnetlink_subsystem *ss;
 	int type, err = 0;
 
 	DEBUGP("entered; subsys=%u, msgtype=%u\n",
@@ -228,7 +233,11 @@
 	}
 
 	type = nlh->nlmsg_type;
-	nc = nfnetlink_find_client(type);
+	ss = nfnetlink_get_subsys(type);
+	if (!ss)
+		goto err_inval;
+
+	nc = nfnetlink_find_client(type, ss);
 	if (!nc) {
 		DEBUGP("unable to find client for type %d\n", type);
 		goto err_inval;
@@ -241,9 +250,17 @@
 		return -1;
 	}
 
-	err = nc->call(nfnl, skb, nlh, errp);
-	*errp = err;
-	return err;
+	{
+		struct nfattr *cda[ss->attr_count];
+		
+		err = nfnetlink_check_attributes(ss, nlh, cda);
+		if (err < 0)
+			goto err_inval;
+		
+		err = nc->call(nfnl, skb, nlh, cda, errp);
+		*errp = err;
+		return err;
+	}
 
 err_inval:
 	*errp = -EINVAL;
Index: davem-2.6/include/linux/netfilter/nfnetlink.h
===================================================================
--- davem-2.6.orig/include/linux/netfilter/nfnetlink.h	2005-06-30 19:50:06.000000000 +0200
+++ davem-2.6/include/linux/netfilter/nfnetlink.h	2005-06-30 19:50:40.000000000 +0200
@@ -60,7 +60,7 @@
 {
 	kernel_cap_t cap_required; /* capabilities required for this msg */
 	int (*call)(struct sock *nl, struct sk_buff *skb, 
-		struct nlmsghdr *nlh, int *errp);
+		struct nlmsghdr *nlh, struct nfattr *cda[], int *errp);
 };
 
 struct nfnetlink_subsystem

--------------050403020506080607000401--

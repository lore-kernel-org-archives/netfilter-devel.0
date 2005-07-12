From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 1/*] nfnetlink updates
Date: Tue, 12 Jul 2005 22:35:01 +0200
Message-ID: <42D42975.8070303@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010704040006060405000406"
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
--------------010704040006060405000406
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch introduces the following changes to nfnetlink:

a) nfnetlink groups: Up to 32 maximum.

+#define NF_NETLINK_CONNTRACK_NEW       0x1
+#define NF_NETLINK_CONNTRACK_UPDATE    0x2
+#define NF_NETLINK_CONNTRACK_DESTROY   0x4
+#define NF_NETLINK_CONNTRACK_EXPECT    0x8

I think that those four groups are enough to group events.

b) NFA_NEST and NFA_NEST_END. As it was discussed, it's time to move 
this netlink stuff to a generic file, otherwise we could use RTA_* 
instead since all this NFA_* stuff is a copy and paste from the original 
RTA_*. Anyway

c) We don't need this, that is defined in netlink.h.

-#ifndef NETLINK_NETFILTER
-#define NETLINK_NETFILTER      10
-#endif

d) NFNL_SUBSYS_CTNETLINK_EXP has been killed. This is superseded by the 
group NF_NETLINK_CONNTRACK_EXPECT.

e) nfnetlink_subsystem internal list isn't used, the array is enough.

f) Fixed nfnl_shunlock.

g) nfnetlink_subsys_alloc isn't useful anymore. Now we store the 
nfnetlink_subsystem in the BSS section. Please see 
ip_conntrack_netlink.c for an example.

h) nfnetlink_check_attributes is called from nfnetlink, so we pass the 
attributes parsed to as parameter to the callback.

See for more info: 
http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=2671

i) Killed redundant check for unknown message.

--------------010704040006060405000406
Content-Type: text/x-patch;
 name="01nfnetlink.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01nfnetlink.patch"

Index: linux-2.6/include/linux/netfilter/nfnetlink.h
===================================================================
--- linux-2.6/include/linux/netfilter/nfnetlink.h	(revision 4112)
+++ linux-2.6/include/linux/netfilter/nfnetlink.h	(working copy)
@@ -2,6 +2,12 @@
 #define _NFNETLINK_H
 #include <linux/types.h>
 
+/* nfnetlink groups: Up to 32 maximum */
+#define NF_NETLINK_CONNTRACK_NEW 	0x1
+#define NF_NETLINK_CONNTRACK_UPDATE	0x2
+#define NF_NETLINK_CONNTRACK_DESTROY	0x4
+#define NF_NETLINK_CONNTRACK_EXPECT	0x8
+
 /* Generic structure for encapsulation optional netfilter information.
  * It is reminiscent of sockaddr, but with sa_family replaced
  * with attribute type. 
@@ -15,6 +21,9 @@
 	unsigned short  nfa_type;
 };
 
+/* FIXME: Shamelessly copy and pasted from rtnetlink.h, it's time
+ * 	  to put this in a generic file */
+
 #define NFA_ALIGNTO     4
 #define NFA_ALIGN(len)	(((len) + NFA_ALIGNTO - 1) & ~(NFA_ALIGNTO - 1))
 #define NFA_OK(nfa,len)	((len) > 0 && (nfa)->nfa_len >= sizeof(struct nfattr) \
@@ -25,6 +34,17 @@
 #define NFA_SPACE(len)	NFA_ALIGN(NFA_LENGTH(len))
 #define NFA_DATA(nfa)   ((void *)(((char *)(nfa)) + NFA_LENGTH(0)))
 #define NFA_PAYLOAD(nfa) ((int)((nfa)->nfa_len) - NFA_LENGTH(0))
+#define NFA_NEST(skb, type) \
+({	struct nfattr *__start = (struct nfattr *) (skb)->tail; \
+	NFA_PUT(skb, type, 0, NULL); \
+	__start;  })
+#define NFA_NEST_END(skb, start) \
+({      (start)->nfa_len = ((skb)->tail - (unsigned char *) (start)); \
+        (skb)->len; })
+#define NFA_NEST_CANCEL(skb, start) \
+({      if (start) \
+                skb_trim(skb, (unsigned char *) (start) - (skb)->data); \
+        -1; })
 
 /* General form of address family dependent message.
  */
@@ -36,11 +56,6 @@
         + NLMSG_ALIGN(sizeof(struct nfgenmsg))))
 #define NFM_PAYLOAD(n)  NLMSG_PAYLOAD(n, sizeof(struct nfgenmsg))
 
-
-#ifndef NETLINK_NETFILTER
-#define NETLINK_NETFILTER	10
-#endif
-
 /* netfilter netlink message types are split in two pieces:
  * 8 bit subsystem, 8bit operation.
  */
@@ -51,7 +66,6 @@
 enum nfnl_subsys_id {
 	NFNL_SUBSYS_NONE = 0,
 	NFNL_SUBSYS_CTNETLINK,
-	NFNL_SUBSYS_CTNETLINK_EXP,
 	NFNL_SUBSYS_IPTNETLINK,
 	NFNL_SUBSYS_QUEUE,
 	NFNL_SUBSYS_ULOG,
@@ -66,19 +80,16 @@
 {
 	kernel_cap_t cap_required; /* capabilities required for this msg */
 	int (*call)(struct sock *nl, struct sk_buff *skb, 
-		struct nlmsghdr *nlh, int *errp);
+		struct nlmsghdr *nlh, struct nfattr *cda[], int *errp);
 };
 
 struct nfnetlink_subsystem
 {
-	/* Internal use. */
-	struct list_head list;
-	
 	const char *name;
 	__u8 subsys_id;		/* nfnetlink subsystem ID */
 	__u8 cb_count;		/* number of callbacks */
 	u_int32_t attr_count;	/* number of nfattr's */
-	struct nfnl_callback cb[0]; /* callback for individual types */
+	struct nfnl_callback *cb; /* callback for individual types */
 };
 
 extern void __nfa_fill(struct sk_buff *skb, int attrtype,
@@ -88,34 +99,37 @@
    __nfa_fill(skb, attrtype, attrlen, data); })
 
 extern struct semaphore nfnl_sem;
-#define nfnl_exlock()		do { } while(0)
-#define nfnl_exunlock()		do { } while(0)
-#define nfnl_exlock_nowait()	(0)
 
 #define nfnl_shlock()		down(&nfnl_sem)
 #define nfnl_shlock_nowait()	down_trylock(&nfnl_sem)
 
-#ifndef CONFIG_NF_NETLINK
-#define nfnl_shunlock()		up(&nfnl_sem)
-#else
 #define nfnl_shunlock()		do { up(&nfnl_sem); \
-                             		if(nfnl && nfnl->receive_queue.qlen) \
-                                     		nfnl->data_ready(nfnl, 0); \
+				     if(nfnl && nfnl->sk_receive_queue.qlen) \
+					    nfnl->sk_data_ready(nfnl, 0); \
                         	} while(0)
-#endif
 
 extern void nfnl_lock(void);
 extern void nfnl_unlock(void);
 
-extern struct nfnetlink_subsystem *nfnetlink_subsys_alloc(int cb_count);
 extern int nfnetlink_subsys_register(struct nfnetlink_subsystem *n);
 extern int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n);
 
-extern int nfnetlink_check_attributes(struct nfnetlink_subsystem *subsys,
-				      struct nlmsghdr *nlh, 
-				      struct nfattr *cda[]);
 extern int nfattr_parse(struct nfattr *tb[], int maxattr, 
 			struct nfattr *nfa, int len);
+
+#define nfattr_parse_nested(tb, max, nfa) \
+	nfattr_parse((tb), (max), NFA_DATA((nfa)), NFA_PAYLOAD((nfa)))
+
+#define nfattr_bad_size(tb, max, cta_min)				\
+({	int __i, __res = 0;						\
+ 	for (__i=0; __i<max; __i++) 					\
+ 		if (tb[__i] && NFA_PAYLOAD(tb[__i]) < cta_min[__i]){	\
+ 			__res = 1;					\
+ 			break;						\
+ 		}							\
+ 	__res;								\
+})
+
 extern int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, 
 			  int echo);
 
Index: linux-2.6/net/netfilter/nfnetlink.c
===================================================================
--- linux-2.6/net/netfilter/nfnetlink.c	(revision 4112)
+++ linux-2.6/net/netfilter/nfnetlink.c	(working copy)
@@ -3,6 +3,7 @@
  *
  * (C) 2001 by Jay Schulist <jschlst@samba.org>,
  * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2005 by Pablo Neira Ayuso < pablo@eurodev.net>
  *
  * Initial netfilter messages via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -31,7 +32,6 @@
 #include <net/sock.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <linux/list.h>
 
 #include <linux/netfilter.h>
 #include <linux/netlink.h>
@@ -39,7 +39,7 @@
 
 MODULE_LICENSE("GPL");
 
-static char __initdata nfversion[] = "0.12";
+static char __initdata nfversion[] = "0.20";
 
 #if 1
 #define DEBUGP printk
@@ -48,38 +48,19 @@
 #endif
 
 static struct sock *nfnl = NULL;
-static LIST_HEAD(subsys_list);
 static struct nfnetlink_subsystem *subsys_table[NFNL_SUBSYS_COUNT];
 DECLARE_MUTEX(nfnl_sem);
 
 void nfnl_lock(void)
 {
 	nfnl_shlock();
-	nfnl_exlock();
 }
 
 void nfnl_unlock(void)
 {
-	nfnl_exunlock();
 	nfnl_shunlock();
 }
 
-struct nfnetlink_subsystem *nfnetlink_subsys_alloc(int cb_count)
-{
-	int size;
-	struct nfnetlink_subsystem *ss;
-
-	size = sizeof(struct nfnetlink_subsystem)
-		+ (cb_count * sizeof(struct nfnl_callback));
-
-	ss = kmalloc(size, GFP_KERNEL);
-	if (!ss)
-		return NULL;
-	memset(ss, 0, size);
-
-	return ss;
-}
-
 int nfnetlink_subsys_register(struct nfnetlink_subsystem *n)
 {
 	DEBUGP("registering subsystem ID %u\n", n->subsys_id);
@@ -89,7 +70,6 @@
 		return -1;
 
 	nfnl_lock();
-	list_add(&n->list, &subsys_list);
 	subsys_table[n->subsys_id] = n;
 	nfnl_unlock();
 
@@ -102,30 +82,33 @@
 
 	nfnl_lock();
 	subsys_table[n->subsys_id] = NULL;
-	list_del(&n->list);
 	nfnl_unlock();
 
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
 
-	return &ss->cb[type];
+	return &ss->cb[cb_id];
 }
 
 void __nfa_fill(struct sk_buff *skb, int attrtype, int attrlen,
@@ -162,7 +145,7 @@
  * cda: array of pointers, needs to be at least subsys->attr_count big
  *
  */
-int
+static int
 nfnetlink_check_attributes(struct nfnetlink_subsystem *subsys,
 			   struct nlmsghdr *nlh, struct nfattr *cda[])
 {
@@ -214,6 +197,7 @@
 				    struct nlmsghdr *nlh, int *errp)
 {
 	struct nfnl_callback *nc;
+	struct nfnetlink_subsystem *ss;
 	int type, err = 0;
 
 	DEBUGP("entered; subsys=%u, msgtype=%u\n",
@@ -226,20 +210,18 @@
 		return 0;
 	}
 
-	/* Unknown message: reply with EINVAL */
-	type = nlh->nlmsg_type;
-	if (NFNL_SUBSYS_ID(type) > NFNL_SUBSYS_COUNT) {
-		DEBUGP("subsys_id > subsys_count\n");
-		goto err_inval;
-	}
-
 	/* All the messages must have at least 1 byte length */
 	if (nlh->nlmsg_len < NLMSG_LENGTH(sizeof(struct nfgenmsg))) {
 		DEBUGP("received message was too short\n");
 		return 0;
 	}
 
-	nc = nfnetlink_find_client(type);
+	type = nlh->nlmsg_type;
+	ss = nfnetlink_get_subsys(type);
+	if (!ss)
+		goto err_inval;
+
+	nc = nfnetlink_find_client(type, ss);
 	if (!nc) {
 		DEBUGP("unable to find client for type %d\n", type);
 		goto err_inval;
@@ -252,10 +234,20 @@
 		return -1;
 	}
 
-	err = nc->call(nfnl, skb, nlh, errp);
-	*errp = err;
-	return err;
+	{
+		struct nfattr *cda[ss->attr_count];
 
+		memset(cda, 0, ss->attr_count*sizeof(struct nfattr *));
+		
+		err = nfnetlink_check_attributes(ss, nlh, cda);
+		if (err < 0)
+			goto err_inval;
+
+		err = nc->call(nfnl, skb, nlh, cda, errp);
+		*errp = err;
+		return err;
+	}
+
 err_inval:
 	*errp = -EINVAL;
 	return -1;
@@ -323,12 +315,8 @@
 
 int __init nfnetlink_init(void)
 {
-	int i;
 	printk("Netfilter messages via NETLINK v%s.\n", nfversion);
 
-	for (i = 0; i < NFNL_SUBSYS_COUNT; i++)
-		subsys_table[i] = NULL;
-
 	nfnl = netlink_kernel_create(NETLINK_NETFILTER, nfnetlink_rcv);
 	if (!nfnl) {
 		printk(KERN_ERR "cannot initialize nfnetlink!\n");
@@ -341,9 +329,8 @@
 module_init(nfnetlink_init);
 module_exit(nfnetlink_exit);
 
-EXPORT_SYMBOL_GPL(nfnetlink_subsys_alloc);
 EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
 EXPORT_SYMBOL_GPL(nfnetlink_subsys_unregister);
-EXPORT_SYMBOL_GPL(nfnetlink_check_attributes);
 EXPORT_SYMBOL_GPL(nfnetlink_send);
+EXPORT_SYMBOL_GPL(nfattr_parse);
 EXPORT_SYMBOL_GPL(__nfa_fill);

--------------010704040006060405000406--

From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/22]: nfnetlink: use mutex instead of semaphore
Date: Wed, 14 Mar 2007 09:50:23 +0100 (MET)
Message-ID: <20070314085008.15282.7041.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink: use mutex instead of semaphore

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d61dcfb467bf886f404643585b36317fc2be7254
tree 366fde24982c43ff86f8f6fb3c78bcebf55931ef
parent e4cfced6765b323aaf85882448deef3008a2e204
author Patrick McHardy <kaber@trash.net> Thu, 08 Mar 2007 18:24:47 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:29:39 +0100

 include/linux/netfilter/nfnetlink.h          |   13 ----------
 include/net/netfilter/nf_conntrack_l3proto.h |    5 +---
 net/netfilter/nfnetlink.c                    |   35 ++++++++++++++++++--------
 3 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 1e9c821..6179648 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -129,19 +129,6 @@ #define NFA_PUT(skb, attrtype, attrlen, 
 ({ if (skb_tailroom(skb) < (int)NFA_SPACE(attrlen)) goto nfattr_failure; \
    __nfa_fill(skb, attrtype, attrlen, data); })
 
-extern struct semaphore nfnl_sem;
-
-#define nfnl_shlock()		down(&nfnl_sem)
-#define nfnl_shlock_nowait()	down_trylock(&nfnl_sem)
-
-#define nfnl_shunlock()		do { up(&nfnl_sem); \
-				     if(nfnl && nfnl->sk_receive_queue.qlen) \
-					    nfnl->sk_data_ready(nfnl, 0); \
-                        	} while(0)
-
-extern void nfnl_lock(void);
-extern void nfnl_unlock(void);
-
 extern int nfnetlink_subsys_register(struct nfnetlink_subsystem *n);
 extern int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n);
 
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index eb575cb..f32f714 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -90,10 +90,7 @@ extern struct nf_conntrack_l3proto *nf_c
 /* Protocol registration. */
 extern int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto);
 extern void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto);
-
-extern struct nf_conntrack_l3proto *
-nf_ct_l3proto_find_get(u_int16_t l3proto);
-
+extern struct nf_conntrack_l3proto *nf_ct_l3proto_find_get(u_int16_t l3proto);
 extern void nf_ct_l3proto_put(struct nf_conntrack_l3proto *p);
 
 /* Existing built-in protocols */
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index bf23e48..7865a47 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -28,6 +28,7 @@ #include <linux/skbuff.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <net/sock.h>
+#include <net/netlink.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 
@@ -51,16 +52,28 @@ #endif
 
 static struct sock *nfnl = NULL;
 static struct nfnetlink_subsystem *subsys_table[NFNL_SUBSYS_COUNT];
-DECLARE_MUTEX(nfnl_sem);
+static DEFINE_MUTEX(nfnl_mutex);
 
-void nfnl_lock(void)
+static void nfnl_lock(void)
 {
-	nfnl_shlock();
+	mutex_lock(&nfnl_mutex);
 }
 
-void nfnl_unlock(void)
+static int nfnl_trylock(void)
 {
-	nfnl_shunlock();
+	return !mutex_trylock(&nfnl_mutex);
+}
+
+static void __nfnl_unlock(void)
+{
+	mutex_unlock(&nfnl_mutex);
+}
+
+static void nfnl_unlock(void)
+{
+	mutex_unlock(&nfnl_mutex);
+	if (nfnl->sk_receive_queue.qlen)
+		nfnl->sk_data_ready(nfnl, 0);
 }
 
 int nfnetlink_subsys_register(struct nfnetlink_subsystem *n)
@@ -248,11 +261,11 @@ static int nfnetlink_rcv_msg(struct sk_b
 	ss = nfnetlink_get_subsys(type);
 	if (!ss) {
 #ifdef CONFIG_KMOD
-		/* don't call nfnl_shunlock, since it would reenter
+		/* don't call nfnl_unlock, since it would reenter
 		 * with further packet processing */
-		up(&nfnl_sem);
+		__nfnl_unlock();
 		request_module("nfnetlink-subsys-%d", NFNL_SUBSYS_ID(type));
-		nfnl_shlock();
+		nfnl_lock();
 		ss = nfnetlink_get_subsys(type);
 		if (!ss)
 #endif
@@ -322,7 +335,7 @@ static void nfnetlink_rcv(struct sock *s
 	do {
 		struct sk_buff *skb;
 
-		if (nfnl_shlock_nowait())
+		if (nfnl_trylock())
 			return;
 
 		while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
@@ -337,9 +350,9 @@ static void nfnetlink_rcv(struct sock *s
 			kfree_skb(skb);
 		}
 
-		/* don't call nfnl_shunlock, since it would reenter
+		/* don't call nfnl_unlock, since it would reenter
 		 * with further packet processing */
-		up(&nfnl_sem);
+		__nfnl_unlock();
 	} while(nfnl && nfnl->sk_receive_queue.qlen);
 }
 

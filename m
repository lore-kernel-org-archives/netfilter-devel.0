From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/6] remove nfnl_[shlock|shunlock] functions
Date: Thu, 15 Feb 2007 04:22:55 +0100
Message-ID: <45D3D20F.3090409@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020707080900090802020105"
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
--------------020707080900090802020105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Use nfnl_[lock|unlock] instead

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020707080900090802020105
Content-Type: text/plain;
 name="02.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.patch"

[PATCH] remove nfnl_[shlock|shunlock] functions

Use nfnl_[lock|unlock] instead

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nfnetlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nfnetlink.c	2007-02-15 02:54:51.000000000 +0100
+++ net-2.6.git/net/netfilter/nfnetlink.c	2007-02-15 03:03:17.000000000 +0100
@@ -46,16 +46,6 @@ static struct sock *nfnl = NULL;
 static struct nfnetlink_subsystem *subsys_table[NFNL_SUBSYS_COUNT];
 DECLARE_MUTEX(nfnl_sem);
 
-void nfnl_lock(void)
-{
-	nfnl_shlock();
-}
-
-void nfnl_unlock(void)
-{
-	nfnl_shunlock();
-}
-
 int nfnetlink_subsys_register(struct nfnetlink_subsystem *n)
 {
 	nfnl_lock();
@@ -224,11 +214,11 @@ static int nfnetlink_rcv_msg(struct sk_b
 	ss = nfnetlink_get_subsys(type);
 	if (!ss) {
 #ifdef CONFIG_KMOD
-		/* don't call nfnl_shunlock, since it would reenter
+		/* don't call nfnl_unlock, since it would reenter
 		 * with further packet processing */
 		up(&nfnl_sem);
 		request_module("nfnetlink-subsys-%d", NFNL_SUBSYS_ID(type));
-		nfnl_shlock();
+		nfnl_lock();
 		ss = nfnetlink_get_subsys(type);
 		if (!ss)
 #endif
@@ -294,7 +284,7 @@ static void nfnetlink_rcv(struct sock *s
 	do {
 		struct sk_buff *skb;
 
-		if (nfnl_shlock_nowait())
+		if (nfnl_lock_nowait())
 			return;
 
 		while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
@@ -309,7 +299,7 @@ static void nfnetlink_rcv(struct sock *s
 			kfree_skb(skb);
 		}
 
-		/* don't call nfnl_shunlock, since it would reenter
+		/* don't call nfnl_unlock, since it would reenter
 		 * with further packet processing */
 		up(&nfnl_sem);
 	} while(nfnl && nfnl->sk_receive_queue.qlen);
Index: net-2.6.git/include/linux/netfilter/nfnetlink.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nfnetlink.h	2007-02-15 02:51:43.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/nfnetlink.h	2007-02-15 03:03:37.000000000 +0100
@@ -131,17 +131,14 @@ extern void __nfa_fill(struct sk_buff *s
 
 extern struct semaphore nfnl_sem;
 
-#define nfnl_shlock()		down(&nfnl_sem)
-#define nfnl_shlock_nowait()	down_trylock(&nfnl_sem)
+#define nfnl_lock()		down(&nfnl_sem)
+#define nfnl_lock_nowait()	down_trylock(&nfnl_sem)
 
-#define nfnl_shunlock()		do { up(&nfnl_sem); \
+#define nfnl_unlock()		do { up(&nfnl_sem); \
 				     if(nfnl && nfnl->sk_receive_queue.qlen) \
 					    nfnl->sk_data_ready(nfnl, 0); \
                         	} while(0)
 
-extern void nfnl_lock(void);
-extern void nfnl_unlock(void);
-
 extern int nfnetlink_subsys_register(struct nfnetlink_subsystem *n);
 extern int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n);
 

--------------020707080900090802020105--

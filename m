From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/7] remove nfnl_[lock|unlock] functions
Date: Mon, 12 Feb 2007 23:46:03 +0100
Message-ID: <45D0EE2B.5070004@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000105030704050103050905"
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
--------------000105030704050103050905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Use nfnl_shlock instead

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------000105030704050103050905
Content-Type: text/plain;
 name="02.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.patch"

[PATCH] remove nfnl_[lock|unlock] functions

Use nfnl_shlock instead

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nfnetlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nfnetlink.c	2006-12-26 04:32:54.000000000 +0100
+++ net-2.6.git/net/netfilter/nfnetlink.c	2007-01-19 19:34:48.000000000 +0100
@@ -46,34 +46,24 @@ static struct sock *nfnl = NULL;
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
-	nfnl_lock();
+	nfnl_shlock();
 	if (subsys_table[n->subsys_id]) {
-		nfnl_unlock();
+		nfnl_shunlock();
 		return -EBUSY;
 	}
 	subsys_table[n->subsys_id] = n;
-	nfnl_unlock();
+	nfnl_shunlock();
 
 	return 0;
 }
 
 int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n)
 {
-	nfnl_lock();
+	nfnl_shlock();
 	subsys_table[n->subsys_id] = NULL;
-	nfnl_unlock();
+	nfnl_shunlock();
 
 	return 0;
 }
Index: net-2.6.git/include/linux/netfilter/nfnetlink.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nfnetlink.h	2007-01-19 19:34:59.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/nfnetlink.h	2007-01-19 19:35:43.000000000 +0100
@@ -139,9 +139,6 @@ extern struct semaphore nfnl_sem;
 					    nfnl->sk_data_ready(nfnl, 0); \
                         	} while(0)
 
-extern void nfnl_lock(void);
-extern void nfnl_unlock(void);
-
 extern int nfnetlink_subsys_register(struct nfnetlink_subsystem *n);
 extern int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n);
 

--------------000105030704050103050905--

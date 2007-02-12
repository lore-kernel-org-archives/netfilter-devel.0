From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/22]: nf_log: switch logger
	registration/unregistration to mutex
Date: Mon, 12 Feb 2007 11:36:31 +0100 (MET)
Message-ID: <20070212103630.661.56704.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_log: switch logger registration/unregistration to mutex

The spinlock is only used in process context (register/unregister),
switch to a mutex.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 99c46fbd857a8a2d01987650bd1492b5379ac250
tree c91f6d98b4d9035255bf89e8153745eec7cb9349
parent ca4c6357b4568c1b8644385828a542475a86c5fa
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:37:13 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:37:13 +0100

 net/netfilter/nf_log.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index c159ef9..b942cd5 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -15,27 +15,31 @@ #include "nf_internals.h"
 #define NF_LOG_PREFIXLEN		128
 
 static struct nf_logger *nf_logging[NPROTO]; /* = NULL */
-static DEFINE_SPINLOCK(nf_log_lock);
+static DEFINE_MUTEX(nf_log_mutex);
 
 /* return EBUSY if somebody else is registered, EEXIST if the same logger
  * is registred, 0 on success. */
 int nf_log_register(int pf, struct nf_logger *logger)
 {
-	int ret = -EBUSY;
+	int ret;
 
 	if (pf >= NPROTO)
 		return -EINVAL;
 
 	/* Any setup of logging members must be done before
 	 * substituting pointer. */
-	spin_lock(&nf_log_lock);
-	if (!nf_logging[pf]) {
+	ret = mutex_lock_interruptible(&nf_log_mutex);
+	if (ret < 0)
+		return ret;
+
+	if (!nf_logging[pf])
 		rcu_assign_pointer(nf_logging[pf], logger);
-		ret = 0;
-	} else if (nf_logging[pf] == logger)
+	else if (nf_logging[pf] == logger)
 		ret = -EEXIST;
+	else
+		ret = -EBUSY;
 
-	spin_unlock(&nf_log_lock);
+	mutex_unlock(&nf_log_mutex);
 	return ret;
 }		
 EXPORT_SYMBOL(nf_log_register);
@@ -44,9 +48,9 @@ void nf_log_unregister_pf(int pf)
 {
 	if (pf >= NPROTO)
 		return;
-	spin_lock(&nf_log_lock);
+	mutex_lock(&nf_log_mutex);
 	rcu_assign_pointer(nf_logging[pf], NULL);
-	spin_unlock(&nf_log_lock);
+	mutex_unlock(&nf_log_mutex);
 
 	/* Give time to concurrent readers. */
 	synchronize_rcu();
@@ -57,12 +61,12 @@ void nf_log_unregister_logger(struct nf_
 {
 	int i;
 
-	spin_lock(&nf_log_lock);
+	mutex_lock(&nf_log_mutex);
 	for (i = 0; i < NPROTO; i++) {
 		if (nf_logging[i] == logger)
 			rcu_assign_pointer(nf_logging[i], NULL);
 	}
-	spin_unlock(&nf_log_lock);
+	mutex_unlock(&nf_log_mutex);
 
 	synchronize_rcu();
 }

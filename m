From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/22]: nf_log: make nf_log_unregister_pf return void
Date: Mon, 12 Feb 2007 11:36:29 +0100 (MET)
Message-ID: <20070212103629.661.62843.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_log: make nf_log_unregister_pf return void

Since the only user of nf_log_unregister_pf (nfnetlink_log) doesn't
check the return value, change it to void and bail out silently when
a non-existant address family is supplied.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ca4c6357b4568c1b8644385828a542475a86c5fa
tree f5068e54682875208ff5d05cf7af434094daf545
parent a3d379f952d0861a1e0d876f69f301d5174f7990
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:37:02 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:37:02 +0100

 include/linux/netfilter.h |    2 +-
 net/netfilter/nf_log.c    |    7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d4c4c51..18a6790 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -172,7 +172,7 @@ struct nf_logger {
 
 /* Function to register/unregister log function. */
 int nf_log_register(int pf, struct nf_logger *logger);
-int nf_log_unregister_pf(int pf);
+void nf_log_unregister_pf(int pf);
 void nf_log_unregister_logger(struct nf_logger *logger);
 
 /* Calls the registered backend logging function */
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index d6c6a8d..c159ef9 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -40,19 +40,16 @@ int nf_log_register(int pf, struct nf_lo
 }		
 EXPORT_SYMBOL(nf_log_register);
 
-int nf_log_unregister_pf(int pf)
+void nf_log_unregister_pf(int pf)
 {
 	if (pf >= NPROTO)
-		return -EINVAL;
-
+		return;
 	spin_lock(&nf_log_lock);
 	rcu_assign_pointer(nf_logging[pf], NULL);
 	spin_unlock(&nf_log_lock);
 
 	/* Give time to concurrent readers. */
 	synchronize_rcu();
-
-	return 0;
 }
 EXPORT_SYMBOL(nf_log_unregister_pf);
 

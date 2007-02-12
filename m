From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/22]: nf_log: use rcu_assign_pointer for RCU protected
	pointer
Date: Mon, 12 Feb 2007 11:36:28 +0100 (MET)
Message-ID: <20070212103628.661.34878.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_log: use rcu_assign_pointer for RCU protected pointer

Also replace synchronize_net() calls by synchronize_rcu() since the
RCU protected data is also used for sysfs.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a3d379f952d0861a1e0d876f69f301d5174f7990
tree 2f439287b3e9388ef7f186ea108868a05f119f4d
parent 4694a2599998f08af77aa1a1ee2c6d6bc2020913
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:36:34 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:36:34 +0100

 net/netfilter/nf_log.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 8901b3a..d6c6a8d 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -46,11 +46,11 @@ int nf_log_unregister_pf(int pf)
 		return -EINVAL;
 
 	spin_lock(&nf_log_lock);
-	nf_logging[pf] = NULL;
+	rcu_assign_pointer(nf_logging[pf], NULL);
 	spin_unlock(&nf_log_lock);
 
 	/* Give time to concurrent readers. */
-	synchronize_net();
+	synchronize_rcu();
 
 	return 0;
 }
@@ -63,11 +63,11 @@ void nf_log_unregister_logger(struct nf_
 	spin_lock(&nf_log_lock);
 	for (i = 0; i < NPROTO; i++) {
 		if (nf_logging[i] == logger)
-			nf_logging[i] = NULL;
+			rcu_assign_pointer(nf_logging[i], NULL);
 	}
 	spin_unlock(&nf_log_lock);
 
-	synchronize_net();
+	synchronize_rcu();
 }
 EXPORT_SYMBOL(nf_log_unregister_logger);
 

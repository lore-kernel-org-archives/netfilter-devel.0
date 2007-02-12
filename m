From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/22]: Switch nf_register_afinfo/nf_unregister_afinfo
	to mutex
Date: Mon, 12 Feb 2007 11:36:25 +0100 (MET)
Message-ID: <20070212103625.661.53600.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Switch nf_register_afinfo/nf_unregister_afinfo to mutex

The spinlock is only used in process context (register/unregister),
switch to a mutex.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ccead672bf5800d7418940aea9c0e6a231bc1f09
tree 9908ac59b324b764b4e7caaf17dc8472df8e52d9
parent 4e6bba5661fe72e2c570701be4fcf4f2fabfdff2
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:36:15 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:36:15 +0100

 net/netfilter/core.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index a66bd6a..716603f 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -22,29 +22,34 @@ #include <linux/if.h>
 #include <linux/netdevice.h>
 #include <linux/inetdevice.h>
 #include <linux/proc_fs.h>
+#include <linux/mutex.h>
 #include <net/sock.h>
 
 #include "nf_internals.h"
 
-static DEFINE_SPINLOCK(afinfo_lock);
+static DEFINE_MUTEX(afinfo_mutex);
 
 struct nf_afinfo *nf_afinfo[NPROTO] __read_mostly;
 EXPORT_SYMBOL(nf_afinfo);
 
 int nf_register_afinfo(struct nf_afinfo *afinfo)
 {
-	spin_lock(&afinfo_lock);
+	int err;
+
+	err = mutex_lock_interruptible(&afinfo_mutex);
+	if (err < 0)
+		return err;
 	rcu_assign_pointer(nf_afinfo[afinfo->family], afinfo);
-	spin_unlock(&afinfo_lock);
+	mutex_unlock(&afinfo_mutex);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_register_afinfo);
 
 void nf_unregister_afinfo(struct nf_afinfo *afinfo)
 {
-	spin_lock(&afinfo_lock);
+	mutex_lock(&afinfo_mutex);
 	rcu_assign_pointer(nf_afinfo[afinfo->family], NULL);
-	spin_unlock(&afinfo_lock);
+	mutex_unlock(&afinfo_mutex);
 	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(nf_unregister_afinfo);

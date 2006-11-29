From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/33]: More __read_mostly annotations
Date: Wed, 29 Nov 2006 03:08:51 +0100 (MET)
Message-ID: <20061129020851.21082.30948.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: More __read_mostly annotations

Place rarely written variables in the read-mostly section by using
__read_mostly

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit aa38f56fd93eda7cab344eb237951108eff1b3bc
tree e4727b1eeac5a5f86e3e867e8b47aa9228ea9d38
parent d27a49059250fc2676533e533fcbe77de3b8b112
author Martin Josefsson <gandalf@wlug.westbo.se> Tue, 28 Nov 2006 23:12:56 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:12:56 +0100

 net/netfilter/core.c                |    4 ++--
 net/netfilter/nf_conntrack_core.c   |    4 ++--
 net/netfilter/nf_conntrack_helper.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 17f9e1c..291b8c6 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -28,7 +28,7 @@ #include "nf_internals.h"
 
 static DEFINE_SPINLOCK(afinfo_lock);
 
-struct nf_afinfo *nf_afinfo[NPROTO];
+struct nf_afinfo *nf_afinfo[NPROTO] __read_mostly;
 EXPORT_SYMBOL(nf_afinfo);
 
 int nf_register_afinfo(struct nf_afinfo *afinfo)
@@ -54,7 +54,7 @@ EXPORT_SYMBOL_GPL(nf_unregister_afinfo);
  * of skbuffs queued for userspace, and not deregister a hook unless
  * this is zero, but that sucks.  Now, we simply check when the
  * packets come back: if the hook is gone, the packet is discarded. */
-struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
+struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS] __read_mostly;
 EXPORT_SYMBOL(nf_hooks);
 static DEFINE_SPINLOCK(nf_hook_lock);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 09c0e63..6607ed4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -73,10 +73,10 @@ DEFINE_RWLOCK(nf_conntrack_lock);
 atomic_t nf_conntrack_count = ATOMIC_INIT(0);
 
 void (*nf_conntrack_destroyed)(struct nf_conn *conntrack) = NULL;
-unsigned int nf_conntrack_htable_size __read_mostly = 0;
+unsigned int nf_conntrack_htable_size __read_mostly;
 int nf_conntrack_max __read_mostly;
 struct list_head *nf_conntrack_hash __read_mostly;
-struct nf_conn nf_conntrack_untracked;
+struct nf_conn nf_conntrack_untracked __read_mostly;
 unsigned int nf_ct_log_invalid __read_mostly;
 LIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc __read_mostly;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ca04487..2af9220 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -30,7 +30,7 @@ #include <net/netfilter/nf_conntrack_pro
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
-static LIST_HEAD(helpers);
+static __read_mostly LIST_HEAD(helpers);
 
 struct nf_conntrack_helper *
 __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)

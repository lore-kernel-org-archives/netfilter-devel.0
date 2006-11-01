From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 05/11] More __read_mostly
Date: Wed, 01 Nov 2006 22:08:50 +0100
Message-ID: <20061101210913.710751547@wlug.westbo.se>
References: <20061101210845.337590368@wlug.westbo.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline; filename=readmostly
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

Place rarely written variables in the read-mostly section by using __read_mostly

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

---
 net/netfilter/core.c                |    4 ++--
 net/netfilter/nf_conntrack_core.c   |    4 ++--
 net/netfilter/nf_conntrack_helper.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_core.c	2006-11-01 21:39:50.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c	2006-11-01 21:39:51.000000000 +0100
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
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_helper.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_helper.c	2006-11-01 21:39:48.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_helper.c	2006-11-01 21:39:51.000000000 +0100
@@ -30,7 +30,7 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
-static LIST_HEAD(helpers);
+static struct list_head helpers __read_mostly = { &(helpers), &(helpers) };
 
 struct nf_conntrack_helper *
 __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/core.c
===================================================================
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/core.c	2006-11-01 21:38:55.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/core.c	2006-11-01 21:39:51.000000000 +0100
@@ -28,7 +28,7 @@
 
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
 

--
/Martin

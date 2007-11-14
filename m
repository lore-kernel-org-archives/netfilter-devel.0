From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH V2] NETFILTER: replace list_for_each with list_for_each_entry
Date: Wed, 14 Nov 2007 15:18:46 +0800
Message-ID: <473AA156.9080600@cn.fujitsu.com>
References: <473A6490.1000704@cn.fujitsu.com> <473A9A21.6030000@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:51210 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbXKNHVO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2007 02:21:14 -0500
In-Reply-To: <473A9A21.6030000@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


This patch replaces list_for_each with list_for_each_entry, and
consequently fixes a bug too.

Things like this is wrong:

	list_for_each(i, &nf_sockopts) {
		struct nf_sockopt_ops *ops = (struct nf_sockopt_ops *)i;

It makes the assumption that list is the first member of struct
nf_sockopt_ops, so the ptr casting works. But if one day the structure
changes, for example, like this:

	struct nf_sockopt_ops {
		foo_t a_new_member;
		struct list_head list;
	};

Then we get corrupted data.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    6 ++----
 net/netfilter/core.c               |    8 ++++----
 net/netfilter/nf_sockopt.c         |   13 ++++---------
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 2f544da..311361e 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -109,11 +109,9 @@ clusterip_config_entry_put(struct clusterip_config *c)
 static struct clusterip_config *
 __clusterip_config_find(__be32 clusterip)
 {
-	struct list_head *pos;
+	struct clusterip_config *c;
 
-	list_for_each(pos, &clusterip_configs) {
-		struct clusterip_config *c = list_entry(pos,
-					struct clusterip_config, list);
+	list_for_each_entry(c, &clusterip_configs, list) {
 		if (c->clusterip == clusterip)
 			return c;
 	}
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index bed9ba0..ed58922 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -62,17 +62,17 @@ static DEFINE_MUTEX(nf_hook_mutex);
 
 int nf_register_hook(struct nf_hook_ops *reg)
 {
-	struct list_head *i;
+	struct nf_hook_ops *elem;
 	int err;
 
 	err = mutex_lock_interruptible(&nf_hook_mutex);
 	if (err < 0)
 		return err;
-	list_for_each(i, &nf_hooks[reg->pf][reg->hooknum]) {
-		if (reg->priority < ((struct nf_hook_ops *)i)->priority)
+	list_for_each_entry(elem, &nf_hooks[reg->pf][reg->hooknum], list) {
+		if (reg->priority < elem->priority)
 			break;
 	}
-	list_add_rcu(&reg->list, i->prev);
+	list_add_rcu(&reg->list, elem->list.prev);
 	mutex_unlock(&nf_hook_mutex);
 	return 0;
 }
diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index aa28315..2dfac32 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -23,14 +23,13 @@ static inline int overlap(int min1, int max1, int min2, int max2)
 /* Functions to register sockopt ranges (exclusive). */
 int nf_register_sockopt(struct nf_sockopt_ops *reg)
 {
-	struct list_head *i;
+	struct nf_sockopt_ops *ops;
 	int ret = 0;
 
 	if (mutex_lock_interruptible(&nf_sockopt_mutex) != 0)
 		return -EINTR;
 
-	list_for_each(i, &nf_sockopts) {
-		struct nf_sockopt_ops *ops = (struct nf_sockopt_ops *)i;
+	list_for_each_entry(ops, &nf_sockopts, list) {
 		if (ops->pf == reg->pf
 		    && (overlap(ops->set_optmin, ops->set_optmax,
 				reg->set_optmin, reg->set_optmax)
@@ -65,7 +64,6 @@ EXPORT_SYMBOL(nf_unregister_sockopt);
 static int nf_sockopt(struct sock *sk, int pf, int val,
 		      char __user *opt, int *len, int get)
 {
-	struct list_head *i;
 	struct nf_sockopt_ops *ops;
 	int ret;
 
@@ -75,8 +73,7 @@ static int nf_sockopt(struct sock *sk, int pf, int val,
 	if (mutex_lock_interruptible(&nf_sockopt_mutex) != 0)
 		return -EINTR;
 
-	list_for_each(i, &nf_sockopts) {
-		ops = (struct nf_sockopt_ops *)i;
+	list_for_each_entry(ops, &nf_sockopts, list) {
 		if (ops->pf == pf) {
 			if (!try_module_get(ops->owner))
 				goto out_nosup;
@@ -124,7 +121,6 @@ EXPORT_SYMBOL(nf_getsockopt);
 static int compat_nf_sockopt(struct sock *sk, int pf, int val,
 			     char __user *opt, int *len, int get)
 {
-	struct list_head *i;
 	struct nf_sockopt_ops *ops;
 	int ret;
 
@@ -135,8 +131,7 @@ static int compat_nf_sockopt(struct sock *sk, int pf, int val,
 	if (mutex_lock_interruptible(&nf_sockopt_mutex) != 0)
 		return -EINTR;
 
-	list_for_each(i, &nf_sockopts) {
-		ops = (struct nf_sockopt_ops *)i;
+	list_for_each_entry(ops, &nf_sockopts, list) {
 		if (ops->pf == pf) {
 			if (!try_module_get(ops->owner))
 				goto out_nosup;
-- 
1.5.3.rc7


From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] NETFILTER: replace list_for_each with list_for_each_entry
Date: Wed, 14 Nov 2007 10:59:28 +0800
Message-ID: <473A6490.1000704@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:51663 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbXKNDCE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:02:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Replace list_for_each with list_for_each_entry when possible.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    6 ++----
 net/netfilter/nf_sockopt.c         |    8 ++------
 2 files changed, 4 insertions(+), 10 deletions(-)

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
diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index aa28315..06bbccb 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -65,7 +65,6 @@ EXPORT_SYMBOL(nf_unregister_sockopt);
 static int nf_sockopt(struct sock *sk, int pf, int val,
 		      char __user *opt, int *len, int get)
 {
-	struct list_head *i;
 	struct nf_sockopt_ops *ops;
 	int ret;
 
@@ -75,8 +74,7 @@ static int nf_sockopt(struct sock *sk, int pf, int val,
 	if (mutex_lock_interruptible(&nf_sockopt_mutex) != 0)
 		return -EINTR;
 
-	list_for_each(i, &nf_sockopts) {
-		ops = (struct nf_sockopt_ops *)i;
+	list_for_each_entry(ops, &nf_sockopts, list) {
 		if (ops->pf == pf) {
 			if (!try_module_get(ops->owner))
 				goto out_nosup;
@@ -124,7 +122,6 @@ EXPORT_SYMBOL(nf_getsockopt);
 static int compat_nf_sockopt(struct sock *sk, int pf, int val,
 			     char __user *opt, int *len, int get)
 {
-	struct list_head *i;
 	struct nf_sockopt_ops *ops;
 	int ret;
 
@@ -135,8 +132,7 @@ static int compat_nf_sockopt(struct sock *sk, int pf, int val,
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


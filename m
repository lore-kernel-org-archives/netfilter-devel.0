From: Alexey Dobriyan <adobriyan@sw.ru>
Subject: [PATCH] nf_sockopts list head cleanup
Date: Mon, 22 Oct 2007 16:19:05 +0400
Message-ID: <20071022121905.GC6271@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, devel@openvz.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:7104 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXJVMTj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:19:39 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Code is using knowledge that nf_sockopt_ops::list list_head is first
field in structure by using casts. Switch to list_for_each_entry()
itetators while I am at it.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 net/netfilter/nf_sockopt.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

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
@@ -135,8 +132,7 @@ static int compat_nf_sockopt(struct sock *sk, int pf, int val,
 	if (mutex_lock_interruptible(&nf_sockopt_mutex) != 0)
 		return -EINTR;
 
-	list_for_each(i, &nf_sockopts) {
-		ops = (struct nf_sockopt_ops *)i;
+	list_for_each_entry(ops, &nf_sockopts, list) {
 		if (ops->pf == pf) {
 			if (!try_module_get(ops->owner))
 				goto out_nosup;


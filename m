From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/07]: nf_sockopts list head cleanup
Date: Fri,  2 Nov 2007 12:23:18 +0100 (MET)
Message-ID: <20071102112008.22803.12783.sendpatchset@localhost.localdomain>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45743 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbXKBLXT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Nov 2007 07:23:19 -0400
In-Reply-To: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_sockopts list head cleanup

Code is using knowledge that nf_sockopt_ops::list list_head is first
field in structure by using casts. Switch to list_for_each_entry()
itetators while I am at it.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 430f032387ee5ed1babaac827c116493d79217d8
tree f75f080c68c90d3c879dbaba73aa3e136e88f4ef
parent 04a6b70568aa679cdce548f4edaac0a668440c60
author Alexey Dobriyan <adobriyan@sw.ru> Fri, 02 Nov 2007 11:58:58 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 02 Nov 2007 11:58:58 +0100

 net/netfilter/nf_sockopt.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

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

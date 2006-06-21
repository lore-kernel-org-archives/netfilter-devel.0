From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: [PATCH] priv_data (formerly entry_data)
Date: Wed, 21 Jun 2006 02:33:53 +0200
Message-ID: <200606210233.55724.max@nucleus.it>
References: <200606050029.08602.max@nucleus.it> <4497F561.4000503@trash.net>
	<200606210203.33209.max@nucleus.it>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_zPJmEXirRNwntTo"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200606210203.33209.max@nucleus.it>
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

--Boundary-00=_zPJmEXirRNwntTo
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
this is an example of how condition works with priv_data.

This is a patch against the new version of condition for kernel version 2.6.17 
(available on the repository).

-- 
Saluti,
   Massimiliano Hofer

--Boundary-00=_zPJmEXirRNwntTo
Content-Type: text/x-diff; charset="utf-8"; name="condition-priv_data.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="condition-priv_data.patch"

diff -Nru linux-2.6.17/net/netfilter/xt_condition.c linux-2.6.17-priv_data/net/netfilter/xt_condition.c
--- linux-2.6.17/net/netfilter/xt_condition.c	2006-06-21 02:26:18.000000000 +0200
+++ linux-2.6.17-priv_data/net/netfilter/xt_condition.c	2006-06-21 02:25:02.000000000 +0200
@@ -116,31 +116,25 @@
 
 static int
 match(const struct sk_buff *skb, const struct net_device *in,
-      const struct net_device *out, const void *matchinfo, int offset,
-      unsigned int protoff, int *hotdrop)
+      const struct net_device *out, const struct xt_match *match,
+      const void *matchinfo, int offset,
+      unsigned int protoff, int *hotdrop, void *priv_data)
 {
 	const struct condition_info *info =
-	    (const struct condition_info *) matchinfo;
-	struct condition_variable *var;
-	int condition_status = 0;
+		(const struct condition_info *) matchinfo;
+	struct condition_variable *var=
+		*(struct condition_variable **)priv_data;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(var, &conditions_list, list) {
-		if (strcmp(info->name, var->status_proc->name) == 0) {
-			condition_status = var->enabled;
-			break;
-		}
-	}
-	rcu_read_unlock();
-
-	return condition_status ^ info->invert;
+	return var->enabled ^ info->invert;
 }
 
 
 
 static int
 checkentry(const char *tablename, const void *ip,
-	   void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
+	   const struct xt_match *match,
+	   void *matchinfo, unsigned int matchsize,
+	   unsigned int hook_mask, void *priv_data)
 {
 	static const char * const forbidden_names[]={ "", ".", ".." };
 	struct condition_info *info = (struct condition_info *) matchinfo;
@@ -172,6 +166,7 @@
 		var = list_entry(pos, struct condition_variable, list);
 		if (strcmp(info->name, var->status_proc->name) == 0) {
 			var->refcount++;
+			*(struct condition_variable **)priv_data=var;
 			up(&proc_lock);
 			return 1;
 		}
@@ -209,35 +204,34 @@
 
 	up(&proc_lock);
 
+	*(struct condition_variable **)priv_data=newvar;
+
 	return 1;
 }
 
 
 static void
-destroy(void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo,
+	unsigned int matchsize, void *priv_data)
 {
-	struct condition_info *info = (struct condition_info *) matchinfo;
-	struct list_head *pos;
-	struct condition_variable *var;
+	struct condition_variable *var=
+		*(struct condition_variable **)priv_data;
+
+	BUG_ON(priv_data==NULL);
+	BUG_ON(priv_var==NULL);
 
 	down(&proc_lock);
 
-	list_for_each(pos, &conditions_list) {
-		var = list_entry(pos, struct condition_variable, list);
-		if (strcmp(info->name, var->status_proc->name) == 0) {
-			if (--var->refcount == 0) {
-				list_del_rcu(pos);
-				remove_proc_entry(var->status_proc->name, proc_net_condition);
-				up(&proc_lock);
-				/* synchronize_rcu() would be goog enough, but synchronize_net() */
-				/* guarantees that no packet will go out with the old rule after */
-				/* succesful removal.                                            */
-				synchronize_net();
-				kfree(var);
-				return;
-			}
-			break;
-		}
+	if (--var->refcount == 0) {
+		list_del_rcu(&var->list);
+		remove_proc_entry(var->status_proc->name, proc_net_condition);
+		up(&proc_lock);
+		/* synchronize_rcu() would be goog enough, but synchronize_net() */
+		/* guarantees that no packet will go out with the old rule after */
+		/* succesful removal.                                            */
+		synchronize_net();
+		kfree(var);
+		return;
 	}
 
 	up(&proc_lock);
@@ -248,6 +242,7 @@
 	.name = "condition",
 	.family = AF_INET,
 	.matchsize = sizeof(struct condition_info),
+	.priv_size = sizeof(struct condition_variable *),
 	.match = &match,
 	.checkentry = &checkentry,
 	.destroy = &destroy,
@@ -258,6 +253,7 @@
 	.name = "condition",
 	.family = AF_INET6,
 	.matchsize = sizeof(struct condition_info),
+	.priv_size = sizeof(struct condition_variable *),
 	.match = &match,
 	.checkentry = &checkentry,
 	.destroy = &destroy,

--Boundary-00=_zPJmEXirRNwntTo--

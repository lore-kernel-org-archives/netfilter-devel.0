From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: [PATCH] entry_data
Date: Mon, 12 Jun 2006 14:45:41 +0200
Message-ID: <200606121445.42157.max@nucleus.it>
References: <200606050029.08602.max@nucleus.it>
	<200606120119.16503.max@nucleus.it> <448D38DA.8000404@us.es>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2HWjEE3r4F0GYvS"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <448D38DA.8000404@us.es>
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

--Boundary-00=_2HWjEE3r4F0GYvS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 12 June 2006 11:50 am, Pablo Neira Ayuso wrote:

> Fine, please next time send an incremental diff so we all can notice the
> changes by having a look at the attachment. Thanks.

OK. Here it is. Some of the changes in this diff are due to the 2.6.17 
porting, but they are minor.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus

--Boundary-00=_2HWjEE3r4F0GYvS
Content-Type: text/x-diff; charset="iso-8859-1";
	name="condition-entry_data.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="condition-entry_data.diff"

diff -Nru linux-2.6.16/net/netfilter/xt_condition.c linux-2.6.17-entry_data/net/netfilter/xt_condition.c
--- linux-2.6.16/net/netfilter/xt_condition.c	2006-04-26 12:07:52.000000000 +0200
+++ linux-2.6.17-entry_data/net/netfilter/xt_condition.c	2006-06-12 01:49:05.000000000 +0200
@@ -116,42 +116,32 @@
 
 static int
 match(const struct sk_buff *skb, const struct net_device *in,
-      const struct net_device *out, const void *matchinfo, int offset,
-      unsigned int protoff, int *hotdrop)
+      const struct net_device *out, const struct xt_match *match,
+      const void *matchinfo, int offset,
+      unsigned int protoff, int *hotdrop, void *entry_data)
 {
 	const struct condition_info *info =
-	    (const struct condition_info *) matchinfo;
-	struct condition_variable *var;
-	int condition_status = 0;
+		(const struct condition_info *) matchinfo;
+	struct condition_variable *var=
+		(struct condition_variable *)entry_data;
 
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
+	   unsigned int hook_mask, void **entry_data)
 {
 	static const char * const forbidden_names[]={ "", ".", ".." };
 	struct condition_info *info = (struct condition_info *) matchinfo;
 	struct list_head *pos;
 	struct condition_variable *var, *newvar;
-
 	int i;
 
-	if (matchsize != XT_ALIGN(sizeof(struct condition_info)))
-		return 0;
-
 	/* We don't want a '/' in a proc file name. */
 	for (i=0; i < CONDITION_NAME_LEN && info->name[i] != '\0'; i++)
 		if (info->name[i] == '/')
@@ -175,6 +165,7 @@
 		var = list_entry(pos, struct condition_variable, list);
 		if (strcmp(info->name, var->status_proc->name) == 0) {
 			var->refcount++;
+			*entry_data=(void *)var;
 			up(&proc_lock);
 			return 1;
 		}
@@ -212,38 +203,34 @@
 
 	up(&proc_lock);
 
+	*entry_data=(void *)newvar;
+
 	return 1;
 }
 
 
 static void
-destroy(void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo,
+	unsigned int matchsize, void *entry_data)
 {
 	struct condition_info *info = (struct condition_info *) matchinfo;
-	struct list_head *pos;
-	struct condition_variable *var;
+	struct condition_variable *var=
+		(struct condition_variable *)entry_data;
 
-	if (matchsize != XT_ALIGN(sizeof(struct condition_info)))
-		return;
+	BUG_ON(entry_data==NULL);
 
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
@@ -252,6 +239,8 @@
 
 static struct xt_match condition_match = {
 	.name = "condition",
+	.family = AF_INET,
+	.matchsize = sizeof(struct condition_info),
 	.match = &match,
 	.checkentry = &checkentry,
 	.destroy = &destroy,
@@ -260,6 +249,8 @@
 
 static struct xt_match condition6_match = {
 	.name = "condition",
+	.family = AF_INET,
+	.matchsize = sizeof(struct condition_info),
 	.match = &match,
 	.checkentry = &checkentry,
 	.destroy = &destroy,
@@ -279,17 +270,17 @@
 		return -EACCES;
 	}
 
-        errorcode = xt_register_match(AF_INET, &condition_match);
+        errorcode = xt_register_match(&condition_match);
 	if (errorcode) {
-		xt_unregister_match(AF_INET, &condition_match);
+		xt_unregister_match(&condition_match);
 		remove_proc_entry(dir_name, proc_net);
 		return errorcode;
 	}
 
-	errorcode = xt_register_match(AF_INET6, &condition6_match);
+	errorcode = xt_register_match(&condition6_match);
 	if (errorcode) {
-		xt_unregister_match(AF_INET6, &condition6_match);
-		xt_unregister_match(AF_INET, &condition_match);
+		xt_unregister_match(&condition6_match);
+		xt_unregister_match(&condition_match);
 		remove_proc_entry(dir_name, proc_net);
 		return errorcode;
 	}
@@ -301,8 +292,8 @@
 static void __exit
 fini(void)
 {
-	xt_unregister_match(AF_INET6, &condition6_match);
-	xt_unregister_match(AF_INET, &condition_match);
+	xt_unregister_match(&condition6_match);
+	xt_unregister_match(&condition_match);
 	remove_proc_entry(dir_name, proc_net);
 }
 

--Boundary-00=_2HWjEE3r4F0GYvS--

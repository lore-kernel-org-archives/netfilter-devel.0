From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 9/18] Netfilter: Clean up the kmod handling code in
	iptables.c
Date: Wed, 5 Jan 2005 19:12:49 +0100
Message-ID: <20050105181249.GS26856@postel.suug.ch>
References: <1104896029.20582.72.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, Linus Torvalds <torvalds@osdl.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Jamal Hadi Salim <hadi@cyberus.ca>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1104896029.20582.72.camel@localhost.localdomain>
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

* Rusty Russell <1104896029.20582.72.camel@localhost.localdomain> 2005-01-05 14:33
> Name: Clean up the kmod handling code in iptables.c
> Status: Tested under nfsim
> 
> 4) Remove __ipt_mutex_up() and __ipt_find_target_lock() which weren't
>    used (even in patch-o-matic AFAICT).

Those are used by ipt action (net/sched/ipt.c).

Readds __ipt_find_target_lock() and __ipt_mutex_up() and adapts ipt.c
to correctly use it. module must be given back properly upon cleanup.
removes the comments demanding for proper module refcnt since
find_target_lock() takes care of this now.

Jamal: Can you please verify?

Signed-off-by: Thomas Graf <tgraf@suug.ch>

diff -Nru linux-2.6.10-bk8.orig/include/linux/netfilter_ipv4/ip_tables.h linux-2.6.10-bk8/include/linux/netfilter_ipv4/ip_tables.h
--- linux-2.6.10-bk8.orig/include/linux/netfilter_ipv4/ip_tables.h	2005-01-05 18:58:14.000000000 +0100
+++ linux-2.6.10-bk8/include/linux/netfilter_ipv4/ip_tables.h	2005-01-05 18:47:43.000000000 +0100
@@ -432,6 +432,9 @@
 extern int ipt_register_match(struct ipt_match *match);
 extern void ipt_unregister_match(struct ipt_match *match);
 
+extern struct ipt_target * __ipt_find_target_lock(const char *name, u8 rev);
+extern void __ipt_mutex_up(void);
+
 /* Furniture shopping... */
 struct ipt_table
 {
diff -Nru linux-2.6.10-bk8.orig/net/ipv4/netfilter/ip_tables.c linux-2.6.10-bk8/net/ipv4/netfilter/ip_tables.c
--- linux-2.6.10-bk8.orig/net/ipv4/netfilter/ip_tables.c	2005-01-05 18:58:14.000000000 +0100
+++ linux-2.6.10-bk8/net/ipv4/netfilter/ip_tables.c	2005-01-05 18:46:33.000000000 +0100
@@ -488,6 +488,16 @@
 	return ERR_PTR(-EPROTOTYPE);
 }
 
+struct ipt_target * __ipt_find_target_lock(const char *name, u8 revision)
+{
+	return find_target_lock(name, revision);
+}
+
+void __ipt_mutex_up(void)
+{
+	up(&ipt_mutex);
+}
+
 static int match_revfn(const char *name, u8 revision, int *bestp)
 {
 	struct ipt_match *m;
@@ -1959,6 +1969,8 @@
 EXPORT_SYMBOL(ipt_do_table);
 EXPORT_SYMBOL(ipt_register_target);
 EXPORT_SYMBOL(ipt_unregister_target);
+EXPORT_SYMBOL_GPL(__ipt_find_target_lock);
+EXPORT_SYMBOL_GPL(__ipt_mutex_up);
 
 module_init(init);
 module_exit(fini);
diff -Nru linux-2.6.10-bk8.orig/net/sched/ipt.c linux-2.6.10-bk8/net/sched/ipt.c
--- linux-2.6.10-bk8.orig/net/sched/ipt.c	2004-12-24 22:33:49.000000000 +0100
+++ linux-2.6.10-bk8/net/sched/ipt.c	2005-01-05 18:55:29.000000000 +0100
@@ -60,19 +60,14 @@
 	struct ipt_target *target;
 	int ret = 0;
 	struct ipt_entry_target *t = p->t;
-	target = __ipt_find_target_lock(t->u.user.name, &ret);
+	target = __ipt_find_target_lock(t->u.user.name, t->u.user.revision);
 
-	if (!target) {
+	if (IS_ERR(target) || !target) {
 		printk("init_targ: Failed to find %s\n", t->u.user.name);
 		return -1;
 	}
 
 	DPRINTK("init_targ: found %s\n", target->name);
-	/* we really need proper ref counting
-	 seems to be only needed for modules?? Talk to laforge */
-/*      if (target->me)
-              __MOD_INC_USE_COUNT(target->me);
-*/
 	t->u.kernel.target = target;
 
 	__ipt_mutex_up();
@@ -81,9 +76,6 @@
 	    && !t->u.kernel.target->checkentry(p->tname, NULL, t->data,
 					       t->u.target_size
 					       - sizeof (*t), p->hook)) {
-/*              if (t->u.kernel.target->me)
-	      __MOD_DEC_USE_COUNT(t->u.kernel.target->me);
-*/
 		DPRINTK("ip_tables: check failed for `%s'.\n",
 			t->u.kernel.target->name);
 		ret = -EINVAL;
@@ -235,8 +227,12 @@
 {
 	struct tcf_ipt *p;
 	p = PRIV(a,ipt);
-	if (NULL != p)
+	if (NULL != p) {
+		struct ipt_entry_target *t = p->t;
+		if (t && t->u.kernel.target)
+			module_put(t->u.kernel.target->me);
 		return tcf_hash_release(p, bind);
+	}
 	return 0;
 }
 

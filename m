From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 2/2] xt_recent: don't save PDEs in table
Date: Wed, 15 Oct 2008 08:14:02 +0400
Message-ID: <20081015041402.GC24058@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:43920 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYJOELI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 00:11:08 -0400
Received: by ey-out-2122.google.com with SMTP id 6so914072eyi.37
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2008 21:11:05 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not strictly needed, so use local variable for PDE.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/xt_recent.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -72,9 +72,6 @@ struct recent_entry {
 struct recent_table {
 	struct list_head	list;
 	char			name[XT_RECENT_NAME_LEN];
-#ifdef CONFIG_PROC_FS
-	struct proc_dir_entry	*proc_old, *proc;
-#endif
 	unsigned int		refcnt;
 	unsigned int		entries;
 	struct list_head	lru_list;
@@ -284,6 +281,9 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_recent_mtinfo *info = par->matchinfo;
 	struct recent_table *t;
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry *pde;
+#endif
 	unsigned i;
 	bool ret = false;
 
@@ -318,25 +318,25 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 	for (i = 0; i < ip_list_hash_size; i++)
 		INIT_LIST_HEAD(&t->iphash[i]);
 #ifdef CONFIG_PROC_FS
-	t->proc = proc_create_data(t->name, ip_list_perms, recent_proc_dir,
+	pde = proc_create_data(t->name, ip_list_perms, recent_proc_dir,
 		  &recent_mt_fops, t);
-	if (t->proc == NULL) {
+	if (pde == NULL) {
 		kfree(t);
 		goto out;
 	}
+	pde->uid = ip_list_uid;
+	pde->gid = ip_list_gid;
 #ifdef CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
-	t->proc_old = proc_create_data(t->name, ip_list_perms, proc_old_dir,
+	pde = proc_create_data(t->name, ip_list_perms, proc_old_dir,
 		      &recent_old_fops, t);
-	if (t->proc_old == NULL) {
+	if (pde == NULL) {
 		remove_proc_entry(t->name, proc_old_dir);
 		kfree(t);
 		goto out;
 	}
-	t->proc_old->uid   = ip_list_uid;
-	t->proc_old->gid   = ip_list_gid;
+	pde->uid = ip_list_uid;
+	pde->gid = ip_list_gid;
 #endif
-	t->proc->uid       = ip_list_uid;
-	t->proc->gid       = ip_list_gid;
 #endif
 	spin_lock_bh(&recent_lock);
 	list_add_tail(&t->list, &tables);

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: xt_recent: don't save proc dirs
Date: Thu, 20 Nov 2008 11:58:43 +0300
Message-ID: <20081120085843.GA1927@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:20967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbYKTIzF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:55:05 -0500
Received: by ug-out-1314.google.com with SMTP id 39so208828ugf.37
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2008 00:55:02 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not needed, since creation and removal are done by name.

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

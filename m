From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 1/2] xt_recent: use proc_create_data()
Date: Wed, 15 Oct 2008 08:13:26 +0400
Message-ID: <20081015041326.GB24058@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:10392 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYJOEKa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 00:10:30 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1134483nfc.21
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2008 21:10:28 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It's tiny little bit safer because ->data always appears initialized.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/xt_recent.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -318,15 +318,15 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 	for (i = 0; i < ip_list_hash_size; i++)
 		INIT_LIST_HEAD(&t->iphash[i]);
 #ifdef CONFIG_PROC_FS
-	t->proc = proc_create(t->name, ip_list_perms, recent_proc_dir,
-		  &recent_mt_fops);
+	t->proc = proc_create_data(t->name, ip_list_perms, recent_proc_dir,
+		  &recent_mt_fops, t);
 	if (t->proc == NULL) {
 		kfree(t);
 		goto out;
 	}
 #ifdef CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
-	t->proc_old = proc_create(t->name, ip_list_perms, proc_old_dir,
-		      &recent_old_fops);
+	t->proc_old = proc_create_data(t->name, ip_list_perms, proc_old_dir,
+		      &recent_old_fops, t);
 	if (t->proc_old == NULL) {
 		remove_proc_entry(t->name, proc_old_dir);
 		kfree(t);
@@ -334,11 +334,9 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 	}
 	t->proc_old->uid   = ip_list_uid;
 	t->proc_old->gid   = ip_list_gid;
-	t->proc_old->data  = t;
 #endif
 	t->proc->uid       = ip_list_uid;
 	t->proc->gid       = ip_list_gid;
-	t->proc->data      = t;
 #endif
 	spin_lock_bh(&recent_lock);
 	list_add_tail(&t->list, &tables);

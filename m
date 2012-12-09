From: "Vitaly E. Lavrov" <lve@guap.ru>
Subject: xt_recent BUG() in kernel 3.2/3.4  & patch
Date: Sun, 09 Dec 2012 15:16:29 +0400
Message-ID: <50C4730D.2080401@guap.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.guap.ru ([91.151.188.3]:26582 "EHLO ns1.guap.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933438Ab2LILmV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2012 06:42:21 -0500
Received: from [10.150.100.7] (95-161-253-150.broadband.spb.TiERA.org [95.161.253.150])
	(user=lve@guap.ru mech=CRAM-MD5 bits=0)
	by mail.guap.ru (8.14.4/8.14.4) with ESMTP id qB9BGTxH002394
	for <netfilter-devel@vger.kernel.org>; Sun, 9 Dec 2012 15:16:29 +0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Appears when stopping container without emptying tables (iptables 
-F/iptables -t mangle -F)

Problem: recent_mt_destroy called after __net_exit recent_net_exit() !

xt_hashlimit contains a BUG () and should be corrected similarly

Possible patch for xt_recent is below
=============
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index d2ff15a..0fc5c32 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -75,6 +75,9 @@ struct recent_entry {
  struct recent_table {
         struct list_head        list;
         char                    name[XT_RECENT_NAME_LEN];
+#ifdef CONFIG_PROC_FS
+       struct proc_dir_entry   *pe;
+#endif
         unsigned int            refcnt;
         unsigned int            entries;
         struct list_head        lru_list;
@@ -375,6 +378,7 @@ static int recent_mt_check(const struct 
xt_mtchk_param *par)
         }
         pde->uid = ip_list_uid;
         pde->gid = ip_list_gid;
+       t->pe = pde;
  #endif
         spin_lock_bh(&recent_lock);
         list_add_tail(&t->list, &recent_net->tables);
@@ -398,7 +402,8 @@ static void recent_mt_destroy(const struct 
xt_mtdtor_param *par)
                 list_del(&t->list);
                 spin_unlock_bh(&recent_lock);
  #ifdef CONFIG_PROC_FS
-               remove_proc_entry(t->name, recent_net->xt_recent);
+               if(t->pe)
+                       remove_proc_entry(t->name, recent_net->xt_recent);
  #endif
                 recent_table_flush(t);
                 kfree(t);
@@ -607,7 +612,19 @@ static void __net_exit recent_net_exit(struct net *net)
  {
         struct recent_net *recent_net = recent_pernet(net);

-       BUG_ON(!list_empty(&recent_net->tables));
+       if(!list_empty(&recent_net->tables)) {
+#ifdef CONFIG_PROC_FS
+               struct recent_table *t;
+               spin_lock_bh(&recent_lock);
+               list_for_each_entry(t, &recent_net->tables, list) {
+                       t->pe = NULL;
+                       remove_proc_entry(t->name, recent_net->xt_recent);
+               }
+               spin_unlock_bh(&recent_lock);
+#endif
+               printk(KERN_INFO "%s net %x: Warning! Tables not empty!\n",
+                               __func__,(u32)net);
+       }
         recent_proc_net_exit(net);
  }
==================

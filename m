From: "Vitaly E. Lavrov" <lve@guap.ru>
Subject: [PATCH] xt_recent fix BUG()
Date: Tue, 11 Dec 2012 23:06:32 +0400
Message-ID: <50C78438.4040102@guap.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010802090004090304060004"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.guap.ru ([91.151.188.3]:14227 "EHLO mail.guap.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab2LKTGg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:06:36 -0500
Received: from [10.150.100.7] (95-161-253-150.broadband.spb.TiERA.org [95.161.253.150])
	(user=lve@guap.ru mech=CRAM-MD5 bits=0)
	by mail.guap.ru (8.14.4/8.14.4) with ESMTP id qBBJ6WPO020208
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Dec 2012 23:06:33 +0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010802090004090304060004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The following patch fixes a bug in xt_recent.
Bug appears at the end of work the networks namespace, provided that the 
tables (filter/mangle/raw) have rule  with xt_recent.
The error occurs because the __net_exit recent_net_exit() is executed 
before the tables are cleared.
Change this order of calls is impossible, since tables must be 
registered earlier than extensions.
Bug exists in all versions of the kernel since 2.6.35

Cleaning tables before completing the network namespace can be used as a 
workaround.

Idea of the patch that if the files are deleted from the directory 
/proc/net/xt_recent" procedure XXXXX, then a flag is set "clean".
If cleaning the tables occurs later and the flag "clean" is set, then 
the delete files is skipped.

Patch for kernel 3.4.22

Signed-off-by: Vitaly Lavrov lve@guap.ru

--
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index d2ff15a..747d52d 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -85,6 +85,7 @@ struct recent_net {
         struct list_head        tables;
  #ifdef CONFIG_PROC_FS
         struct proc_dir_entry   *xt_recent;
+       int                     clean;
  #endif
  };

@@ -398,7 +399,8 @@ static void recent_mt_destroy(const struct 
xt_mtdtor_param *par)
                 list_del(&t->list);
                 spin_unlock_bh(&recent_lock);
  #ifdef CONFIG_PROC_FS
-               remove_proc_entry(t->name, recent_net->xt_recent);
+               if(!recent_net->clean)
+                       remove_proc_entry(t->name, recent_net->xt_recent);
  #endif
                 recent_table_flush(t);
                 kfree(t);
@@ -599,15 +601,26 @@ static int __net_init recent_net_init(struct net *net)
  {
         struct recent_net *recent_net = recent_pernet(net);

+#ifdef CONFIG_PROC_FS
+       recent_net->clean = 0;
+#endif
         INIT_LIST_HEAD(&recent_net->tables);
         return recent_proc_net_init(net);
  }

  static void __net_exit recent_net_exit(struct net *net)
  {
+#ifdef CONFIG_PROC_FS
         struct recent_net *recent_net = recent_pernet(net);
+       struct recent_table *t;

-       BUG_ON(!list_empty(&recent_net->tables));
+       spin_lock_bh(&recent_lock);
+       recent_net->clean = 1;
+       list_for_each_entry(t, &recent_net->tables, list) {
+               remove_proc_entry(t->name, recent_net->xt_recent);
+       }
+       }
+       spin_unlock_bh(&recent_lock);
+#endif
         recent_proc_net_exit(net);
  }

--------------010802090004090304060004
Content-Type: text/plain; charset=UTF-8;
 name="xt_recent.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xt_recent.c.diff"

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index d2ff15a..747d52d 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -85,6 +85,7 @@ struct recent_net {
 	struct list_head	tables;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*xt_recent;
+	int			clean;
 #endif
 };
 
@@ -398,7 +399,8 @@ static void recent_mt_destroy(const struct xt_mtdtor_param *par)
 		list_del(&t->list);
 		spin_unlock_bh(&recent_lock);
 #ifdef CONFIG_PROC_FS
-		remove_proc_entry(t->name, recent_net->xt_recent);
+		if(!recent_net->clean)
+			remove_proc_entry(t->name, recent_net->xt_recent);
 #endif
 		recent_table_flush(t);
 		kfree(t);
@@ -599,15 +601,26 @@ static int __net_init recent_net_init(struct net *net)
 {
 	struct recent_net *recent_net = recent_pernet(net);
 
+#ifdef CONFIG_PROC_FS
+	recent_net->clean = 0;
+#endif
 	INIT_LIST_HEAD(&recent_net->tables);
 	return recent_proc_net_init(net);
 }
 
 static void __net_exit recent_net_exit(struct net *net)
 {
+#ifdef CONFIG_PROC_FS
 	struct recent_net *recent_net = recent_pernet(net);
+	struct recent_table *t;
 
-	BUG_ON(!list_empty(&recent_net->tables));
+	spin_lock_bh(&recent_lock);
+	recent_net->clean = 1;
+	list_for_each_entry(t, &recent_net->tables, list) {
+		remove_proc_entry(t->name, recent_net->xt_recent);
+	}
+	spin_unlock_bh(&recent_lock);
+#endif
 	recent_proc_net_exit(net);
 }
 

--------------010802090004090304060004--

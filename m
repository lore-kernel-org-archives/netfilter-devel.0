From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] fix mem-leak in netfilter
Date: Sun, 7 May 2006 04:26:10 +0200
Message-ID: <200605070426.10405.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Stephen Frost <sfrost@snowman.net>, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org,
	Jesper Juhl <jesper.juhl@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751173AbWEGCZU@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The Coverity checker spotted that we may leak 'hold' in 
net/ipv4/netfilter/ipt_recent.c::checkentry() when the following
is true : 
  if (!curr_table->status_proc) {
    ...
    if(!curr_table) {
    ...
      return 0;  <-- here we leak.
Simply moving an existing vfree(hold); up a bit avoids the possible leak.


(please keep me on CC when replying since I'm not subscribed 
 to netfilter-devel)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 net/ipv4/netfilter/ipt_recent.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.17-rc3-git12-orig/net/ipv4/netfilter/ipt_recent.c	2006-05-07 03:25:38.000000000 +0200
+++ linux-2.6.17-rc3-git12/net/ipv4/netfilter/ipt_recent.c	2006-05-07 04:16:26.000000000 +0200
@@ -821,6 +821,7 @@ checkentry(const char *tablename,
 	/* Create our proc 'status' entry. */
 	curr_table->status_proc = create_proc_entry(curr_table->name, ip_list_perms, proc_net_ipt_recent);
 	if (!curr_table->status_proc) {
+		vfree(hold);
 		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for /proc entry.\n");
 		/* Destroy the created table */
 		spin_lock_bh(&recent_lock);
@@ -845,7 +846,6 @@ checkentry(const char *tablename,
 		spin_unlock_bh(&recent_lock);
 		vfree(curr_table->time_info);
 		vfree(curr_table->hash_table);
-		vfree(hold);
 		vfree(curr_table->table);
 		vfree(curr_table);
 		return 0;

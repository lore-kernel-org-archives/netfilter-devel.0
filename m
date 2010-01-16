From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] xt_hashlimit: simplify seqfile code
Date: Sat, 16 Jan 2010 20:49:00 +0200
Message-ID: <20100116184900.GA24605@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:64921 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0APStV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jan 2010 13:49:21 -0500
Received: by fxm25 with SMTP id 25so1123409fxm.21
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jan 2010 10:49:20 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Simply pass hashtable to seqfile iterators, proc entry itself is not needed.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/xt_hashlimit.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -841,8 +841,7 @@ static struct xt_match hashlimit_mt_reg[] __read_mostly = {
 static void *dl_seq_start(struct seq_file *s, loff_t *pos)
 	__acquires(htable->lock)
 {
-	struct proc_dir_entry *pde = s->private;
-	struct xt_hashlimit_htable *htable = pde->data;
+	struct xt_hashlimit_htable *htable = s->private;
 	unsigned int *bucket;
 
 	spin_lock_bh(&htable->lock);
@@ -859,8 +858,7 @@ static void *dl_seq_start(struct seq_file *s, loff_t *pos)
 
 static void *dl_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct proc_dir_entry *pde = s->private;
-	struct xt_hashlimit_htable *htable = pde->data;
+	struct xt_hashlimit_htable *htable = s->private;
 	unsigned int *bucket = (unsigned int *)v;
 
 	*pos = ++(*bucket);
@@ -874,8 +872,7 @@ static void *dl_seq_next(struct seq_file *s, void *v, loff_t *pos)
 static void dl_seq_stop(struct seq_file *s, void *v)
 	__releases(htable->lock)
 {
-	struct proc_dir_entry *pde = s->private;
-	struct xt_hashlimit_htable *htable = pde->data;
+	struct xt_hashlimit_htable *htable = s->private;
 	unsigned int *bucket = (unsigned int *)v;
 
 	kfree(bucket);
@@ -917,8 +914,7 @@ static int dl_seq_real_show(struct dsthash_ent *ent, u_int8_t family,
 
 static int dl_seq_show(struct seq_file *s, void *v)
 {
-	struct proc_dir_entry *pde = s->private;
-	struct xt_hashlimit_htable *htable = pde->data;
+	struct xt_hashlimit_htable *htable = s->private;
 	unsigned int *bucket = (unsigned int *)v;
 	struct dsthash_ent *ent;
 	struct hlist_node *pos;
@@ -944,7 +940,7 @@ static int dl_proc_open(struct inode *inode, struct file *file)
 
 	if (!ret) {
 		struct seq_file *sf = file->private_data;
-		sf->private = PDE(inode);
+		sf->private = PDE(inode)->data;
 	}
 	return ret;
 }

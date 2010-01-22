From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] ipt_CLUSTERIP: simplify seq_file code
Date: Fri, 22 Jan 2010 22:19:57 +0200
Message-ID: <20100122201957.GE22342@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:58604 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab0AVUUB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jan 2010 15:20:01 -0500
Received: by fxm20 with SMTP id 20so1741593fxm.21
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jan 2010 12:20:00 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pass "struct clusterip_config" itself to seq_file iterators
and save one dereference. Proc entry itself isn't interesting.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv4/netfilter/ipt_CLUSTERIP.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -560,8 +560,7 @@ struct clusterip_seq_position {
 
 static void *clusterip_seq_start(struct seq_file *s, loff_t *pos)
 {
-	const struct proc_dir_entry *pde = s->private;
-	struct clusterip_config *c = pde->data;
+	struct clusterip_config *c = s->private;
 	unsigned int weight;
 	u_int32_t local_nodes;
 	struct clusterip_seq_position *idx;
@@ -632,10 +631,9 @@ static int clusterip_proc_open(struct inode *inode, struct file *file)
 
 	if (!ret) {
 		struct seq_file *sf = file->private_data;
-		struct proc_dir_entry *pde = PDE(inode);
-		struct clusterip_config *c = pde->data;
+		struct clusterip_config *c = PDE(inode)->data;
 
-		sf->private = pde;
+		sf->private = c;
 
 		clusterip_config_get(c);
 	}
@@ -645,8 +643,7 @@ static int clusterip_proc_open(struct inode *inode, struct file *file)
 
 static int clusterip_proc_release(struct inode *inode, struct file *file)
 {
-	struct proc_dir_entry *pde = PDE(inode);
-	struct clusterip_config *c = pde->data;
+	struct clusterip_config *c = PDE(inode)->data;
 	int ret;
 
 	ret = seq_release(inode, file);
@@ -660,10 +657,9 @@ static int clusterip_proc_release(struct inode *inode, struct file *file)
 static ssize_t clusterip_proc_write(struct file *file, const char __user *input,
 				size_t size, loff_t *ofs)
 {
+	struct clusterip_config *c = PDE(file->f_path.dentry->d_inode)->data;
 #define PROC_WRITELEN	10
 	char buffer[PROC_WRITELEN+1];
-	const struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
-	struct clusterip_config *c = pde->data;
 	unsigned long nodenum;
 
 	if (copy_from_user(buffer, input, PROC_WRITELEN))

From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 2/8] [NETFILTER]: xt_recent: IPv6 support
Date: Wed, 9 Apr 2008 15:44:59 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091536410.4411@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <e6fb8173fde4f1ea0cee785b763a2b2b37a89ebb.1207668694.git.jengelh@computergmbh.de> <47FCBB15.90003@trash.net> <47FCC50F.2020802@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59173 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbYDINpA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:45:00 -0400
In-Reply-To: <47FCC50F.2020802@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 15:30, Patrick McHardy wrote:
> Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>> > This updates xt_recent to support the IPv6 address family.
>> > The new /proc/net/xt_recent directory must be used for this.
>> >
>> Could you introduce a new option for this please? Something
>> like CONFIG_NF_CONNTRACK_PROC_COMPAT.
>
> BTW, it would be great if you could send me this patch before
> anything else since my tree has grown too much and I intend
> to push the first batch to Dave later and would like to already
> include the hashlimit patch in this batch.
>
Adding an extra option to compile out the old stuff makes
for lots of ugly #ifdefs. Not want to do that.

old+new:
   text    data     bss     dec     hex filename
   6207     308      25    6540    198c net/netfilter/xt_recent.o

only new stuff:
   text    data     bss     dec     hex filename
   3636     312      21    3969     f81 net/netfilter/xt_recent.o

yes, it's a bit costly on text it seems, but I think can live with it
for the time being.
But you get the desired printk warning for folding:


commit 0c7a7d8f537998216715cce64a0d8f62de001e99
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Apr 9 15:43:58 2008 +0200

    xt_recent: warn about old proc
---
 net/netfilter/xt_recent.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 134529b..8d571ed 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -456,6 +456,18 @@ static int recent_seq_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int recent_old_seq_open(struct inode *inode, struct file *filp)
+{
+	static bool warned_of_old;
+
+	if (unlikely(!warned_of_old)) {
+		printk(KERN_INFO KBUILD_MODNAME ": Use of /proc/net/ipt_recent"
+		       " is deprecated; use /proc/net/xt_recent.\n");
+		warned_of_old = true;
+	}
+	return recent_seq_open(inode, filp);
+}
+
 static ssize_t recent_old_proc_write(struct file *file,
 				     const char __user *input,
 				     size_t size, loff_t *loff)
@@ -587,7 +599,7 @@ recent_mt_proc_write(struct file *file, const char __user *input,
 }
 
 static const struct file_operations recent_old_fops = {
-	.open		= recent_seq_open,
+	.open		= recent_old_seq_open,
 	.read		= seq_read,
 	.write		= recent_old_proc_write,
 	.release	= seq_release_private,

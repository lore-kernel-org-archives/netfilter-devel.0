From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [PATCH 2/2] ipt_hashlimit.c: sleeping function called from invalid
 context
Date: Wed, 26 Jan 2005 22:51:51 -0500
Message-ID: <41F86557.2000208@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Name: sleeping function called from invalid context
Status: Tested under Linux 2.6.10
Signed-off-by: Samuel Jean <sjean@cookinglinux.org>

When we cat our proc entries, we get:

Jan 26 22:07:33 Workstation kernel: Debug: sleeping function called from invalid context at
mm/slab.c:2055
Jan 26 22:07:33 Workstation kernel: in_atomic():1, irqs_disabled():0
Jan 26 22:07:33 Workstation kernel:  [<c0116f80>] __might_sleep+0xb0/0xe0
Jan 26 22:07:33 Workstation kernel:  [<c013f3ec>] kmem_cache_alloc+0x6c/0x70
Jan 26 22:07:33 Workstation kernel:  [<e0a84b31>] dl_seq_start+0x61/0x80 [ipt_hashlimit]
Jan 26 22:07:33 Workstation kernel:  [<c01752bf>] seq_read+0xbf/0x2b0
Jan 26 22:07:33 Workstation kernel:  [<c0154618>] vfs_read+0xb8/0x130
Jan 26 22:07:33 Workstation kernel:  [<c0154901>] sys_read+0x51/0x80
Jan 26 22:07:33 Workstation kernel:  [<c01031bf>] syscall_call+0x7/0xb

This incremental patch to the previous fixes it by disallowing kmalloc to sleep.

--- net/ipv4/netfilter/ipt_hashlimit.c.orig  2005-01-26 22:35:43.000000000 -0500
+++ net/ipv4/netfilter/ipt_hashlimit.c 2005-01-26 22:36:14.000000000 -0500
@@ -570,7 +570,7 @@ static void *dl_seq_start(struct seq_fil
    if (*pos >= htable->cfg.size)
       return NULL;

-  bucket = kmalloc(sizeof(unsigned int), GFP_KERNEL);
+  bucket = kmalloc(sizeof(unsigned int), GFP_ATOMIC);
    if (!bucket)
       return ERR_PTR(-ENOMEM);

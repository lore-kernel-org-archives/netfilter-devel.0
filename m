From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Kernel oops during netfilter memory allocation
Date: Mon, 20 Aug 2007 23:31:03 +0400
Message-ID: <20070820193103.GC2488@martell.zuzino.mipt.ru>
References: <200708201808.08880.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761909AbXHTTbT@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200708201808.08880.thomas.jarosch@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Aug 20, 2007 at 06:08:08PM +0200, Thomas Jarosch wrote:
> I'm currently debugging a kernel oops with kernel 2.6.21.7 that occurs
> from time to time with our netfilter accounting module ipt_ACCOUNT 
> (http://www.intra2net.com/de/produkte/opensource/ipt_account/).

	kernel BUG at arch/i386/mm/highmem.c:38
 
> static unsigned int ipt_crash_target(struct sk_buff **pskb,
>                                    const struct net_device *in,
>                                    const struct net_device *out,
>                                    unsigned int hooknum,
> #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
>                                    const struct xt_target *target,
> #endif
> #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19)
>                                    const void *targinfo)
> #else
>                                    const void *targinfo,
>                                    void *userinfo)
> #endif
> {
>     char *data;
> 
>     spin_lock_bh(&ipt_crash_lock);
> 
>     if ((data = (char *)get_zeroed_page(GFP_ATOMIC)) == NULL) {

Try this.

commit b8c1c5da1520977cb55a358f20fc09567d40cad9
tree c762e6ad77297beed0978337ce2f5b0c50add739
parent 01e457cfcd5b6b6f18d0bb8cec0c5d43df56557e
author Andrew Morton <akpm@linux-foundation.org> 1185303760 -0700
committer Linus Torvalds <torvalds@woody.linux-foundation.org> 1185305099 -0700

slab: correctly handle __GFP_ZERO

Use the correct local variable when calling into the page allocator.  Local
`flags' can have __GFP_ZERO set, which causes us to pass __GFP_ZERO into the
page allocator, possibly from illegal contexts.  The page allocator will later
do prep_zero_page()->kmap_atomic(..., KM_USER0) from irq contexts and will
then go BUG.

Cc: Mike Galbraith <efault@gmx.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
diff --git a/mm/slab.c b/mm/slab.c
index bde271c..a684778 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2776,7 +2776,7 @@ static int cache_grow(struct kmem_cache *cachep,
 	 * 'nodeid'.
 	 */
 	if (!objp)
-		objp = kmem_getpages(cachep, flags, nodeid);
+		objp = kmem_getpages(cachep, local_flags, nodeid);
 	if (!objp)
 		goto failed;
 

From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 15:57:33 -0700 (PDT)
Message-ID: <20051011.155733.05623834.davem@davemloft.net>
References: <Pine.LNX.4.61.0510111550170.2575@filer.marasystems.com>
	<434BC86F.3090506@cosmosbay.com>
	<20051011174556.GA13415@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, hno@marasystems.com,
	dada1@cosmosbay.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051011174556.GA13415@rama.de.gnumonks.org>
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

From: Harald Welte <laforge@netfilter.org>
Date: Tue, 11 Oct 2005 19:45:56 +0200

> Eric, I still have your patches on hold and hope that vmalloc_node will
> eventually appear.  I don't really like the idea of adding code to
> iptables that has to go knee-deep into the vm code....  So once
> vmalloc_node() is there, I'm open to merging your changes.

After thinking about this a bit, what I'm trying to do now is
champion getting the vmalloc_node() patch into 2.6.14 so we
can use Eric's approach to fix this bug cleanly.

Attached is the current version of the vmalloc_node() patch.
Eric, can you send me an updated copy of your patch, such
that it uses this vmalloc_node() instead of the mempolicy
hacks it had previously?

If this fails, I'm afraid we might need to go with the NR_CPUS
option for now as much as I'd really really hate to do that.

Thanks.

From: Christoph Lameter <clameter@engr.sgi.com>

This patch adds

vmalloc_node(size, node)	-> Allocate necessary memory on the specified node

and

get_vm_area_node(size, flags, node)

and the other functions that it depends on.

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/vmalloc.h |    8 ++++-
 mm/vmalloc.c            |   73 +++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 64 insertions(+), 17 deletions(-)

diff -puN include/linux/vmalloc.h~vmalloc_node include/linux/vmalloc.h
--- 25/include/linux/vmalloc.h~vmalloc_node	Tue Oct 11 14:16:27 2005
+++ 25-akpm/include/linux/vmalloc.h	Tue Oct 11 14:19:30 2005
@@ -32,10 +32,14 @@ struct vm_struct {
  *	Highlevel APIs for driver use
  */
 extern void *vmalloc(unsigned long size);
+extern void *vmalloc_node(unsigned long size, int node);
 extern void *vmalloc_exec(unsigned long size);
 extern void *vmalloc_32(unsigned long size);
 extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot);
-extern void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot);
+extern void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask,
+				pgprot_t prot);
+extern void *__vmalloc_node(unsigned long size, gfp_t gfp_mask,
+				pgprot_t prot, int node);
 extern void vfree(void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
@@ -48,6 +52,8 @@ extern void vunmap(void *addr);
 extern struct vm_struct *get_vm_area(unsigned long size, unsigned long flags);
 extern struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 					unsigned long start, unsigned long end);
+extern struct vm_struct *get_vm_area_node(unsigned long size,
+					unsigned long flags, int node);
 extern struct vm_struct *remove_vm_area(void *addr);
 extern struct vm_struct *__remove_vm_area(void *addr);
 extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
diff -puN mm/vmalloc.c~vmalloc_node mm/vmalloc.c
--- 25/mm/vmalloc.c~vmalloc_node	Tue Oct 11 14:16:27 2005
+++ 25-akpm/mm/vmalloc.c	Tue Oct 11 14:22:42 2005
@@ -5,6 +5,7 @@
  *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
  *  SMP-safe vmalloc/vfree/ioremap, Tigran Aivazian <tigran@veritas.com>, May 2000
  *  Major rework to support vmap/vunmap, Christoph Hellwig, SGI, August 2002
+ *  Numa awareness, Christoph Lameter, SGI, June 2005
  */
 
 #include <linux/mm.h>
@@ -158,8 +159,8 @@ int map_vm_area(struct vm_struct *area, 
 	return err;
 }
 
-struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
-				unsigned long start, unsigned long end)
+struct vm_struct *__get_vm_area_node(unsigned long size, unsigned long flags,
+				unsigned long start, unsigned long end, int node)
 {
 	struct vm_struct **p, *tmp, *area;
 	unsigned long align = 1;
@@ -178,7 +179,7 @@ struct vm_struct *__get_vm_area(unsigned
 	addr = ALIGN(start, align);
 	size = PAGE_ALIGN(size);
 
-	area = kmalloc(sizeof(*area), GFP_KERNEL);
+	area = kmalloc_node(sizeof(*area), GFP_KERNEL, node);
 	if (unlikely(!area))
 		return NULL;
 
@@ -231,6 +232,12 @@ out:
 	return NULL;
 }
 
+struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
+				unsigned long start, unsigned long end)
+{
+	return __get_vm_area_node(size, flags, start, end, -1);
+}
+
 /**
  *	get_vm_area  -  reserve a contingous kernel virtual area
  *
@@ -246,6 +253,11 @@ struct vm_struct *get_vm_area(unsigned l
 	return __get_vm_area(size, flags, VMALLOC_START, VMALLOC_END);
 }
 
+struct vm_struct *get_vm_area_node(unsigned long size, unsigned long flags, int node)
+{
+	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END, node);
+}
+
 /* Caller must hold vmlist_lock */
 struct vm_struct *__remove_vm_area(void *addr)
 {
@@ -342,7 +354,6 @@ void vfree(void *addr)
 	BUG_ON(in_interrupt());
 	__vunmap(addr, 1);
 }
-
 EXPORT_SYMBOL(vfree);
 
 /**
@@ -360,7 +371,6 @@ void vunmap(void *addr)
 	BUG_ON(in_interrupt());
 	__vunmap(addr, 0);
 }
-
 EXPORT_SYMBOL(vunmap);
 
 /**
@@ -392,10 +402,10 @@ void *vmap(struct page **pages, unsigned
 
 	return area->addr;
 }
-
 EXPORT_SYMBOL(vmap);
 
-void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
+void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
+				pgprot_t prot, int node)
 {
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
@@ -406,9 +416,9 @@ void *__vmalloc_area(struct vm_struct *a
 	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE)
-		pages = __vmalloc(array_size, gfp_mask, PAGE_KERNEL);
+		pages = __vmalloc_node(array_size, gfp_mask, PAGE_KERNEL, node);
 	else
-		pages = kmalloc(array_size, (gfp_mask & ~__GFP_HIGHMEM));
+		pages = kmalloc_node(array_size, (gfp_mask & ~__GFP_HIGHMEM), node);
 	area->pages = pages;
 	if (!area->pages) {
 		remove_vm_area(area->addr);
@@ -418,7 +428,10 @@ void *__vmalloc_area(struct vm_struct *a
 	memset(area->pages, 0, array_size);
 
 	for (i = 0; i < area->nr_pages; i++) {
-		area->pages[i] = alloc_page(gfp_mask);
+		if (node < 0)
+			area->pages[i] = alloc_page(gfp_mask);
+		else
+			area->pages[i] = alloc_pages_node(node, gfp_mask, 0);
 		if (unlikely(!area->pages[i])) {
 			/* Successfully allocated i pages, free them in __vunmap() */
 			area->nr_pages = i;
@@ -435,18 +448,25 @@ fail:
 	return NULL;
 }
 
+void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
+{
+	return __vmalloc_area_node(area, gfp_mask, prot, -1);
+}
+
 /**
- *	__vmalloc  -  allocate virtually contiguous memory
+ *	__vmalloc_node  -  allocate virtually contiguous memory
  *
  *	@size:		allocation size
  *	@gfp_mask:	flags for the page level allocator
  *	@prot:		protection mask for the allocated pages
+ *	@node		node to use for allocation or -1
  *
  *	Allocate enough pages to cover @size from the page level
  *	allocator with @gfp_mask flags.  Map them into contiguous
  *	kernel virtual space, using a pagetable protection of @prot.
  */
-void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
+void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
+			int node)
 {
 	struct vm_struct *area;
 
@@ -454,13 +474,18 @@ void *__vmalloc(unsigned long size, gfp_
 	if (!size || (size >> PAGE_SHIFT) > num_physpages)
 		return NULL;
 
-	area = get_vm_area(size, VM_ALLOC);
+	area = get_vm_area_node(size, VM_ALLOC, node);
 	if (!area)
 		return NULL;
 
-	return __vmalloc_area(area, gfp_mask, prot);
+	return __vmalloc_area_node(area, gfp_mask, prot, node);
 }
+EXPORT_SYMBOL(__vmalloc_node);
 
+void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
+{
+	return __vmalloc_node(size, gfp_mask, prot, -1);
+}
 EXPORT_SYMBOL(__vmalloc);
 
 /**
@@ -478,9 +503,26 @@ void *vmalloc(unsigned long size)
 {
        return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL);
 }
-
 EXPORT_SYMBOL(vmalloc);
 
+/**
+ *	vmalloc_node  -  allocate memory on a specific node
+ *
+ *	@size:		allocation size
+ *	@node;		numa node
+ *
+ *	Allocate enough pages to cover @size from the page level
+ *	allocator and map them into contiguous kernel virtual space.
+ *
+ *	For tight cotrol over page level allocator and protection flags
+ *	use __vmalloc() instead.
+ */
+void *vmalloc_node(unsigned long size, int node)
+{
+       return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL, node);
+}
+EXPORT_SYMBOL(vmalloc_node);
+
 #ifndef PAGE_KERNEL_EXEC
 # define PAGE_KERNEL_EXEC PAGE_KERNEL
 #endif
@@ -515,7 +557,6 @@ void *vmalloc_32(unsigned long size)
 {
 	return __vmalloc(size, GFP_KERNEL, PAGE_KERNEL);
 }
-
 EXPORT_SYMBOL(vmalloc_32);
 
 long vread(char *buf, char *addr, unsigned long count)

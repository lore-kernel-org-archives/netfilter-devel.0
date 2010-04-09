From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 2/3] flex_array: export some symbols for nfnetlink_queue use
Date: Fri, 09 Apr 2010 12:09:31 +0800
Message-ID: <4BBEA87B.4040807@gmail.com>
Reply-To: xiaosuo@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f171.google.com ([209.85.210.171]:39280 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab0DIEQl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:16:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

export some symbols for nfnetlink_queue use

export some symbols for nfnetlink_queue use.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
lib/Makefile | 4 ++--
lib/flex_array.c | 5 +++++
2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index 0a6ab6f..0700e74 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o flex_array.o
+	 is_single_threaded.o plist.o decompress.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o lcm.o list_sort.o
+	 string_helpers.o gcd.o lcm.o list_sort.o flex_array.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/flex_array.c b/lib/flex_array.c
index 66eef2e..0e18e54 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -23,6 +23,7 @@
 #include <linux/flex_array.h>
 #include <linux/slab.h>
 #include <linux/stddef.h>
+#include <linux/module.h>
 
 struct flex_array_part {
 	char elements[FLEX_ARRAY_PART_SIZE];
@@ -103,6 +104,7 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 						FLEX_ARRAY_BASE_BYTES_LEFT);
 	return ret;
 }
+EXPORT_SYMBOL(flex_array_alloc);
 
 static int fa_element_to_part_nr(struct flex_array *fa,
 					unsigned int element_nr)
@@ -132,6 +134,7 @@ void flex_array_free(struct flex_array *fa)
 	flex_array_free_parts(fa);
 	kfree(fa);
 }
+EXPORT_SYMBOL(flex_array_free);
 
 static unsigned int index_inside_part(struct flex_array *fa,
 					unsigned int element_nr)
@@ -257,6 +260,7 @@ int flex_array_prealloc(struct flex_array *fa, unsigned int start,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(flex_array_prealloc);
 
 /**
  * flex_array_get - pull data back out of the array
@@ -285,6 +289,7 @@ void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 	}
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
+EXPORT_SYMBOL(flex_array_get);
 
 static int part_is_free(struct flex_array_part *part)
 {



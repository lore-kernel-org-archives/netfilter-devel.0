From: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Subject: xtables-addons 64-bit counter patch
Date: Thu, 4 Jun 2015 18:04:42 -0400
Message-ID: <20150604180442.12410111@playground>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from MAIL1.WPI.EDU ([130.215.36.91]:40630 "EHLO MAIL1.WPI.EDU"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbbFDWVk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2015 18:21:40 -0400
Received: from MAIL1.WPI.EDU (MAIL1.WPI.EDU [130.215.36.91])
	by MAIL1.WPI.EDU (8.15.1/8.15.1) with ESMTP id t54M4j08018243
	for <netfilter-devel@vger.kernel.org>; Thu, 4 Jun 2015 18:04:45 -0400
Received: from MX3.WPI.EDU (mx3.wpi.edu [130.215.36.147])
	by MAIL1.WPI.EDU (8.15.1/8.15.1) with ESMTP id t54M4jel018240
	for <netfilter-devel@vger.kernel.org>; Thu, 4 Jun 2015 18:04:45 -0400
Received: from ALUM.WPI.EDU (ALUM.WPI.EDU [130.215.36.126])
	by MX3.WPI.EDU (8.14.4/8.14.4) with ESMTP id t54M4hRQ027433
	for <netfilter-devel@vger.kernel.org>; Thu, 4 Jun 2015 18:04:44 -0400
	(envelope-from neal.p.murphy@alum.wpi.edu)
Received: from playground (c-71-57-197-109.hsd1.va.comcast.net [71.57.197.109])
	(authenticated authen=neal.p.murphy)
	by ALUM.WPI.EDU (8.15.1/8.15.1) with ESMTPSA id t54M4hQN020689
	(version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 4 Jun 2015 18:04:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Howdy!

The Smoothwall Express traffic stats collector (traffiClogger)
doesn't handle counter rollovers well and doesn't perform read&flush.
(Yes, the code is somewhat aged.) To change it to perform read&flush is
non-trivial. Then it occurred to me that it might be easier to change
ipt_ACCOUNT in xtables-addons (v1.45) to use 64-bit counters,
considering it was designed around single kernel pages.

I haven't seen anyone addressing 64-bit counters in ipt_ACCOUNT, so I
figured I'd tackle it. Attached is my patch that seems to work; it
builds for 3.4.104, loads, counts to at least 100GB, produces no
obvious kernel gripes, and adjacent counters don't seem to interfere
with each other. Yes, it uses more memory, but RAM costs much less than
bugs that grown out of complex software.

The theory:
  - Use two kernel pages for the counters for each group of 256
    addresses.
  - Change counters to 64-bit.
  - Change to __get_free_pages/free_pages, using order=2 (two
    consecutive pages), and zero both pages.
  - Change "%u" to "%llu" as needed.
  - Everything else pretty much stays the same.

I also changed tmpbuf to two pages (Justin Case's idea), but I
don't know if that's really necessary.

Did I miss anything?

Thanks,
Neal

-----------
--- xtables-addons-1.45-ORIG/extensions/ACCOUNT/iptaccount.c	2012-07-15 23:39:32.000000000 -0400
+++ xtables-addons-1.45/extensions/ACCOUNT/iptaccount.c	2015-05-29 22:22:37.000000000 -0400
@@ -200,11 +200,11 @@
 			while ((entry = ipt_ACCOUNT_get_next_entry(&ctx)) != NULL)
 			{
 				if (doCSV)
-					printf("%s;%u;%u;%u;%u\n",
+					printf("%s;%llu;%llu;%llu;%llu\n",
 					       addr_to_dotted(entry->ip), entry->src_packets, entry->src_bytes,
 					       entry->dst_packets, entry->dst_bytes);
 				else
-					printf("IP: %s SRC packets: %u bytes: %u DST packets: %u bytes: %u\n",
+					printf("IP: %s SRC packets: %llu bytes: %llu DST packets: %llu bytes: %llu\n",
 					       addr_to_dotted(entry->ip), entry->src_packets, entry->src_bytes,
 					       entry->dst_packets, entry->dst_bytes);
 			}
--- xtables-addons-1.45-ORIG/extensions/ACCOUNT/xt_ACCOUNT.c	2012-07-15 23:39:32.000000000 -0400
+++ xtables-addons-1.45/extensions/ACCOUNT/xt_ACCOUNT.c	2015-05-29 22:15:33.000000000 -0400
@@ -77,13 +77,13 @@
 };
 
 /* Used for every IP entry
-   Size is 16 bytes so that 256 (class C network) * 16
-   fits in one kernel (zero) page */
+   Size is 32 bytes so that 256 (class C network) * 16
+   fits in a double kernel (zero) page (two consecutive kernel pages)*/
 struct ipt_acc_ip {
-	uint32_t src_packets;
-	uint32_t src_bytes;
-	uint32_t dst_packets;
-	uint32_t dst_bytes;
+	uint64_t src_packets;
+	uint64_t src_bytes;
+	uint64_t dst_packets;
+	uint64_t dst_bytes;
 };
 
 /*
@@ -113,14 +113,14 @@
 /* Mutex (semaphore) used for manipulating userspace handles/snapshot data */
 static struct semaphore ipt_acc_userspace_mutex;
 
-/* Allocates a page and clears it */
+/* Allocates a page pair and clears it */
 static void *ipt_acc_zalloc_page(void)
 {
 	// Don't use get_zeroed_page until it's fixed in the kernel.
 	// get_zeroed_page(GFP_ATOMIC)
-	void *mem = (void *)__get_free_page(GFP_ATOMIC);
+	void *mem = (void *)__get_free_pages(GFP_ATOMIC, 2);
 	if (mem) {
-		memset (mem, 0, PAGE_SIZE);
+		memset (mem, 0, 2*PAGE_SIZE);
 	}
 
 	return mem;
@@ -135,7 +135,7 @@
 
 	/* Free for 8 bit network */
 	if (depth == 0) {
-		free_page((unsigned long)data);
+		free_pages((unsigned long)data, 2);
 		return;
 	}
 
@@ -148,7 +148,7 @@
 				free_page((unsigned long)mask_16->mask_24[b]);
 			}
 		}
-		free_page((unsigned long)data);
+		free_pages((unsigned long)data, 2);
 		return;
 	}
 
@@ -168,7 +168,7 @@
 				free_page((unsigned long)mask_16);
 			}
 		}
-		free_page((unsigned long)data);
+		free_pages((unsigned long)data, 2);
 		return;
 	}
 
@@ -541,7 +541,7 @@
 
 /*
 	Functions dealing with "handles":
-	Handles are snapshots of a accounting state.
+	Handles are snapshots of an accounting state.
 
 	read snapshots are only for debugging the code
 	and are very expensive concerning speed/memory
@@ -1123,7 +1123,7 @@
 		ACCOUNT_MAX_HANDLES * sizeof(struct ipt_acc_handle));
 
 	/* Allocate one page as temporary storage */
-	if ((ipt_acc_tmpbuf = (void*)__get_free_page(GFP_KERNEL)) == NULL) {
+	if ((ipt_acc_tmpbuf = (void*)__get_free_pages(GFP_KERNEL, 2)) == NULL) {
 		printk("ACCOUNT: Out of memory for temporary buffer page\n");
 		goto error_cleanup;
 	}
@@ -1145,7 +1145,7 @@
 	if (ipt_acc_handles)
 		kfree(ipt_acc_handles);
 	if (ipt_acc_tmpbuf)
-		free_page((unsigned long)ipt_acc_tmpbuf);
+		free_pages((unsigned long)ipt_acc_tmpbuf, 2);
 
 	return -EINVAL;
 }
@@ -1158,7 +1158,7 @@
 
 	kfree(ipt_acc_tables);
 	kfree(ipt_acc_handles);
-	free_page((unsigned long)ipt_acc_tmpbuf);
+	free_pages((unsigned long)ipt_acc_tmpbuf, 2);
 }
 
 module_init(account_tg_init);
--- xtables-addons-1.45-ORIG/extensions/ACCOUNT/xt_ACCOUNT.h	2012-07-15 23:39:32.000000000 -0400
+++ xtables-addons-1.45/extensions/ACCOUNT/xt_ACCOUNT.h	2015-05-29 22:24:18.000000000 -0400
@@ -60,10 +60,10 @@
 */
 struct ipt_acc_handle_ip {
 	__be32 ip;
-	uint32_t src_packets;
-	uint32_t src_bytes;
-	uint32_t dst_packets;
-	uint32_t dst_bytes;
+	uint64_t src_packets;
+	uint64_t src_bytes;
+	uint64_t dst_packets;
+	uint64_t dst_bytes;
 };
 
 #endif /* _IPT_ACCOUNT_H */
-----------

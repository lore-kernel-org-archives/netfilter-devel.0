From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH NFSIM]: Define ____cacheline_aligned
Date: Thu, 06 Jan 2005 15:15:46 +0100
Message-ID: <41DD4812.9070805@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000308000506020003040601"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
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

This is a multi-part message in MIME format.
--------------000308000506020003040601
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

____cacheline_aligned is currently undefined, this makes this check in
ip_tables.c check_entry_size_and_hooks() fail on 64 bit because
newinfo->entries and thus e is only 4-byte aligned:

        if ((unsigned long)e % __alignof__(struct ipt_entry) != 0
            || (unsigned char *)e + sizeof(struct ipt_entry) >= limit) {
                duprintf("Bad offset %p\n", e);
                return -EINVAL;
        }

This patch makes it align to 8 byte.



--------------000308000506020003040601
Content-Type: text/x-patch;
 name="3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="3.diff"

Index: kernelenv/include/kernelenv.h
===================================================================
--- kernelenv/include/kernelenv.h	(revision 3578)
+++ kernelenv/include/kernelenv.h	(working copy)
@@ -103,7 +103,7 @@
 
 #define __init
 #define __inline
-#define ____cacheline_aligned
+#define ____cacheline_aligned __attribute__((aligned(8)))
 
 #include <talloc.h>
 extern void *__vmalloc_ctx;

--------------000308000506020003040601--

From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Fix LIST_INSERT breakage
Date: Tue, 23 Mar 2004 17:02:30 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040324010230.GA4144@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In 2.4.25, this patch was included:

http://linux.bkbits.net:8080/linux-2.4/cset@3fcc5cc99cChx6Q0shnhIlekWT1-5Q?nav=index.html|ChangeSet@-4M

which has a questionable change in LIST_INSERT due to the disappearing
cmpfn.  But it appears this macro is unused anywhere in the tree, so perhaps
removing it is better than fixing it?

Phil Oester



--- include/linux/netfilter_ipv4/listhelp.h-orig        2004-03-23 19:57:00.696775216 -0500
+++ include/linux/netfilter_ipv4/listhelp.h     2004-03-23 20:01:09.603032216 -0500
@@ -89,17 +89,6 @@
        list_add(new, head);
 }
 
-/* Insert according to ordering function; insert before first true. */
-#define LIST_INSERT(head, new, cmpfn)                          \
-do {                                                           \
-       struct list_head *__i;                                  \
-       ASSERT_WRITE_LOCK(head);                                \
-       list_for_each(__i, (head))                              \
-               if ((new), (typeof (new))__i)                   \
-                       break;                                  \
-       list_add((struct list_head *)(new), __i->prev);         \
-} while(0)
-
 /* If the field after the list_head is a nul-terminated string, you
    can use these functions. */
 static inline int __list_cmp_name(const void *i, const char *name)

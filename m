From: TeJun Huh <tj@atj.dyndns.org>
Subject: [patch] LIST_DELETE bug in linux 2.4.20
Date: Thu, 20 Feb 2003 16:52:53 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030220075253.GA12340@atj.dyndns.org>
Reply-To: tejun@aratech.co.kr
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

 Hello, netfilter guys.

 We run transparent web caches using ipt_REDIRECT, and after upgrading
to 2.4.20, found that conntrack table overflows after a week or so.
Quick examination showed large number of entries in SYN_SENT state
with super long timeouts exist.  The offending change was in
include/linux/list.h.  list_del() now zeros prev and next pointer of
list_head, which circumvents is_confirmed() test.

 This didn't cause troubles to most conntrack entries which disappear
by timing out.  But as our cache was bypassing some of the
connections, the machine was seeing only one way stream of packets
(!IPS_SEEN_REPLY).  And when the originating host terminates a
bypassed connection by sending out RST packets, the corresponding
entry is repeatedly removed from hash with death_by_tiemout() and soon
confirmed again adding jiffies to expire time every time.

 Applying the following patch solved the problem.  As I'm not on the
list, please CC to me any comments regarding this problem.  Thank you
a lot for great netfilter.


--- linux-2.4.20-orig/include/linux/netfilter_ipv4/listhelp.h	2003-02-20 16:48:27.000000000 +0900
+++ linux-2.4.20-rmap-pm/include/linux/netfilter_ipv4/listhelp.h	2003-02-20 16:45:30.000000000 +0900
@@ -57,10 +57,13 @@
 	if (!list_inlist(head, oldentry))				\
 		printk("LIST_DELETE: %s:%u `%s'(%p) not in %s.\n",	\
 		       __FILE__, __LINE__, #oldentry, oldentry, #head);	\
-        else list_del((struct list_head *)oldentry);			\
+        else __list_del(((struct list_head *)oldentry)->prev,		\
+			((struct list_head *)oldentry)->next);		\
 } while(0)
 #else
-#define LIST_DELETE(head, oldentry) list_del((struct list_head *)oldentry)
+#define LIST_DELETE(head, oldentry)					\
+	__list_del(((struct list_head *)oldentry)->prev,		\
+		   ((struct list_head *)oldentry)->next)
 #endif
 
 /* Append. */

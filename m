From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 1/8]: fix ip6_queue inefficiencies
Date: Fri, 04 Mar 2005 13:00:26 +0100
Message-ID: <42284DDA.3010509@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090709060208020702010902"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------090709060208020702010902
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------090709060208020702010902
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/03 23:12:29+01:00 mstjohns@mindspring.com 
#   [NETFILTER]: fix ip6_queue inefficiencies
#   
#   Check if packet exceeds max queue length before netlink_unicast(),
#   add drop statistics.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_queue.c
#   2005/03/03 23:12:20+01:00 mstjohns@mindspring.com +26 -14
#   [NETFILTER]: fix ip6_queue inefficiencies
#   
#   Check if packet exceeds max queue length before netlink_unicast(),
#   add drop statistics.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_queue.c
#   2005/03/03 23:12:20+01:00 mstjohns@mindspring.com +27 -15
#   [NETFILTER]: fix ip6_queue inefficiencies
#   
#   Check if packet exceeds max queue length before netlink_unicast(),
#   add drop statistics.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
--- a/net/ipv4/netfilter/ip_queue.c	2005-03-03 23:35:30 +01:00
+++ b/net/ipv4/netfilter/ip_queue.c	2005-03-03 23:35:30 +01:00
@@ -14,6 +14,9 @@
  *             Zander).
  * 2000-08-01: Added Nick Williams' MAC support.
  * 2002-06-25: Code cleanup.
+ * 2005-01-10: Added /proc counter for dropped packets; fixed so
+ *             packets aren't delivered to user space if they're going 
+ *             to be dropped. 
  *
  */
 #include <linux/module.h>
@@ -59,6 +62,8 @@
 static int peer_pid;
 static unsigned int copy_range;
 static unsigned int queue_total;
+static unsigned int queue_dropped = 0;
+static unsigned int queue_user_dropped = 0;
 static struct sock *ipqnl;
 static LIST_HEAD(queue_list);
 static DECLARE_MUTEX(ipqnl_sem);
@@ -70,18 +75,11 @@
 	kfree(entry);
 }
 
-static inline int
+static inline void
 __ipq_enqueue_entry(struct ipq_queue_entry *entry)
 {
-       if (queue_total >= queue_maxlen) {
-               if (net_ratelimit()) 
-                       printk(KERN_WARNING "ip_queue: full at %d entries, "
-                              "dropping packet(s).\n", queue_total);
-               return -ENOSPC;
-       }
        list_add(&entry->list, &queue_list);
        queue_total++;
-       return 0;
 }
 
 /*
@@ -308,14 +306,24 @@
 	if (!peer_pid)
 		goto err_out_free_nskb; 
 
+	if (queue_total >= queue_maxlen) {
+                queue_dropped++;
+		status = -ENOSPC;
+		if (net_ratelimit())
+		          printk (KERN_WARNING "ip_queue: full at %d entries, "
+				  "dropping packets(s). Dropped: %d\n", queue_total,
+				  queue_dropped);
+		goto err_out_free_nskb;
+	}
+
  	/* netlink_unicast will either free the nskb or attach it to a socket */ 
 	status = netlink_unicast(ipqnl, nskb, peer_pid, MSG_DONTWAIT);
-	if (status < 0)
-		goto err_out_unlock;
-	
-	status = __ipq_enqueue_entry(entry);
-	if (status < 0)
+	if (status < 0) {
+	        queue_user_dropped++;
 		goto err_out_unlock;
+	}
+
+	__ipq_enqueue_entry(entry);
 
 	write_unlock_bh(&queue_lock);
 	return status;
@@ -637,12 +645,16 @@
 	              "Copy mode         : %hu\n"
 	              "Copy range        : %u\n"
 	              "Queue length      : %u\n"
-	              "Queue max. length : %u\n",
+	              "Queue max. length : %u\n"
+		      "Queue dropped     : %u\n"
+		      "Netlink dropped   : %u\n",
 	              peer_pid,
 	              copy_mode,
 	              copy_range,
 	              queue_total,
-	              queue_maxlen);
+	              queue_maxlen,
+		      queue_dropped,
+		      queue_user_dropped);
 
 	read_unlock_bh(&queue_lock);
 	
diff -Nru a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
--- a/net/ipv6/netfilter/ip6_queue.c	2005-03-03 23:35:30 +01:00
+++ b/net/ipv6/netfilter/ip6_queue.c	2005-03-03 23:35:30 +01:00
@@ -20,6 +20,9 @@
  *             Few changes needed, mainly the hard_routing code and
  *             the netlink socket protocol (we're NETLINK_IP6_FW).
  * 2002-06-25: Code cleanup. [JM: ported cleanup over from ip_queue.c]
+ * 2005-02-04: Added /proc counter for dropped packets; fixed so
+ *             packets aren't delivered to user space if they're going
+ *             to be dropped.
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
@@ -64,6 +67,8 @@
 static int peer_pid;
 static unsigned int copy_range;
 static unsigned int queue_total;
+static unsigned int queue_dropped = 0;
+static unsigned int queue_user_dropped = 0;
 static struct sock *ipqnl;
 static LIST_HEAD(queue_list);
 static DECLARE_MUTEX(ipqnl_sem);
@@ -75,18 +80,11 @@
 	kfree(entry);
 }
 
-static inline int
+static inline void
 __ipq_enqueue_entry(struct ipq_queue_entry *entry)
 {
-       if (queue_total >= queue_maxlen) {
-               if (net_ratelimit()) 
-                       printk(KERN_WARNING "ip6_queue: full at %d entries, "
-                              "dropping packet(s).\n", queue_total);
-               return -ENOSPC;
-       }
        list_add(&entry->list, &queue_list);
        queue_total++;
-       return 0;
 }
 
 /*
@@ -312,14 +310,24 @@
 	if (!peer_pid)
 		goto err_out_free_nskb; 
 
+	if (queue_total >= queue_maxlen) {
+                queue_dropped++;
+		status = -ENOSPC;
+		if (net_ratelimit())
+		        printk (KERN_WARNING "ip6_queue: fill at %d entries, "
+				"dropping packet(s).  Dropped: %d\n", queue_total,
+				queue_dropped);
+		goto err_out_free_nskb;
+	}
+
  	/* netlink_unicast will either free the nskb or attach it to a socket */ 
 	status = netlink_unicast(ipqnl, nskb, peer_pid, MSG_DONTWAIT);
-	if (status < 0)
+	if (status < 0) {
+ 	        queue_user_dropped++;
 		goto err_out_unlock;
+	}
 	
-	status = __ipq_enqueue_entry(entry);
-	if (status < 0)
-		goto err_out_unlock;
+	__ipq_enqueue_entry(entry);
 
 	write_unlock_bh(&queue_lock);
 	return status;
@@ -639,12 +647,16 @@
 	              "Copy mode         : %hu\n"
 	              "Copy range        : %u\n"
 	              "Queue length      : %u\n"
-	              "Queue max. length : %u\n",
+	              "Queue max. length : %u\n"
+		      "Queue dropped     : %u\n"
+		      "Netfilter dropped : %u\n",
 	              peer_pid,
 	              copy_mode,
 	              copy_range,
 	              queue_total,
-	              queue_maxlen);
+	              queue_maxlen,
+		      queue_dropped,
+		      queue_user_dropped);
 
 	read_unlock_bh(&queue_lock);
 	

--------------090709060208020702010902--

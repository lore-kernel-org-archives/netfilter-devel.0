From: Michael StJohns <mstjohns@mindspring.com>
Subject: ip_queue.c inefficiencies?
Date: Tue, 18 Jan 2005 19:18:32 -0500
Message-ID: <6.2.0.14.2.20050118185904.047393e0@pop.mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

We've got an application that needs to process a lot of packets through the 
filters.  For a while we were getting a large number of "ip_queue: full at 
1024 entries" messages, but we managed to improve our processing to the 
point where we're staying ahead of the queue filling up.  In the process of 
doing the analysis I noticed that ipq_enqueue_packet sends the packet to 
user space prior to checking whether it can add it to the kernel level 
queue.  That means the user space application that's validating the packet 
would be spending cycles on a packet that it can't actually set a verdict on.

The patch below does two things:  It adds some /proc visible counters to 
count the packets dropped because they couldn't be queued to either kernel 
or user space; it adds a check early on in ipq_enqueue_packet to check and 
see if the kernel queue is full before trying to send the packet to user space.

A further optimization would move the check even earlier in 
ipq_enqueue_packet - right after the copy_mode check.

So the questions I have:  Does this change make sense?  Do I need to make 
this behavior configurable (since it changes the visibility in user 
space)?  For the latter one possibility is to add another two copy_mode 
values (IPQ_COPY_PACKET_FAST and IPQ_COPY_META_FAST) to control the 
behavior, or another is to do this via sysctl.


--- kern1/net/ipv4/netfilter/ip_queue.c	2005-01-13 22:37:02.000000000 -0800
+++ kern2/net/ipv4/netfilter/ip_queue.c	2005-01-16 11:04:31.000000000 -0800
@@ -10,6 +10,9 @@
   *             Zander).
   * 2000-08-01: Added Nick Williams' MAC support.
   * 2002-06-25: Code cleanup.
+ * 2005-01-10: Added /proc counter for dropped packets; fixed so
+ * packets aren't delivered to user space if they're going to be
+ * dropped.
   *
   */
  #include <linux/module.h>
@@ -55,6 +58,8 @@
  static int peer_pid;
  static unsigned int copy_range;
  static unsigned int queue_total;
+static unsigned int queue_dropped = 0;
+static unsigned int queue_user_dropped = 0;
  static struct sock *ipqnl;
  static LIST_HEAD(queue_list);
  static DECLARE_MUTEX(ipqnl_sem);
@@ -70,6 +75,7 @@
  __ipq_enqueue_entry(struct ipq_queue_entry *entry)
  {
         if (queue_total >= queue_maxlen) {
+	       queue_dropped++;
                 if (net_ratelimit())
                         printk(KERN_WARNING "ip_queue: full at %d entries, "
                                "dropping packet(s).\n", queue_total);
@@ -302,10 +308,22 @@
  	if (!peer_pid)
  		goto err_out_free_nskb;

+	if (queue_total >= queue_maxlen) {
+                queue_dropped++;
+		status = -ENOSPC;
+		if (net_ratelimit())
+		  printk (KERN_WARNING "ip_queue: full at %d entries, "
+			  "dropping packets(s). Dropped: %d\n",queue_total,
+			  queue_dropped);
+		goto err_out_free_nskb;
+	}
+
   	/* netlink_unicast will either free the nskb or attach it to a socket */
  	status = netlink_unicast(ipqnl, nskb, peer_pid, MSG_DONTWAIT);
-	if (status < 0)
+	if (status < 0) {
+	        queue_user_dropped++;
  		goto err_out_unlock;
+	}
  	
  	status = __ipq_enqueue_entry(entry);
  	if (status < 0)
@@ -615,12 +633,16 @@
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
  	

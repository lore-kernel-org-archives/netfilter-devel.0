From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] reduce locking in ip_queue
Date: Thu, 05 Aug 2004 15:34:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4112374E.9000409@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020800000703020100080008"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020800000703020100080008
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This is an old issue that I've been discussing with Patrick. Actually, 
he gave me the clue and I think that he's right. Anyway, consider this 
as something experimental. I would like to discuss this issue to know 
more opinions.

This patch reduces locking in ip_queue based on the fact that the user 
process which uses libipq only runs on a CPU at a time, so there's no 
need to lock ip_queue configuration vars (peer_pid, copy_range,...) 
because the process itself serializes all the operations.

On the other hand, we keep locking to enqueue and dequeue because more 
ip_queue.c could run on more than one processor.

regards,
Pablo

--------------020800000703020100080008
Content-Type: text/x-patch;
 name="ip_queue-less-locking.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_queue-less-locking.patch"

diff -u -r1.1.1.1 ip_queue.c
--- a/net/ipv4/netfilter/ip_queue.c	4 Aug 2004 15:14:39 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_queue.c	4 Aug 2004 17:05:52 -0000
@@ -55,7 +55,7 @@
 
 static unsigned char copy_mode = IPQ_COPY_NONE;
 static unsigned int queue_maxlen = IPQ_QMAX_DEFAULT;
-static rwlock_t queue_lock = RW_LOCK_UNLOCKED;
+static spinlock_t queue_lock = SPIN_LOCK_UNLOCKED;
 static int peer_pid;
 static unsigned int copy_range;
 static unsigned int queue_total;
@@ -171,18 +171,18 @@
 {
 	struct ipq_queue_entry *entry;
 	
-	write_lock_bh(&queue_lock);
+	spin_lock_bh(&queue_lock);
 	entry = __ipq_find_dequeue_entry(cmpfn, data);
-	write_unlock_bh(&queue_lock);
+	spin_unlock_bh(&queue_lock);
 	return entry;
 }
 
 static void
 ipq_flush(int verdict)
 {
-	write_lock_bh(&queue_lock);
+	spin_lock_bh(&queue_lock);
 	__ipq_flush(verdict);
-	write_unlock_bh(&queue_lock);
+	spin_unlock_bh(&queue_lock);
 }
 
 static struct sk_buff *
@@ -195,8 +195,6 @@
 	struct ipq_packet_msg *pmsg;
 	struct nlmsghdr *nlh;
 
-	read_lock_bh(&queue_lock);
-	
 	switch (copy_mode) {
 	case IPQ_COPY_META:
 	case IPQ_COPY_NONE:
@@ -215,12 +213,9 @@
 	
 	default:
 		*errp = -EINVAL;
-		read_unlock_bh(&queue_lock);
 		return NULL;
 	}
 
-	read_unlock_bh(&queue_lock);
-
 	skb = alloc_skb(size, GFP_ATOMIC);
 	if (!skb)
 		goto nlmsg_failure;
@@ -277,6 +272,9 @@
 	struct sk_buff *nskb;
 	struct ipq_queue_entry *entry;
 
+	if (!peer_pid)
+		return status;
+
 	if (copy_mode == IPQ_COPY_NONE)
 		return -EAGAIN;
 
@@ -301,28 +299,22 @@
 	if (nskb == NULL)
 		goto err_out_free;
 		
-	write_lock_bh(&queue_lock);
-	
-	if (!peer_pid)
-		goto err_out_free_nskb; 
-
  	/* netlink_unicast will either free the nskb or attach it to a socket */ 
 	status = netlink_unicast(ipqnl, nskb, peer_pid, MSG_DONTWAIT);
 	if (status < 0)
-		goto err_out_unlock;
+		goto err_out_free;
+
+	spin_lock_bh(&queue_lock);
 	
 	status = __ipq_enqueue_entry(entry);
 	if (status < 0)
 		goto err_out_unlock;
 
-	write_unlock_bh(&queue_lock);
+	spin_unlock_bh(&queue_lock);
 	return status;
 
-err_out_free_nskb:
-	kfree_skb(nskb); 
-	
 err_out_unlock:
-	write_unlock_bh(&queue_lock);
+	spin_unlock_bh(&queue_lock);
 
 err_out_free:
 	kfree(entry);
@@ -414,9 +406,7 @@
 {
 	int status;
 
-	write_lock_bh(&queue_lock);
 	status = __ipq_set_mode(mode, range);
-	write_unlock_bh(&queue_lock);
 	return status;
 }
 
@@ -507,19 +497,15 @@
 	if (security_netlink_recv(skb))
 		RCV_SKB_FAIL(-EPERM);
 	
-	write_lock_bh(&queue_lock);
 	
 	if (peer_pid) {
 		if (peer_pid != pid) {
-			write_unlock_bh(&queue_lock);
 			RCV_SKB_FAIL(-EBUSY);
 		}
 	}
 	else
 		peer_pid = pid;
 		
-	write_unlock_bh(&queue_lock);
-	
 	status = ipq_receive_peer(NLMSG_DATA(nlh), type,
 	                          skblen - NLMSG_LENGTH(0));
 	if (status < 0)
@@ -573,10 +559,8 @@
 
 	if (event == NETLINK_URELEASE &&
 	    n->protocol == NETLINK_FIREWALL && n->pid) {
-		write_lock_bh(&queue_lock);
 		if (n->pid == peer_pid)
 			__ipq_reset();
-		write_unlock_bh(&queue_lock);
 	}
 	return NOTIFY_DONE;
 }
@@ -624,8 +608,6 @@
 {
 	int len;
 
-	read_lock_bh(&queue_lock);
-	
 	len = sprintf(buffer,
 	              "Peer PID          : %d\n"
 	              "Copy mode         : %hu\n"
@@ -638,8 +620,6 @@
 	              queue_total,
 	              queue_maxlen);
 
-	read_unlock_bh(&queue_lock);
-	
 	*start = buffer + offset;
 	len -= offset;
 	if (len > length)

--------------020800000703020100080008--

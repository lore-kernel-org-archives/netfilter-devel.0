From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 6/9]: Enable rx timestamps in ip_queue/ip6_queue
Date: Mon, 15 Nov 2004 22:45:01 +0100
Message-ID: <4199235D.8030200@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080309030004020900000407"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------080309030004020900000407
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Enable rx timestamps in ip_queue/ip6_queue.



--------------080309030004020900000407
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/13 13:29:00+01:00 kaber@coreworks.de 
#   [NETFILTER]: Enable rx timestamps in ip_queue/ip6_queue
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_queue.c
#   2004/11/13 13:28:54+01:00 kaber@coreworks.de +4 -2
#   [NETFILTER]: Enable rx timestamps in ip_queue/ip6_queue
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_queue.c
#   2004/11/13 13:28:54+01:00 kaber@coreworks.de +4 -2
#   [NETFILTER]: Enable rx timestamps in ip_queue/ip6_queue
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
--- a/net/ipv4/netfilter/ip_queue.c	2004-11-15 22:07:17 +01:00
+++ b/net/ipv4/netfilter/ip_queue.c	2004-11-15 22:07:17 +01:00
@@ -162,6 +162,7 @@
 __ipq_reset(void)
 {
 	peer_pid = 0;
+	net_disable_timestamp();
 	__ipq_set_mode(IPQ_COPY_NONE, 0);
 	__ipq_flush(NF_DROP);
 }
@@ -517,9 +518,10 @@
 			write_unlock_bh(&queue_lock);
 			RCV_SKB_FAIL(-EBUSY);
 		}
-	}
-	else
+	} else {
+		net_enable_timestamp();
 		peer_pid = pid;
+	}
 		
 	write_unlock_bh(&queue_lock);
 	
diff -Nru a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
--- a/net/ipv6/netfilter/ip6_queue.c	2004-11-15 22:07:17 +01:00
+++ b/net/ipv6/netfilter/ip6_queue.c	2004-11-15 22:07:17 +01:00
@@ -167,6 +167,7 @@
 __ipq_reset(void)
 {
 	peer_pid = 0;
+	net_disable_timestamp();
 	__ipq_set_mode(IPQ_COPY_NONE, 0);
 	__ipq_flush(NF_DROP);
 }
@@ -520,9 +521,10 @@
 			write_unlock_bh(&queue_lock);
 			RCV_SKB_FAIL(-EBUSY);
 		}
-	}
-	else
+	} else {
+		net_enable_timestamp();
 		peer_pid = pid;
+	}
 		
 	write_unlock_bh(&queue_lock);
 	

--------------080309030004020900000407--

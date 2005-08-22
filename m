From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/4]: Fix HW checksum handling in ip_queue/ip6_queue
Date: Mon, 22 Aug 2005 02:03:57 +0200
Message-ID: <4309166D.9010706@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070602000302060709010604"
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
--------------070602000302060709010604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

following are a fix for ip_queue and HW checksums, Pablo's string
match and two new targets. Please apply to your net-2.6.14 tree
(the ip_queue fix could also go directly in 2.6.13 IMO).


[NETFILTER]: Fix HW checksum handling in ip_queue/ip6_queue
[NETFILTER]: Add string match
[NETFILTER]: Add IPv6 REJECT target
[NETFILTER]: Add goto target

--------------070602000302060709010604
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: Fix HW checksum handling in ip_queue/ip6_queue

The checksum needs to be filled in on output, after mangling a packet
ip_summed needs to be reset.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8cf07748b0be017ee9776fa5cb25b7d07e771e37
tree 07e5170035c471f59c866d9df4453a2dad6dd667
parent 01d727422b4153699009a711905e86741f9080e4
author Patrick McHardy <kaber@trash.net> Sun, 21 Aug 2005 21:54:12 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 21 Aug 2005 21:54:12 +0200

 net/ipv4/netfilter/ip_queue.c  |    7 +++++++
 net/ipv6/netfilter/ip6_queue.c |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -207,6 +207,12 @@ ipq_build_packet_message(struct ipq_queu
 		break;
 	
 	case IPQ_COPY_PACKET:
+		if (entry->skb->ip_summed == CHECKSUM_HW &&
+		    (*errp = skb_checksum_help(entry->skb,
+		                               entry->info->outdev == NULL))) {
+			read_unlock_bh(&queue_lock);
+			return NULL;
+		}
 		if (copy_range == 0 || copy_range > entry->skb->len)
 			data_len = entry->skb->len;
 		else
@@ -371,6 +377,7 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, st
 	if (!skb_make_writable(&e->skb, v->data_len))
 		return -ENOMEM;
 	memcpy(e->skb->data, v->payload, v->data_len);
+	e->skb->ip_summed = CHECKSUM_NONE;
 
 	return 0;
 }
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -205,6 +205,12 @@ ipq_build_packet_message(struct ipq_queu
 		break;
 	
 	case IPQ_COPY_PACKET:
+		if (entry->skb->ip_summed == CHECKSUM_HW &&
+		    (*errp = skb_checksum_help(entry->skb,
+		                               entry->info->outdev == NULL))) {
+			read_unlock_bh(&queue_lock);
+			return NULL;
+		}
 		if (copy_range == 0 || copy_range > entry->skb->len)
 			data_len = entry->skb->len;
 		else
@@ -369,6 +375,7 @@ ipq_mangle_ipv6(ipq_verdict_msg_t *v, st
 	if (!skb_make_writable(&e->skb, v->data_len))
 		return -ENOMEM;
 	memcpy(e->skb->data, v->payload, v->data_len);
+	e->skb->ip_summed = CHECKSUM_NONE;
 
 	return 0;
 }

--------------070602000302060709010604--

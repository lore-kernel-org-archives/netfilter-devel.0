From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 4/9]: Handle nonlinear skbs in ip_queue/ip6_queue
Date: Mon, 15 Nov 2004 22:44:39 +0100
Message-ID: <41992347.5030302@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080607000307030906030605"
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
--------------080607000307030906030605
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Handle nonlinear skbs in ip_queue/ip6_queue. This, in addition to Yasuyuki's
patches, is the last change necessary to remove skb_linearize from 
ip6_tables.



--------------080607000307030906030605
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/13 11:55:57+01:00 kaber@coreworks.de 
#   [NETFILTER]: Handle nonlinear skbs in ip_queue/ip6_queue
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_queue.c
#   2004/11/13 11:55:50+01:00 kaber@coreworks.de +4 -1
#   [NETFILTER]: Handle nonlinear skbs in ip_queue/ip6_queue
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_queue.c
#   2004/11/13 11:55:50+01:00 kaber@coreworks.de +4 -1
#   [NETFILTER]: Handle nonlinear skbs in ip_queue/ip6_queue
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
--- a/net/ipv4/netfilter/ip_queue.c	2004-11-15 22:07:01 +01:00
+++ b/net/ipv4/netfilter/ip_queue.c	2004-11-15 22:07:01 +01:00
@@ -257,7 +257,8 @@
 	}
 	
 	if (data_len)
-		memcpy(pmsg->payload, entry->skb->data, data_len);
+		if (skb_copy_bits(entry->skb, 0, pmsg->payload, data_len))
+			BUG();
 		
 	nlh->nlmsg_len = skb->tail - old_tail;
 	return skb;
@@ -362,6 +363,8 @@
 		}
 		skb_put(e->skb, diff);
 	}
+	if (!skb_ip_make_writable(&e->skb, v->data_len))
+		return -ENOMEM;
 	memcpy(e->skb->data, v->payload, v->data_len);
 	e->skb->nfcache |= NFC_ALTERED;
 
diff -Nru a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
--- a/net/ipv6/netfilter/ip6_queue.c	2004-11-15 22:07:01 +01:00
+++ b/net/ipv6/netfilter/ip6_queue.c	2004-11-15 22:07:01 +01:00
@@ -262,7 +262,8 @@
 	}
 	
 	if (data_len)
-		memcpy(pmsg->payload, entry->skb->data, data_len);
+		if (skb_copy_bits(entry->skb, 0, pmsg->payload, data_len))
+			BUG();
 		
 	nlh->nlmsg_len = skb->tail - old_tail;
 	return skb;
@@ -366,6 +367,8 @@
 		}
 		skb_put(e->skb, diff);
 	}
+	if (!skb_ip_make_writable(&e->skb, v->data_len))
+		return -ENOMEM;
 	memcpy(e->skb->data, v->payload, v->data_len);
 	e->skb->nfcache |= NFC_ALTERED;
 

--------------080607000307030906030605--

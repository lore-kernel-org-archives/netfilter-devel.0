From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] ip_queue and fragments
Date: Thu, 05 Aug 2004 15:32:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411236FF.4080405@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040800030903010706090905"
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
--------------040800030903010706090905
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've tracing ip_queue source code and I think that it's not fragment 
aware. Am I missing anything?

regards,
Pablo

--------------040800030903010706090905
Content-Type: text/x-patch;
 name="ip_queue_frags.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_queue_frags.patch"

diff -u -r1.1.1.1 ip_queue.c
--- a/net/ipv4/netfilter/ip_queue.c	11 May 2004 13:07:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_queue.c	4 Aug 2004 14:37:25 -0000
@@ -255,9 +255,10 @@
 				entry->skb->dev->hard_header_parse(entry->skb,
 				                                   pmsg->hw_addr);
 	}
-	
-	if (data_len)
-		memcpy(pmsg->payload, entry->skb->data, data_len);
+
+	if (data_len) 
+		if (skb_copy_bits(entry->skb, 0, pmsg->payload, data_len) != 0)
+			goto nlmsg_failure;
 		
 	nlh->nlmsg_len = skb->tail - old_tail;
 	return skb;

--------------040800030903010706090905--

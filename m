From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] ip_queue and fragments
Date: Fri, 06 Aug 2004 18:44:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4113B551.2030107@eurodev.net>
References: <411236FF.4080405@eurodev.net> <41124142.3030600@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010301030504000803050100"
Cc: Harald Welte <laforge@netfilter.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41124142.3030600@trash.net>
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
--------------010301030504000803050100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

Patrick McHardy wrote:

> skb_copy_bits always stays inside limits if len is positive, so you can
> do something like this:
>
> if  (copy_range == 0)
>  data_len = ~0UL;
> else
>  data_len = copy_range;
>
> but you have to remove the jump to nlmsg_failure when skb_copy_bits 
> fails.


thanks for your suggestions, I've applied them to my patch.

regards,
Pablo

--------------010301030504000803050100
Content-Type: text/x-patch;
 name="ip_queue-fragments.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_queue-fragments.patch"

diff -u -r1.1.1.1 ip_queue.c
--- a/net/ipv4/netfilter/ip_queue.c	4 Aug 2004 15:14:39 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_queue.c	6 Aug 2004 16:38:11 -0000
@@ -205,8 +205,8 @@
 		break;
 	
 	case IPQ_COPY_PACKET:
-		if (copy_range == 0 || copy_range > entry->skb->len)
-			data_len = entry->skb->len;
+		if (copy_range == 0)
+			data_len = ~0UL;
 		else
 			data_len = copy_range;
 		
@@ -257,7 +257,7 @@
 	}
 	
 	if (data_len)
-		memcpy(pmsg->payload, entry->skb->data, data_len);
+		skb_copy_bits(entry->skb, 0, pmsg->payload, data_len);
 		
 	nlh->nlmsg_len = skb->tail - old_tail;
 	return skb;

--------------010301030504000803050100--

From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip_queue and fragments
Date: Thu, 05 Aug 2004 16:16:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41124142.3030600@trash.net>
References: <411236FF.4080405@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <411236FF.4080405@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:

> Hi,
>
> I've tracing ip_queue source code and I think that it's not fragment 
> aware. Am I missing anything?

This check prevents copying data outside of skb->data:

        case IPQ_COPY_PACKET:
                if (copy_range == 0 || copy_range > entry->skb->len)
                        data_len = entry->skb->len;
                else
                        data_len = copy_range;

skb_copy_bits always stays inside limits if len is positive, so you can
do something like this:

if  (copy_range == 0)
  data_len = ~0UL;
else
  data_len = copy_range;

but you have to remove the jump to nlmsg_failure when skb_copy_bits fails.

Regards
Patrick

>------------------------------------------------------------------------
>
>diff -u -r1.1.1.1 ip_queue.c
>--- a/net/ipv4/netfilter/ip_queue.c	11 May 2004 13:07:08 -0000	1.1.1.1
>+++ b/net/ipv4/netfilter/ip_queue.c	4 Aug 2004 14:37:25 -0000
>@@ -255,9 +255,10 @@
> 				entry->skb->dev->hard_header_parse(entry->skb,
> 				                                   pmsg->hw_addr);
> 	}
>-	
>-	if (data_len)
>-		memcpy(pmsg->payload, entry->skb->data, data_len);
>+
>+	if (data_len) 
>+		if (skb_copy_bits(entry->skb, 0, pmsg->payload, data_len) != 0)
>+			goto nlmsg_failure;
> 		
> 	nlh->nlmsg_len = skb->tail - old_tail;
> 	return skb;
>  
>

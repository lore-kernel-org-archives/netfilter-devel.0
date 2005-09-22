From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: (no subject)
Date: Thu, 22 Sep 2005 10:01:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0509220958240.21099@filer.marasystems.com>
References: <87CDEF0BA329934CB1B2A156A90BBF1205BE92@coyote.columbia.ads.sparta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Heyman, Michael" <Michael.Heyman@sparta.com>
In-Reply-To: <87CDEF0BA329934CB1B2A156A90BBF1205BE92@coyote.columbia.ads.sparta.com>
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

On Wed, 21 Sep 2005, Heyman, Michael wrote:

> I found what apears to be a bug in the "net/ipv4/netfilter/ip_tables.c"
> code. The issue arose when I had a mangle table target that could return
> NF_STOLEN. The ipt_do_table() routine uses the contents of the sk_buff
> to calculate "datalen" even though the sk_buff, upon return from the
> "target()" call with NF_STOLEN, should be assumed invalid (in my case, I
> had set the returned sk_buff to NULL).
>
> --- foo.c	2005-09-21 07:00:35.000000000 -0400
> +++ net/ipv4/netfilter/ip_tables.c	2005-06-17 15:48:29.000000000
> -0400
> @@ -378,15 +378,16 @@
> 				((struct ipt_entry
> *)table_base)->comefrom
> 					= 0x57acc001;
> #endif
> -				/* Target might have changed stuff. */
> -				ip = (*pskb)->nh.iph;
> -				datalen = (*pskb)->len - ip->ihl * 4;
> -
> 				if (verdict == IPT_CONTINUE)
> 					e = (void *)e + e->next_offset;
> 				else
> 					/* Verdict */
> 					break;
> +
> +				/* Target might have changed stuff. */
> +				ip = (*pskb)->nh.iph;
> +				datalen = (*pskb)->len - ip->ihl * 4;
> +


This patch on the other hand fails in the perhaps more common situation 
where a target mangles the payload and returns NF_ACCEPT.

Regards
Henrik

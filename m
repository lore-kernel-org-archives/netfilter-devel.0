From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] NETFILTER: add support for invert condition (!)
	in	ipt_limit
Date: Mon, 17 Oct 2005 17:15:07 +0200
Message-ID: <4353BFFB.7070406@trash.net>
References: <20051017094417.GA26911@pc-innocenti.cineca.it>	<20051017.184547.117007327.yoshfuji@linux-ipv6.org>
	<20051017143053.GA29010@pc-innocenti.cineca.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Innocenti <m.innocenti@cineca.it>
In-Reply-To: <20051017143053.GA29010@pc-innocenti.cineca.it>
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

Marco Innocenti wrote:
> On Mon, Oct 17, 2005 at 06:45:47PM +0900, YOSHIFUJI Hideaki / ?$B5HF#1QL@ wrote:
> 
>>>-		return 1;
>>>+		return 1 ^ r->invert;
>>
>>!r->invert
> 
> 
> I've seen it in ipt_multiport.c and I copied it.
> Should ipt_multiport.c be corrected?

Probably, I've never liked these strange looking expressions.

> diff -uprN linux-2.6.13.4/include/linux/netfilter_ipv4/ipt_limit.h linux-2.6.13.4.mio/include/linux/netfilter_ipv4/ipt_limit.h
> --- linux-2.6.13.4/include/linux/netfilter_ipv4/ipt_limit.h	2005-10-10 20:54:29.000000000 +0200
> +++ linux-2.6.13.4.mio/include/linux/netfilter_ipv4/ipt_limit.h	2005-10-15 16:25:02.000000000 +0200
> @@ -9,6 +9,7 @@
>  struct ipt_rateinfo {
>  	u_int32_t avg;    /* Average secs between packets * scale */
>  	u_int32_t burst;  /* Period multiplier for upper limit. */
> +	u_int8_t invert;
>  
>  	/* Used internally by the kernel */
>  	unsigned long prev;

This breaks userspace compatibility, you need to use a new revision
if you want to change this structure. Look at ipt_MARK for an example.

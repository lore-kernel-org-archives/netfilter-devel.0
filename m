From: Patrick McHardy <kaber@trash.net>
Subject: Re: MARK target extension
Date: Wed, 09 Jun 2004 10:51:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40C6CF8D.8080201@trash.net>
References: <20040526205915.M56972@metal.art.pl> <40B5BA84.5040601@trash.net> <20040605205623.M81946@metal.art.pl> <40C32948.2090809@trash.net> <20040608073821.M38174@metal.art.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
 Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Grzegorz Nosek <blackfire@metal.art.pl>
In-Reply-To: <20040608073821.M38174@metal.art.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Grzegorz Nosek wrote:
> On Sun, 06 Jun 2004 16:25:12 +0200, Patrick McHardy wrote
> 
>>I agree with you. CONNMARK seems to have the most flexible solution:
>>newmark = (ct->mark & ~markinfo->mask) | markinfo->mark;
> 
> Hmm I think I made it even more flexible by replacing the OR with XOR. 
> 
> --set-mark 0x80 - nfmark = 0x80
> --set-mark 0x80/0x80 - nfmark |= 0x80
> --set-mark 0x80/0 - nfmark ^= 0x80
> --set-mark 0x80/0xff - replace lowest 8 bits with 0x80
> --set-mark 0/0xff - clear lowest 8 bits
> --set-mark 0/0 - silly NOP
> etc.
> 
> With R and S being corresponding bits in mark and mask, you can set
> (RS=11), clear (RS=01), invert (RS=10) and leave intact (RS=00) any
> set of bits in the nfmark. What do you think?

Nice, although the xor operation (0x80/0) is a bit non-intuitive.

> 
>>Note that unlike with your patch, mark isn't ANDed with mask,
>> so you can also do a simple OR by setting mask to zero.
>>
>>If you change your patch this way, and also make the 
>>userspace-part look like CONNMARK (mark/mask instead of -
>>-mask), I'll happily replace the MARK-operations patch.
> 
> 
> Done and attached.

One of my concerns was that MARK and CONNMARK should look and behave
the same way. We should either change CONNMARK to also use xor, or
change your patch to using or. Henrik, what do you think ?

Regards
Patrick

> ------------------------------------------------------------------------
> 
> diff -Naur linux-2.4.26-ow1+route/include/linux/netfilter_ipv4/ipt_MARK.h linux-2.4.26-ow1+route+mark/include/linux/netfilter_ipv4/ipt_MARK.h
> --- linux-2.4.26-ow1+route/include/linux/netfilter_ipv4/ipt_MARK.h	2000-03-17 19:56:20.000000000 +0100
> +++ linux-2.4.26-ow1+route+mark/include/linux/netfilter_ipv4/ipt_MARK.h	2004-05-26 17:10:26.000000000 +0200
> @@ -3,6 +3,7 @@
>  
>  struct ipt_mark_target_info {
>  	unsigned long mark;
> +	unsigned long mask;
>  };
>  
>  #endif /*_IPT_MARK_H_target*/
> diff -Naur linux-2.4.26-ow1+route/net/ipv4/netfilter/ipt_MARK.c linux-2.4.26-ow1+route+mark/net/ipv4/netfilter/ipt_MARK.c
> --- linux-2.4.26-ow1+route/net/ipv4/netfilter/ipt_MARK.c	2001-09-30 21:26:08.000000000 +0200
> +++ linux-2.4.26-ow1+route+mark/net/ipv4/netfilter/ipt_MARK.c	2004-05-26 17:18:49.000000000 +0200
> @@ -16,9 +16,10 @@
>         void *userinfo)
>  {
>  	const struct ipt_mark_target_info *markinfo = targinfo;
> +	long new_mark = ((*pskb)->nfmark & ~markinfo->mask) ^ markinfo->mark;
>  
> -	if((*pskb)->nfmark != markinfo->mark) {
> -		(*pskb)->nfmark = markinfo->mark;
> +	if((*pskb)->nfmark != new_mark) {
> +		(*pskb)->nfmark = new_mark;
>  		(*pskb)->nfcache |= NFC_ALTERED;
>  	}
>  	return IPT_CONTINUE;
> 
> 

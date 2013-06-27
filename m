From: Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 2/5] ipset: add "inner" flag implementation
Date: Thu, 27 Jun 2013 23:36:58 +0100
Message-ID: <51CCBE8A.3080305@googlemail.com>
References: <cover.1371423775.git.mr.dash.four@googlemail.com> <51BE49D4.1010901@googlemail.com> <alpine.DEB.2.00.1306262149560.17378@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50095 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3F0WhH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:37:07 -0400
Received: by mail-we0-f174.google.com with SMTP id q58so997567wes.5
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2013 15:37:06 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1306262149560.17378@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Jozsef Kadlecsik wrote:
> Get rid of the compatibility functions. Or keep the original function 
> names with the extended arguments: there's no stable API.
>   
As you've probably guessed, I kept the old functions and their 
parameters in order to preserve the existing interface API, since any 
changes I make to these will break existing code using them. If there is 
no objection and there is no such requirement, I'll get rid of them in 
the next release of the patches - just let me know.

>> +#include <linux/netfilter/ipset/ip_set_icmp.h>
>>     
>
> I don't really like the new header file. ip[v]4|6addrptr are generic 
> functions (from ipset point of view) and getting the inner header is too, 
> so those deserve to be in the ipset core.
>   
That's a fair comment - I'll move them in ip_set_core.c as you suggest 
below.

>>  #define _IP_SET_MODULE_DESC(a, b, c)		\
>>  	MODULE_DESCRIPTION(a " type of IP sets, revisions " b "-" c)
>> @@ -361,6 +365,25 @@ static inline int nla_put_ipaddr6(struct sk_buff *skb,
>> int type,
>>  }
>>
>>  /* Get address from skbuff */
>> +static inline bool
>> +ipv4addrptr(const struct sk_buff *skb, bool inner, bool src, __be32 *addr)
>> +{
>> +	struct iphdr *ih = ip_hdr(skb);
>> +	unsigned int protooff = ip_hdrlen(skb);
>> +
>> +	if (ih == NULL ||
>>     
>
> Why do you have to check the IP header?
>   
Simply playing it safe. I am referencing it later on in the code and if 
that pointer is NULL for whatever reason, it will trigger a null-pointer 
dereference, hence the check above.

>> +	    (inner &&
>> +	     (ih->protocol != IPPROTO_ICMP ||
>> +	      !ip_set_get_icmpv4_inner_hdr(skb, &protooff, &ih))))
>> +			goto err;
>>     
>
> Move the protocol checking into ip_set_get_icmpv4_inner_hdr. Also, I 
> suggested the name ip_set_get[_ip4]_inner_hdr because I want to extend it 
> to support IPIP and GRE too. By moving the protocol checking into the 
> function and using a not so specific name, those make possible the 
> extension straightforward.
Noted - will do that in the next version of the patches.

>  Also, there's no need for the goto here: 
> there's no other error path.
>   
I disagree. By having "return false" (or "return 0", "return -1" and so 
on) instead of "goto err" it is not immediately apparent to someone who 
studies/reviews/uses the code that this is an error condition/path. I 
have been in that situation many times when I have to go back and look 
at a particular function call to see what "return false" or "return 0" 
actually means.

By including "goto err" instead of multiple "return false" statement, 
that makes it instantly obvious what the purpose of that statement is 
without having to look elsewhere.

>> +	*addr = src ? ih->saddr : ih->daddr;
>> +	return true;
>> +
>> +err:
>> +	return false;
>> +}
>> +
>>  static inline __be32
>>  ip4addr(const struct sk_buff *skb, bool src)
>>  {
>> @@ -373,12 +396,55 @@ ip4addrptr(const struct sk_buff *skb, bool src, __be32
>> *addr)
>>  	*addr = src ? ip_hdr(skb)->saddr : ip_hdr(skb)->daddr;
>>  }
>>
>> +#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
>> +static inline bool
>> +ipv6addrptr(const struct sk_buff *skb, bool inner, bool src,
>> +	    struct in6_addr *addr)
>> +{
>> +	struct ipv6hdr *ih = ipv6_hdr(skb);
>> +
>> +	if (ih == NULL)
>> +		goto err;
>>     
>
> The same comment as above.
>   
Same answer - it is simply used for code clarity and makes the code 
easier to understand. The presence of "goto" instead of multiple "return 
false" (or "return 0") statements is also negligible in terms of 
performance impact.

>> +	if (inner) {
>> +		unsigned int protooff;
>> +		u8 nexthdr = ih->nexthdr;
>> +		__be16 frag_off;
>> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 3, 0)
>> +		protooff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr),
>> +					    &nexthdr, &frag_off);
>> +#else
>> +		protooff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr),
>> +					    &nexthdr);
>> +#endif
>> +		if (protooff < 0 || nexthdr != IPPROTO_ICMPV6 ||
>> +		    !ip_set_get_icmpv6_inner_hdr(skb, &protooff, &ih))
>> +			goto err;
>> +	}
>>     
>
> Move the whole code in the braces into ip_set_get_ipv6_inner_hdr, for the 
> same reason as above.
>   
Noted, will include this in the next version of the patches.

>> +#endif /*_IP_SET_ICMP_H*/
>>     
>
> Move the functions into ip_set_core.c as non-inline ones and export them.
>   
Yep, will do that in the next submission.


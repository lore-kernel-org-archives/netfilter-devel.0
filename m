From: Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v4 0/2] ipset: add "inner" flag version support
Date: Wed, 10 Jul 2013 12:31:59 +0100
Message-ID: <51DD462F.7050601@googlemail.com>
References: <51D74772.7000906@googlemail.com> <alpine.DEB.2.00.1307080940420.27310@blackhole.kfki.hu> <alpine.DEB.2.00.1307081843001.28827@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:38639 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3GJLcH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:32:07 -0400
Received: by mail-wg0-f53.google.com with SMTP id y10so5930895wgg.32
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 04:32:06 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1307081843001.28827@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Jozsef Kadlecsik wrote:
> On Mon, 8 Jul 2013, Jozsef Kadlecsik wrote:
>
>   
>> On Fri, 5 Jul 2013, Dash Four wrote:
>>
>>     
>>> This series of 2 patches supplements the previous version (v3) and adds
>>> "inner" flag version support to all registered ipset types
>>> (kernel + userspace).
>>>
>>> Dash Four (2):
>>>   ipset: add set match "inner" flag support
>>>   ipset (userspace): add "inner" flag version support
>>>       
>> All of your patches (including the previous series) are mangled and I'm 
>> unable to apply them. It seems there's an extra space at the beginning of 
>> every line starting with a whitespace character or something like that. 
>> Please check your patches and resubmit the fixed ones.
>>     
>
> Meanwhile, while looking at your code on how to extend it, I have noticed 
> two issues:
>
> - From ip_set_get_ip4_inner_hdr and ip_set_get_ip6_inner_hdr you pass back
>   the pointer to a local buffer, which is not good.
Why? By "local buffer" I take it you mean the ip header pointer, correct?

>  Please move the local
>   buffer definitions into all of the functions which call *_inner_hdr.
>
> - The second is an optimization issue: for two or more dimensional
>   sets the *_inner_hdr functions are called multiple times instead of 
>   once. *_inner_hdr functions should pass back the pointer to the IP
>   header/buffer (and use simple ip[46]addrptr inline functions on that) 
>   and set protooff for *get_port.
>
>   So it should be something like this:
>
> hash_ipportip4_kadt(...
> 	const struct hash_ipportip *h = set->data;
> 	ipset_adtfn adtfn = set->variant->adt[adt];
> 	struct hash_ipportip4_elem e = { };
> 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
> 	struct iphdr _iph, *iph = &_iph;
> 	unsigned int protooff = ip_hdrlen(skb);
>
> 	if (!ip_set_get_ip4_inner_hdr(skb, &protooff, iph,
> 				opt->cmdflags & IPSET_FLAG_INNER) ||
> 	    !ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
> 				 &e.port, &e.proto, protooff))
> 		return -EINVAL
>
> 	ip4addrptr(iph, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
> 	ip4addrptr(iph, opt->flags & IPSET_DIM_THREE_SRC, &e.ip2);
> 	...
>   
I'll look into this in the next few days - just in case you find 
something else you are unhappy with as I have time constraints and 
cannot afford to be churning out patches on a daily basis.


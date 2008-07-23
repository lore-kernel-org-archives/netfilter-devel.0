From: Patrick McHardy <kaber@trash.net>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Wed, 23 Jul 2008 19:01:39 +0200
Message-ID: <488763F3.5020506@trash.net>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org> <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch> <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch> <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net> <48875887.8040209@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40041 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYGWRBn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:01:43 -0400
In-Reply-To: <48875887.8040209@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Patrick McHardy wrote:
>> Fabian Hugelshofer wrote:
>>> Again most of the time is spent in the kernel. Memory and skb 
>>> operations are accounted there. I suspect that they cause the most 
>>> overhead.
>>>
>>> Do you plan to dig deeper into optimising the non-optimal parts? I 
>>> consider myself not to have enough understanding to do it myself.
>>
>> The first thing to try would be to use sane allocation sizes
>> for the event messages. This patch doesn't implement it properly
>> (uses probing), but should be enough to test whether it helps.
> 
> Thanks a lot. This patch already decreased the CPU usage for ctevtest 
> from 85% to 44%. Sweet...

Nice. Now we just need to do it properly :)

> I created a new callgraph profile which you find attached to this mail. 
> Let's have a look at two parts:
> 
> First:
> 2055      2.7205    ctnetlink_conntrack_event
>   2378     21.6201    nla_put
>   2181     19.8291    nfnetlink_send
>   2055     18.6835    ctnetlink_conntrack_event [self]
>   1250     11.3647    __alloc_skb
>   955       8.6826    ipv4_tuple_to_nlattr
>   752       6.8370    nf_ct_port_tuple_to_nlattr
>   321       2.9184    __memzero
>   220       2.0002    nfnetlink_has_listeners
>   177       1.6092    nf_ct_l4proto_find_get
>   155       1.4092    __nla_put
>   116       1.0546    nf_ct_l3proto_find_get
>   82        0.7455    module_put
>   70        0.6364    nf_ct_l4proto_put
>   66        0.6001    nf_ct_l3proto_put
>   60        0.5455    nlmsg_notify
>   43        0.3909    netlink_has_listeners
>   42        0.3819    __kmalloc
>   37        0.3364    kmem_cache_alloc
>   26        0.2364    __nf_ct_l4proto_find
>   13        0.1182    __irq_svc
> 
> nf_conntrack_event is now one of the first functions listed. Do you see 
> other ways of improving performance?

For some members doing in-place message construction instead of
copying the data might help, but I couldn only spot few only
used rarely.

The module reference stuff (module_put/nf_ct_*_find_get etc)
is clearly superfluous, this runs in packet processing context
and shouldn't use module references but RCU.


> Second:
>   33        2.4775    __nf_ct_ext_add
>   63        4.7297    dev_hard_start_xmit
>   65        4.8799    sock_recvmsg
>   77        5.7808    netif_receive_skb
>   92        6.9069    __nla_put
>   96        7.2072    nf_conntrack_alloc
>   199      14.9399    nf_conntrack_in
>   246      18.4685    skb_copy
>   427      32.0571    nf_ct_invert_tuplepr
> 1793      2.3737    __memzero
>   1793     100.000    __memzero [self]
> 
> Is the zeroing of the inverted tuple in nf_ct_invert_tuple really 
> required? As far as I can see all fields are set by the subsequent code.

It dependfs on the protocol family. For IPv6 its completely
unnecessary, for IPv4 the last 12 bytes of each address need
to be zeroes. We could push this down to the protocols to
behave more optimally (actually something I started and didn't
finish some time ago).

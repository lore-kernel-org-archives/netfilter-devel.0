From: Patrick McHardy <kaber@trash.net>
Subject: Re: policy routing on locally generated packets
Date: Mon, 25 Aug 2003 17:13:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F4A2795.3030805@trash.net>
References: <1061813400.1289.36.camel@drs0.manchotnetworks.net> <3F4A01BE.1090805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
In-Reply-To: <3F4A01BE.1090805@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I don't know what i was thinking, this patch is going to confuse
all kinds of stuff (especially conntrack & nat). Sorry.
Patrick

Patrick McHardy wrote:

> lartc@manchotnetworks.net wrote:
>
>> The statement would force a new routing decision to be made using the
>> properties of the packet as it traverses the nat table, respecting any
>> marking, tos, etc.
>>
>> Could any of you be kind enough to offer an analysis of such a new
>> target, i.e. would it work, would it be terribly complex, ...
>>
>
> A new lookup is performed for outgoing packet if any key affecting
> routing decision is changed. However source address is not influenced
> by this lookup, for locally originating packets it is set to rt_src in
> ip_queue_xmit and ip_build_and_send_pkt but it doesn't happen
> automatically with a new lookup. I'm not sure if it would be possible
> to set a new source address, sockets which are bound to interfaces
> might not accept packets anymore. You could try this patch, it changes
> the packets source after the routing key changed, please make sure
> both unbound and bound sockets work correctly.
>
> Bye
> Patrick
>
>>
>>
>> Sincerely Yours,
>>
>> Charles Shick
>>
>>
>>
>>
>>
>>
>>  
>>
>------------------------------------------------------------------------
>
>===== net/core/netfilter.c 1.23 vs edited =====
>--- 1.23/net/core/netfilter.c	Thu Jul 31 01:57:26 2003
>+++ edited/net/core/netfilter.c	Mon Aug 25 14:25:19 2003
>@@ -645,6 +645,7 @@
> 		/* Drop old route. */
> 		dst_release((*pskb)->dst);
> 		(*pskb)->dst = &rt->u.dst;
>+		iph->saddr = rt->rt_src;
> 	} else {
> 		/* non-local src, find valid iif to satisfy
> 		 * rp-filter when calling ip_route_input. */
>  
>

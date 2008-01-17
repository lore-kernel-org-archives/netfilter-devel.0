From: "Ming-Ching Tiew" <mingching.tiew@redtone.com>
Subject: Tproxy4, fwmark and netfilter route_me_harder
Date: Thu, 17 Jan 2008 10:28:18 +0800
Message-ID: <007001c858b0$9f570db0$8119fea9@MingChing>
References: <2eda2a0a0801101228h230e9d56pd850df9e86a03546@mail.gmail.com> <47878108.50108@redtone.com> <2eda2a0a0801101928l650804aclbdfd101779f45295@mail.gmail.com> <007901c85403$6f690dd0$8119fea9@MingChing> <47873A67.2010406@balabit.hu> <47878F45.4040201@redtone.com> <47879DC5.3050605@balabit.hu> <47883860.8040303@redtone.com> <20080115114237.GA7265@sch.bme.hu> <478F724F.8010900@redtone.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>, <tproxy@lists.balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns2.cnx.com.my ([202.46.113.21]:2487 "EHLO mail.cnx.com.my"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYAQCll (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:41:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


KOVACS Krisztian wrote:
> Hi,
>
> On szo, jan 12, 2008 at 11:47:44 +0800, Ming-Ching Tiew wrote:
>   
>> 2 ) IP FREEBIND packets spoofed with foreign source address will not 
>> leave the system when there is a FWMARK in the mangle table OUTPUT 
>> chain. This patch is created by me based on the information given by 
>> Kovacs, code quality is highly questionable as I barely understood 
>> what's it is all about, but it seems to work.
>>
>> --- linux-2.6.22-org/net/ipv4/netfilter.c       2007-12-13 
>> 20:55:45.000000000 +0800
>> +++ linux-2.6.22-new/net/ipv4/netfilter.c       2007-12-13 
>> 20:55:03.000000000 +0800
>> @@ -24,7 +24,7 @@
>>         /* some non-standard hacks like ipt_REJECT.c:send_reset() can cause
>>          * packets with foreign saddr to appear on the NF_IP_LOCAL_OUT hook.
>>          */
>> -       if (addr_type == RTN_LOCAL) {
>> +//     if (addr_type == RTN_LOCAL) {
>>                 fl.nl_u.ip4_u.daddr = iph->daddr;
>>                 if (type == RTN_LOCAL)
>>                         fl.nl_u.ip4_u.saddr = iph->saddr;
>> @@ -37,10 +37,10 @@
>>                 /* Drop old route. */
>>                 dst_release((*pskb)->dst);
>>                 (*pskb)->dst = &rt->u.dst;
>> -       } else {
>> +//     } else {
>>                 /* non-local src, find valid iif to satisfy
>>                  * rp-filter when calling ip_route_input. */
>> -               fl.nl_u.ip4_u.daddr = iph->saddr;
>> +/*             fl.nl_u.ip4_u.daddr = iph->saddr;
>>                 if (ip_route_output_key(&rt, &fl) != 0)
>>                         return -1;
>>
>> @@ -53,7 +53,7 @@
>>                 dst_release(&rt->u.dst);
>>                 dst_release(odst);
>>         }
>> -
>> +*/
>>         if ((*pskb)->dst->error)
>>                 return -1;
>>     
>
> We should probably first ask on netfilter-devel@ why this whole route
> lookup thing is necessary...
>
>    

I  sort of just forward this to netfilter-devel.
 
For those who in netfilter-devel but not in tproxy mail list, a little 
background here :-
 
I discovered after applying the tproxy4 patch which allows one to spoof 
originating traffic with a foreign IP address ( for the purpose of doing 
transparent proxy ) that after doing it, traffics with foreign IP will 
not leave the system if there is a FWMARK in the mangle table OUTPUT 
chain. Any MARK will screw up the routing.
 
And the patch above seems to be able to get the packets out of the machine
again.

So the motivation here perhaps someone here could throw some light as to 
how this situation is best handled.
 
Regards.


From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: xtables: merge registration structure
 to NFPROTO_UNSPEC
Date: Wed, 31 Mar 2010 11:56:26 +0200
Message-ID: <4BB31C4A.2070209@trash.net>
References: <1270022629-2494-1-git-send-email-jengelh@medozas.de> <1270022629-2494-5-git-send-email-jengelh@medozas.de> <4BB30861.3060101@trash.net> <alpine.LSU.2.01.1003311036110.4527@obet.zrqbmnf.qr> <4BB30AA0.9000904@trash.net> <alpine.LSU.2.01.1003311052490.6475@obet.zrqbmnf.qr> <4BB30F63.2030509@trash.net> <alpine.LSU.2.01.1003311105290.7837@obet.zrqbmnf.qr> <4BB31127.7010409@trash.net> <alpine.LSU.2.01.1003311109310.7837@obet.zrqbmnf.qr> <4BB319AB.8060306@trash.net> <alpine.LSU.2.01.1003311146590.11133@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58685 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab0CaJ42 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:56:28 -0400
In-Reply-To: <alpine.LSU.2.01.1003311146590.11133@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-03-31 11:45, Patrick McHardy wrote:
>   
>>>>>>         
>>>>>>             
>>>>>>>>> This will work because x_tables scans for NFPROTO_UNSPEC,
>>>>>>>>> and arp/ebtables just using x_tables :-)
>>>>>>>>>               
>>>>>>>>>                   
>>>>>>>> I'm not sure I'm parsing this correctly. Both will find the match,
>>>>>>>> however the nf_ct_l3proto_try_module_get() call will fail
>>>>>>>>             
>>>>>>>>                 
>>>>>>> It won't fail - it is using par->family, not par->match->family.
>>>>>>>           
>>>>>>>               
>>>>>> That's broken then.
>>>>>>             
>>> Also, NFPROTO_BRIDGE is special anyway - it does not refer to an L3
>>> protocol actually, but to L2 - so, well, it's kinda moot to muse
>>> about the possibility of calling nf_ct_get(NFPROTO_BRIDGE).
>>>       
>> I assume you mean nf_ct_l3proto_try_module_get(). Just as I was saying,
>> it *will* fail for NFPROTO_BRIDGE/ARP, so everything should be fine. You
>> disputed this however.
>>     
>
> Ah... genuine mixup. I took the "both" in "Both will find the match"
> as iptables and ip6tables because they used to find it before.
>   

OK, so we're fine.
>>>  If you
>>> _really_ wanted to support state matching at the ARP/EB level, you
>>> would anyhow have to add a separate ->check function that loads all
>>> possible L3 trackers. Which is not a big problem per se
>>> (see patch - no touching of NFPROTO_UNSPEC was needed).
>>>   
>>>       
>> That doesn't really work since bridge netfilter is (partially) invoked
>> before conntrack.
>>     
>
> Not everywhere, indeed. But there are three theoretically usable blue boxes
> (input, forward, output) in http://jengelh.medozas.de/images/nf-packet-flow.png
> that come after conntrack. :-)
>   
Maybe, but since bridge netfilter would have to invoke the IPv4/IPv6 hooks
anyways for conntrack, it doesn't seem to be very useful. What I'd like
a lot more would be if ebtables could run conntrack/NAT and other useful
modules directly so we could get rid of most of "integration" mess.
Not sure if that's really possible though.

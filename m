From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ip6tables breaks dnssec?
Date: Wed, 27 Apr 2011 15:01:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104271457190.19268@obet.zrqbmnf.qr>
References: <20110427085755.GD2418@omroep.nl> <alpine.LNX.2.01.1104271200480.12004@obet.zrqbmnf.qr> <4DB7F347.1080107@gmail.com> <alpine.LNX.2.01.1104271321060.10844@obet.zrqbmnf.qr> <4DB81200.8060909@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ulrich Weber <ulrich.weber@googlemail.com>,
	Leo Baltus <Leo.Baltus@omroep.nl>,
	netfilter-devel@vger.kernel.org
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60714 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab1D0NBS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:01:18 -0400
In-Reply-To: <4DB81200.8060909@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-04-27 14:54, Stephen Clark wrote:

> On 04/27/2011 07:22 AM, Jan Engelhardt wrote:
>> On Wednesday 2011-04-27 12:43, Ulrich Weber wrote:
>>
>>   
>>> Each fragmented IPv6 packets will traverse netfilter separately,
>>> in contrast to IPv4, where its only one refragmented packet.
>>>     
>> Not really. All fragments enter nf_hook_slow, be it IPv4 or IPv6.
>> It's just that nf_defrag - which is a netfilter module - collects and
>> suppresses fragments before spitting out the unfragmented one.
>>
>>   
>>> "ip6tables -A INPUT -j ACCEPT -p udp --dport 53" will only match the
>>> first fragment, where the UDP header can be found. To match the
>>> additional fragments, you have to insert these rules:
>>>
>>> ip6tables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
>>> ip6tables -I OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
>>>     
>> That will load nf_conntrack_ipv6, and because conntrack depends on
>> nf_defrag_ipv6, will load that too. Once it is loaded, packets should
>> be defragmented independetly of whether you actually use -m conntrack
>> (or the obsolete -m state) or not.
>>   
> Jan,
>
> are you saying we should be using -m conntrack now instead of -m state and that
> -m state is going away?

-m state is old, redundant (since at least 2.6.12..), - and as such 
ignored whenever possible - but others think removing xt_state is too 
much a message to people..

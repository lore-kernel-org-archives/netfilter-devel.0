From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH:RFC 5/5] bridge-netfilter: use the vlan id as part of
 the connection tracking tuple for bridged traffic
Date: Thu, 01 Apr 2010 13:06:54 +0200
Message-ID: <4BB47E4E.1010506@trash.net>
References: <4BB207B5.2020001@pandora.be> <1269962855.10116.15.camel@edumazet-laptop> <4BB3094C.7000505@trash.net> <4BB47D55.8020704@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50012 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0DALG4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:06:56 -0400
In-Reply-To: <4BB47D55.8020704@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> Patrick McHardy wrote:
>> Eric Dumazet wrote:
>>>>       
>>> This really sounds very strange, layering violation or something.
>>>
>>> You mix conntracking, bridge and vlan here.
>>>     
>> I agree, this is really wrong.
>>   
> Using the conntrack zone workaround to achieve what my patch does is
> basically doing the same thing, IMHO.
> But it's indeed much cleaner to use the generic CT target scheme, which
> also solves the "multiple bridges" scenario mentioned by Pascal. I
> wasn't yet aware of this target.
> 
> I've tested the following setup with 2.6.34-rc3 and it successfully
> separates the networks (without my vlan patch).
> 
> # set up the connection tracking zones
> iptables -t raw -A PREROUTING -m mark --mark 1 -j CT --zone 1
> iptables -t raw -A PREROUTING -m mark --mark 2 -j CT --zone 2
> # mark packets according to the vlan id
> ebtables -t nat -A PREROUTING -p 802_1Q --vlan-id 1 -j mark --mark-set 1
> ebtables -t nat -A PREROUTING -p 802_1Q --vlan-id 5 -j mark --mark-set 2
> 
> So this is good news. The security risk is solvable starting from
> v2.6.34. I'll need to mention this clearly in the documentation.

Great.

> What about the other patches? I'm aware they don't all cleanly patch
> versus the most recent kernel, but do you have any objections apart from
> that?

I haven't fully reviewed them yet, but that should happen soon.

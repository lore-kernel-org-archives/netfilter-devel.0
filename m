From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Thu, 23 Apr 2009 14:12:01 +0200
Message-ID: <49F05B11.8040804@trash.net>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu> <49EC474E.8090604@netfilter.org> <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu> <49EC5794.8090204@netfilter.org> <alpine.DEB.2.00.0904201315030.10463@blackhole.kfki.hu> <49EC896E.5070402@trash.net> <alpine.DEB.2.00.0904201838090.11586@blackhole.kfki.hu> <49EDBA7E.2040200@trash.net> <alpine.DEB.2.00.0904211939040.7297@blackhole.kfki.hu> <49EF3EE4.1090204@trash.net> <alpine.DEB.2.00.0904222234570.10604@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48496 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZDWMMK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:12:10 -0400
In-Reply-To: <alpine.DEB.2.00.0904222234570.10604@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Wed, 22 Apr 2009, Patrick McHardy wrote:
> 
>>> The well-maintained sites manage to locate on-site infected machines by
>>> using IDS, traffic-analysis, etc. However the typical user case for small
>>> sites is that the ISP or other offsite host report an abuse: "your machine
>>> x.y.z.w attacked machine a.b.c.d/added to the RBL because of spamming/etc" -
>>> and the machine x.y.z.w is of course their firewall. And they have got
>>> nothing which could help them to pick the real machine from the NATed
>>> network behind the firewall. And the small sites is the main reason why I'd
>>> favor an "out of the box" solution, which does not rely on anything besides
>>> netfilter/iptables.
>> Yes, but at that point, you can look at your logfiles and see who
>> connected to a.b.c.d and you'll see the internal address. Logging
>> the NATed address is not really helping since you need the internal
>> address anyways, so it seems natural to look at the unNATed information.
>> What am I missing here?
> 
> Hmm, if there are multiple clients connecting to the same external node 
> (or even just a few ones but the exact time is not definite due to the 
> unsynced clocks) then the hunted client does not stand out. But it might 
> indicate multiple infected machines as well...

Yes, you'd need at least destination port numbers to reduce false
positives. But the same is also true if you do log the NATed address.
For the small-site case you describe, the external address is usually
know anyways since there is only a single one :)

Just to be clear about this, I don't generally object to this,
but before making this (quite undesirable IMO) change, I'd like
to be sure that it actually provides a tantamount benefit.
Please feel free to tell me that I'm missing the point :)



From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Wed, 22 Apr 2009 17:59:32 +0200
Message-ID: <49EF3EE4.1090204@trash.net>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu> <49EC474E.8090604@netfilter.org> <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu> <49EC5794.8090204@netfilter.org> <alpine.DEB.2.00.0904201315030.10463@blackhole.kfki.hu> <49EC896E.5070402@trash.net> <alpine.DEB.2.00.0904201838090.11586@blackhole.kfki.hu> <49EDBA7E.2040200@trash.net> <alpine.DEB.2.00.0904211939040.7297@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58717 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZDVP7j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:59:39 -0400
In-Reply-To: <alpine.DEB.2.00.0904211939040.7297@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Tue, 21 Apr 2009, Patrick McHardy wrote:
> 
>> I can see that it has some informational value, but for things like
>> locating infected hosts, why not simply look at the traffic before
>> it is NATed? I currently can't come up with a real use case for
>> this ...
> 
> The well-maintained sites manage to locate on-site infected machines by 
> using IDS, traffic-analysis, etc. However the typical user case for small 
> sites is that the ISP or other offsite host report an abuse: "your machine 
> x.y.z.w attacked machine a.b.c.d/added to the RBL because of spamming/etc" 
> - and the machine x.y.z.w is of course their firewall. And they have got 
> nothing which could help them to pick the real machine from the NATed 
> network behind the firewall. And the small sites is the main reason why 
> I'd favor an "out of the box" solution, which does not rely on anything 
> besides netfilter/iptables.

Yes, but at that point, you can look at your logfiles and see who
connected to a.b.c.d and you'll see the internal address. Logging
the NATed address is not really helping since you need the internal
address anyways, so it seems natural to look at the unNATed information.
What am I missing here?


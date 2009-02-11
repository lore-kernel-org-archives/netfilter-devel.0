From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: xtables: add PKTTYPE target
Date: Wed, 11 Feb 2009 15:54:57 +0100
Message-ID: <4992E6C1.9050207@trash.net>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145826.7501.34671.stgit@Decadence> <4990480D.9060900@trash.net> <4990B910.1050802@netfilter.org> <49918948.5010103@trash.net> <alpine.DEB.2.00.0902101512500.9244@blackhole.kfki.hu> <49918D91.60801@trash.net> <4991C370.9000907@netfilter.org> <4992C3FB.8070606@trash.net> <4992DE8F.5000609@netfilter.org> <4992E219.2090409@trash.net> <4992E5ED.70607@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52466 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbZBKOzB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:55:01 -0500
In-Reply-To: <4992E5ED.70607@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Well, a cast should "fix" that :) But feel free to suggest a
>> better method that doesn't need to expose this as a standalone
>> feature.
> 
> Hm, I forgot another point that is the fact that the PKTTYPE target is
> not always required. Actually, if the switch can flood the same packets
> to a set of nodes that are part of the cluster via "port mirroring" or
> if the switch interprets the VRRP reserved MAC address range correctly
> (I did not find any yet), the nodes in the cluster would not need to use
> with a multicast MAC address, in that case, the PKTTYPE target would not
> be required.
> 
> Well, I'll do the hackish solution if that relieves the possible extra
> bloat of one target that indeed only has this purpose ;). I'll send you
> a new version of the patch asap.

Yeah, its a bit hackish too. Ideally we find a cleaner way, but the
best I could come up with (use MACVLAN to make the multicast address
handled as unicast) isn't any cleaner itself.


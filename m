From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Reserve nfnetlink subsys ids.
Date: Thu, 11 Jun 2009 16:49:51 +0200
Message-ID: <4A31198F.7010004@trash.net>
References: <alpine.DEB.2.00.0906111334090.28605@blackhole.kfki.hu> <4A310FF4.2070207@trash.net> <4A31142E.50707@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54242 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZFKOtu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:49:50 -0400
In-Reply-To: <4A31142E.50707@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Jozsef Kadlecsik wrote:
>>> Hi Patrick,
>>>
>>> A tiny patch to add nfnetlink subsys ids for nftables and ipset. :-)
>> Its usually frowned upon to reserve IDs that are not used yet.
>> We can certainly coordinate so nftables and ipset won't clash
>> unless we add a different subsystem (we actually did, OSF is
>> new in nf-next-2.6.git). But is there a reason for adding the
>> IPSET id at this time instead of waiting until we merge it?
> 
> I think that the problem is that Jozsef then would need to distribute a
> patch for nfnetlink to add the new ipset subsystem. This would make
> easier for him I think.

But there's a patch anyways until its merged, no? I mean, it doesn't
add any code, so it isn't even necessary to rebuild the kernel.

> Moreover, there's a compromise to merge it so, why not include it?

As I said, IDs are usually not reserved until something is merged,
even if there is agreement to merge it. I guess there has been too
much bad experience with reserved IDs and code that never got merged.
I have to justify the patches I merge myself and so far I can't.

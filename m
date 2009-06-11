From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Reserve nfnetlink subsys ids.
Date: Thu, 11 Jun 2009 16:26:54 +0200
Message-ID: <4A31142E.50707@netfilter.org>
References: <alpine.DEB.2.00.0906111334090.28605@blackhole.kfki.hu> <4A310FF4.2070207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60347 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbZFKO1A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:27:00 -0400
In-Reply-To: <4A310FF4.2070207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jozsef Kadlecsik wrote:
>> Hi Patrick,
>>
>> A tiny patch to add nfnetlink subsys ids for nftables and ipset. :-)
> 
> Its usually frowned upon to reserve IDs that are not used yet.
> We can certainly coordinate so nftables and ipset won't clash
> unless we add a different subsystem (we actually did, OSF is
> new in nf-next-2.6.git). But is there a reason for adding the
> IPSET id at this time instead of waiting until we merge it?

I think that the problem is that Jozsef then would need to distribute a
patch for nfnetlink to add the new ipset subsystem. This would make
easier for him I think. Moreover, there's a compromise to merge it so,
why not include it?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Reserve nfnetlink subsys ids.
Date: Fri, 12 Jun 2009 14:08:56 +0200
Message-ID: <4A324558.3020506@trash.net>
References: <alpine.DEB.2.00.0906111334090.28605@blackhole.kfki.hu> <4A310FF4.2070207@trash.net> <4A31142E.50707@netfilter.org> <4A31198F.7010004@trash.net> <alpine.DEB.2.00.0906112349380.30129@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43588 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZFLMI6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:08:58 -0400
In-Reply-To: <alpine.DEB.2.00.0906112349380.30129@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Thu, 11 Jun 2009, Patrick McHardy wrote:
> 
>> Pablo Neira Ayuso wrote:
>>> Patrick McHardy wrote:
>>>> Jozsef Kadlecsik wrote:
>>>>> Hi Patrick,
>>>>>
>>>>> A tiny patch to add nfnetlink subsys ids for nftables and ipset. :-)
>> As I said, IDs are usually not reserved until something is merged,
>> even if there is agreement to merge it. I guess there has been too
>> much bad experience with reserved IDs and code that never got merged.
>> I have to justify the patches I merge myself and so far I can't.
> 
> You're right, of course. I'm going to find another way for a smooth 
> protocol migration.

I didn't mean to finally say no, just wondering if there are special
circumstances which would justify an exception.

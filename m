From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] libnfnetlink byte alignment
Date: Wed, 04 Jun 2008 16:35:28 +0200
Message-ID: <4846A830.8020805@trash.net>
References: <1212488448.29489.40.camel@pumper.lan.luxnet.ch> <484541E0.3020900@trash.net> <48465802.2010005@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42991 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYFDOfa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:35:30 -0400
In-Reply-To: <48465802.2010005@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Patrick McHardy wrote:
>> Fabian Hugelshofer wrote:
>>> Aligns buffers to maximum alignment of architecture to make the cast of
>>> char pointers to struct pointers more portable.
>>>
>>> Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
>>
>> They all seem fine to me, but a union might make it look
>> a bit nicer :)
> 
> In libnfnetlink the union does not make sense, because multiple casts 
> are done from the same buffer at different locations.
> 
> For libnetfilter-(conntrack|log) the union would be possible:
> [...]
> 
> I can rewrite it like this, if desired...

I'll leave that up to Pablo, thanks for the explanation.

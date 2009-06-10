From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 13:01:29 +0200
Message-ID: <4A2F9289.6000502@trash.net>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110841.6702.76228.stgit@Decadence> <4A292DB7.4000000@trash.net> <4A2EE3D2.1090007@netfilter.org> <4A2EE5A3.2000502@trash.net> <4A2EE610.9020207@trash.net> <4A2EE907.70609@netfilter.org> <4A2F09D9.7090507@gmail.com> <4A2F830C.9020403@trash.net> <4A2F8CC7.2010708@netfilter.org> <4A2F9120.9010904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55424 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZFJLB3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:01:29 -0400
In-Reply-To: <4A2F9120.9010904@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Can you see any problem with this optimistic approach? I know, it can
>> potentially try to restore the cache, but this is very unlikely to 
>> happen?
> 
> Its probably quite unlikely, so not a big issue. OTOH this is
> effectively doing something quite similar to a spinlock. Maybe
> its finally time to add per-conntrack locking.
> 
> Eric even had a patch for this IIRC :)

I'll take a quick stab at this, will let you know in 30-60 minutes.


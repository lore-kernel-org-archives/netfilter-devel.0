From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 14:56:04 +0200
Message-ID: <4A2FAD64.7050900@trash.net>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110841.6702.76228.stgit@Decadence> <4A292DB7.4000000@trash.net> <4A2EE3D2.1090007@netfilter.org> <4A2EE5A3.2000502@trash.net> <4A2EE610.9020207@trash.net> <4A2EE907.70609@netfilter.org> <4A2F09D9.7090507@gmail.com> <4A2F830C.9020403@trash.net> <4A2F8CC7.2010708@netfilter.org> <4A2F9120.9010904@trash.net> <4A2F9289.6000502@trash.net> <4A2F9BB8.8020701@trash.net> <4A2FA56D.4090105@netfilter.org> <4A2FA6A9.2090709@trash.net> <4A2FAA6B.3080102@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57909 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbZFJM4F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:56:05 -0400
In-Reply-To: <4A2FAA6B.3080102@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> wrt. the event cache, the missed field can save us from doing the
>>> locking in every event caching at the cost of consuming a bit more of
>>> memory. I think this is more conservative but safer than my approach (no
>>> potential defering by calling cmpxchg forever, even if it's unlikely).
>>> Still, we would need to take the spin lock for the event delivery. Let
>>> me know what you think.
>> Would we really have to? The events are incremental anyways, so
>> it shouldn't matter if we very rarely deliver an event twice.
> 
> No problem. I'll add a comment to tell about this, we can re-visit this
> issue later if it becomes a problem.

Agreed on the comment - I have to insist though that this can't cause
problems based on the duplicate delivery if userspace is using the
API correctly :) We can already have partial deliveries, so userspace
needs to incrementally accumulate the information in any case.

> Please, let me know once you are done with your patch to rebase mine ;).

I'm done.

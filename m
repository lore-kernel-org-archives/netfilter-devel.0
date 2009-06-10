From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event delivery
Date: Wed, 10 Jun 2009 14:30:22 +0200
Message-ID: <4A2FA75E.5040307@trash.net>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110841.6702.76228.stgit@Decadence> <4A292DB7.4000000@trash.net> <4A2EE3D2.1090007@netfilter.org> <4A2EE5A3.2000502@trash.net> <4A2EE610.9020207@trash.net> <4A2EE907.70609@netfilter.org> <4A2F09D9.7090507@gmail.com> <4A2F830C.9020403@trash.net> <4A2F8CC7.2010708@netfilter.org> <4A2F9120.9010904@trash.net> <4A2F9289.6000502@trash.net> <4A2F9BB8.8020701@trash.net> <alpine.DEB.2.00.0906101356370.25631@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57316 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbZFJMaX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:30:23 -0400
In-Reply-To: <alpine.DEB.2.00.0906101356370.25631@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Wed, 10 Jun 2009, Patrick McHardy wrote:
> 
>> This is a first attempt to replace some global locks by private
>> per conntrack locks. On 64 bit, it fits into a hole and doesn't
>> enlarge struct nf_conn.
> [...] 
>> Now is that really better - I'm not sure myself :) The per-conntrack
>> locking would be an improvement though. What do you think?
> 
> I think it's cool and highly required, in order to add per hash bucket 
> locks too :-). And hash bucket locking can even more improve performance. 
> (We need the ordered locking of the buckets for both directions only when 
> entries are added/deleted, otherwise a single read-lock of the given 
> bucket is enough.)

Great, I'll go over it once more and will commit it to my tree.

I'll post a quick note once its committed so Pablo can rebase
his patches.

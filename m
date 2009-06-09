From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 00:45:36 +0200
Message-ID: <4A2EE610.9020207@trash.net>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110841.6702.76228.stgit@Decadence> <4A292DB7.4000000@trash.net> <4A2EE3D2.1090007@netfilter.org> <4A2EE5A3.2000502@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41225 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbZFIWpg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:45:36 -0400
In-Reply-To: <4A2EE5A3.2000502@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Hi Patrick,
>>
>> A couple of minor issues related to this patch.
>>
>> Patrick McHardy wrote:
>>>> +    hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
>>> Why is _rcu used? The lists are never used for a lookup.
>>
>> There's no hlist_nulls_del() operation without rcu. I have a patch here
>> to add hlist_nulls_add_head() and hlist_nulls_del() although I guess
>> that you are going to tell me that you cannot apply that patch? So,
>> where to go?
> 
> Either way is fine I guess. Adding non _rcu function makes sense
> I think (Eric CCed to correct me :)). But there's also no harm
> in using the RCU functions as long as you add a comment stating
> that you don't in fact rely on the RCU properties to avoid confusing
> people.

But to clarify: the non-RCU functions would be preferred :)

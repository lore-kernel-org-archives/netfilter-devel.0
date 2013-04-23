From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [Nftables RFC] High level library proposal
Date: Tue, 23 Apr 2013 13:15:03 +0300
Message-ID: <51765F27.1020703@linux.intel.com>
References: <516EA684.9040209@linux.intel.com> <20130419100531.GA3481@localhost> <517129D8.8000006@linux.intel.com> <20130419121127.GA29452@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Eric Leblond <eric@regit.org>,
	Julien Vehent <julien@linuxwall.info>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17576 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab3DWKPI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:15:08 -0400
In-Reply-To: <20130419121127.GA29452@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>>
>> I am not sure about what you mean. To me, we let the user playing
>> with the same exact statement they will use through nft tool.
> After the parsing, nft generates and abstract syntax tree (see list of
> statements and struct expr for instance). You can use that do build
> the rule-set. You can easily build rules using that tree structure.

Sound relevant. Actually it might fix one of Jesper's use cases to 
export such functions.

>> Btw on the cache feature, it will require some tweaks, since the way
>> libnftables keeps track of objects is not efficient currently:
>> - no specific data (void *) can be attached to any objects (easy fix)
>> - and table chain and rule have no better relationship on the object
>> model than the name.
>> For instance if you want to retrieve all the rules of one chain you
>> need to go through the whole rule list and compare the chain name of
>> each rule.
> That's very easy to fix in the kernel. You only need a small patch for
> nf_tables_api.c to dump only rules attached to one chain.

You got me wrong here. When handling a cache (which gets updated via 
nftables notifications, after a full dump),
the point is to query it easily without the need of kernel calls. Like 
nft_is_chain_present(my_chaine_name), things like that... (just a quick 
example)
In fact, we should lower as much as possible the kernel calls.

Currently, the way libnftables stores the objects is under performing.
As I said if you want to quickly retrieve all rules of 1 chain, you have 
no other possibility right now go through the rule list and compare the 
chain name.
Instead if it would be possible to add our own pointer in a chain (user 
data then) we could add the rule list pointer in the chain. So all chain 
objects would
own a pointer on their rule list. It's a q&d idea, we can solve it 
another way.

And for tables and chain (mostly chains actually), we could store them 
in a hash table: key as the name, object pointer as a value.

Some implementation details like that. Let's figure it out when 
implementing the lib.

>>>> I am thinking of those as well:
>>>>
>>>> NFT_FLAG_FOLLOW_LOCAL (default): will notice about the locally manipulated
>>>> rules events.
>>>> NFT_FLAG_FOLLOW_GLOBAL: will keep notice about the whole rule set event.
>>> Look at existing netfilter libraries like libnftables. All features
>>> should be set via some set/get API, so we won't have hard times to
>>> introduce new tweak and features.
>> That as nothing to do with libnftables set/get stuff.
>>
>> This is for the application notification. In short it tries to
>> answer this: Should it be notified for all nftables event or only
>> about own statements?
> What I'm trying to explain is that all these tweaks and user
> preferences should be done by set/get API similar to
> setsockopt/getsockopt. Not as flags to the main nft_init function.

Still: libnftables does not do anything with netlink send/recv, 
notifications, etc... this is not libnftables related.
For me libnftables is only a nlh parser/builder, and it does it very 
well. Unless you have plans to broaden its features scope?

Anyway let's put aside such flags, let's fix the first thing first: 
executing nft statement and handle notifications.
It will help figuring out advanced features then.


Br,

Tomasz

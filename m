From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [Nftables RFC] High level library proposal
Date: Fri, 19 Apr 2013 14:26:16 +0300
Message-ID: <517129D8.8000006@linux.intel.com>
References: <516EA684.9040209@linux.intel.com> <20130419100531.GA3481@localhost>
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
Received: from mga02.intel.com ([134.134.136.20]:8208 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968046Ab3DSL0U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Apr 2013 07:26:20 -0400
In-Reply-To: <20130419100531.GA3481@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> I am thinking of taking original nft tool's lexer/parser for the statements.
>> It's nice, it works, no need to reinvent the wheel. The change will be on
>> creating libnftables objects instead.
> We can just export the abstract syntax tree functions to build the
> rules.

I am not sure about what you mean. To me, we let the user playing with 
the same exact statement they will use through nft tool.

>
> I've also discussing with Patrick that some even higher level API,
> something simple for users, just like "match tcp port 22" would be
> good to have.

Wait, you want to introduce another statement format? How is it going to 
be simpler than nft tool format?
I don't get the point here.

>> Flags:
>> NFT_FLAG_NL_SYNC (default): using libmnl (already used by libnftables,
>> so no extra dependancy) event_driver and nl_driver are forgotten.
>> NFT_FLAG_NL_ASYNC: Same as previous but a event_driver is at least
>> mandatory.
>> And a nl_driver can be provided to support libnl, others...
> Also commented this with Patrick and I don't think we need this driver
> infrastructure.  We get nothing from supporting two different
> libraries as drivers. All your efforts should focus on libnftables.

It's a requirement for me to be able to use another way to discuss on 
netlink. Let's say it: something else than libmnl or libnl.
And it's not that complicated anyway to handle, as for the event loop 
actually. I am definitely keeping that.

And libnftables has nothing to do with netlink socket layer or event 
loop. Which is actually very good.
In fact libntables will be widely used by the library core. For 
parsing/building nlh message, maintaining the cache. No other lib but 
this one on those task.

Btw on the cache feature, it will require some tweaks, since the way 
libnftables keeps track of objects is not efficient currently:
- no specific data (void *) can be attached to any objects (easy fix)
- and table chain and rule have no better relationship on the object 
model than the name.
For instance if you want to retrieve all the rules of one chain you need 
to go through the whole rule list and compare the chain name of each rule.

For that later one, maybe we can stick on the void* data addition to 
each object structure, and let its usage as we want externally from 
libnftables.
on libnft we could attach the specific table's chain list to it for 
instance, same for chain's rule list etc...

>> I am thinking of those as well:
>>
>> NFT_FLAG_FOLLOW_LOCAL (default): will notice about the locally manipulated
>> rules events.
>> NFT_FLAG_FOLLOW_GLOBAL: will keep notice about the whole rule set event.
> Look at existing netfilter libraries like libnftables. All features
> should be set via some set/get API, so we won't have hard times to
> introduce new tweak and features.

That as nothing to do with libnftables set/get stuff.

This is for the application notification. In short it tries to answer 
this: Should it be notified for all nftables event or only about own 
statements?
Some kind of notification filtering. Might be handled another way 
though. Ideas are welcome.

>> Signature of callback has to be designed further. Event type, handle,
>> user data, ...
>>
>> int nft_set_notification_callback(nft_notification_callback_f):
>> -> notify on nftables event (NFT_FLAG_FOLLOW_* applies)
>>
>> int nft_execute_statement(nft_statement_callback_f, void *user_data,
>>                                          char *statement_format, ...):
> It's very important that you expose the file descriptor that allows
> you to operate with netlink. We provide elaborated abstractions in the
> past that were hidding this details, and they were all leaky
> abstractions in some aspects.
>
> The more control your provide to the client of your library on the
> communication with the kernel, the best. So you can probably have
> something like _send() and _recv() like functions that return high
> level objects rather that callbacks that conceal the internal
> behaviour. You can also define higher level function that do all in
> once for lazy people, but providing different levels of abstractions
> is generally good.

I am fine with that, providing different levels of abstraction. But I am 
pretty sure people will prefer using higher level one: see how 
applications uses iptables tool for instance? Raising a subprocess, it 
is simple (and crap, yes). I bet these people would like to get 
something almost as simple. My point is to provide something that 
simple, yet much better (no sub-process, handling notifications... 
thanks to nftables netlink api) without the requirement for devs to deal 
with netlink stuff by themselves.
But why not exporting so core hooks indeed, can't harm. Let's see.

>> Context based:
>> =============
>>
>> When nft_execute_statement() is nice for one-shot call and forget,
>> some applications might want to follow precisely what's happening in
>> a long-run on nftables rule-set either in general or depending on
>> specific context which can be plural in same application. One might
>> need to temporarily set a certain number of rules dedicated to a
>> situation. This part of the API will help on that.
> Not sure I understand this context based thing. It can help if you
> provide some usecase for it.

Let's say you have an application listening to users logging in. And 
when it happens it sets a bunch of dedicated rules for each users.
When disconnecting, instead of coding one by one "delete this rule, this 
one too etc..." you just disable and free the context.
On nftables notification (i.e. one rule gets deleted by other app), it 
could retrieve quickly to which context so to which user it belongs, and 
it could retry inserting this rule again.
Things like that. Just an example. Of course this could be done in the 
application itself, but it might be nice to provide such abstraction 
already in the lib.

Well, let's put it aside for now. There is already a lot to do first.

>> Listing:
>> =======
>>
>> int nft_setup_list_driver(int flags,
>>                          struct nft_list_driver *driver):
>> -> set the output format for listing the statements
>> flags:  NFT_LIST_DRIVER_XML (current default format in libnftables)
>>          NFT_LIST_DRIVER_JSON (that format idea comes from Julien Vehent)
>>          NFT_LIST_DRIVER_EXTERNAL -> driver should be provided (need small
>>          modifications in libnftables)
> How this external driver thing would look like?

That has to be determined. Something like
{
     void dump_table(buffer, length, table); //buffer or stream?
     void dump_chain(..., chain);
     void dump_rule(..., rule);
}

It would work on libnftables objects.
I haven't thought much about it, but it's required to be able to dump 
the manipulated rule-set.

> I think a good way to see the API proposal is to write a batch of
> use-case example code. So we can all see how the workflow with the
> library will look like before any real library code is written.

I can prepare some.

Br,

Tomasz

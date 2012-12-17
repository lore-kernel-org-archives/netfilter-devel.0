From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Formal submission of Xtables2
Date: Mon, 17 Dec 2012 14:01:07 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212171155090.25980@nerf07.vanv.qr>
References: <20121213120509.GA26118@1984> <alpine.LNX.2.01.1212131405170.786@nerf07.vanv.qr> <20121213142820.GA3489@1984> <alpine.LNX.2.01.1212131528410.1273@nerf07.vanv.qr> <20121213151615.GA6962@1984> <alpine.LNX.2.01.1212131623480.10856@nerf07.vanv.qr>
 <20121213172523.GB14333@1984> <alpine.LNX.2.01.1212131826040.5486@nerf07.vanv.qr> <20121217000841.GA9331@1984> <alpine.LNX.2.01.1212170214350.29351@nerf07.vanv.qr> <20121217095330.GA17148@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20121217095330.GA17148@1984>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Monday 2012-12-17 10:53, Pablo Neira Ayuso wrote:
>>  - It uses a single table because there simply is no need
>>    to have multiple ones. This has benefits for replacement atomicity 
>>    guarantees, and gives some memory previously spent for modules
>>    back to the user, for example.
>
>You can implement this with nftables.
>Actually, nftables allows you to have as many tables as you want.

Multiple table objects are possible in Xtables2, I do not think
it's something exclusive to nft.
It is just that I do not see a usecase and hence a need for multiple
active tables, so the netns only stores one.


>>  - This table is NFPROTO_UNSPEC which means that the duplication of
>>    rules between ip(4)tables and ip6tables users had to make is
>>    gone, meaning less maintenance/complexity/etc. for the administrator, 
>>    and of course, less rules lead to less memory usage.
>
>We have also planned adding agnostic tables to avoid the IPv4/IPv6 cases.

So now xt2 gets copied... hmm must be a successful concept :)


>>  - and because it retains some characteristics, for example
>>    atomic replaces and netns.
>> 
>> >You wrote on Thu, 13 Dec 2012 13:05:09 +0100:
>> >>I don't think that feature-set provides compelling reasons to push [xt2]
>> 
>>    Not everybody cares about these things, that would be unrealistic.
>>    However, some users, and me included, _do have_ an interest in having
>>    what is presented, because they do e.g. run containers. Otherwise,
>>    we would not be having netns in iptables today, right?
>
>Again, those are completely possible with nftables.

There are no traces of pernet operations for nft in 3cb3000158^{tree}.


>> Now, don't dismiss these arguments.
>
>So far, I haven't see any *strong reason* to drop nftables code

In all fairness, I have never said anything about dropping nft.
I am focused on xt2, its inclusion and subsequent maintenance, because 
it resolves the ipt shortcomings in a way that I think appeals most to 
the userspace crowd.


>and write something from scratch as flexible as it is

I am avoiding from-scratch where possible. Given that ip_tables.c
exposes its ABI to userspace so much and deferred ruleset operations
to userspace as well, it is nearly impossible to change, and so
inherently, there will be some new code for any future replacement.
But it is my credo to reuse, and I do.


>my impression is that you don't know how nftables is designed and it 
>works, so you'll have to tell me why I'm wrong.

How are users supposed to know how nftables is designed?

Xtables2 has documentation, explains where and why it deviates from 
iptables. If there is only a doubt in your mind, @Dear Users, mail it -
I want the doc to leave no question unanswered.


If the "flexibility" mentioned above is important to you, I encourage
you to checkout xtables2 and give some thought on how your feature
could be integrated into it. Or rather, I'll offer on top: describe
the feature, and I write it.

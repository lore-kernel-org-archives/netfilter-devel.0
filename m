From: Patrick McHardy <kaber@trash.net>
Subject: Re: xtables Re: Hacking iptables 1.3.5 for 2.6.17
Date: Fri, 30 Jun 2006 18:08:05 +0200
Message-ID: <44A54C65.20906@trash.net>
References: <e82pqq$3es$1@sea.gmane.org>	<200606300948.k5U9mNot001866@toshiba.co.jp>	<44A50091.7070003@ufomechanic.net>	<200606301157.k5UBvJTl016149@toshiba.co.jp>	<44A51BCB.7090006@ufomechanic.net>
	<44A53794.6060405@trash.net> <44A5496C.3030504@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44A5496C.3030504@ufomechanic.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Amin Azez wrote:
> Patrick McHardy wrote:
> 
>>Amin Azez wrote:
>>
>>>I notice a lot of things have moved to net/netfilter/xt_*.c
>>>
>>>Is this an absolute requirement, or is there some compatability system?
>>
>>No requirement, things can just stay where they are.
>>
>>
>>>I'm porting the layer7 match first, currently when adding a layer7 rule
>>>I get (dmesg):
>>>[71987.513531] ip_tables: layer7 match: invalid size 0 != 8452
>>
>>8452? Thats ridiculous much 
> 
> 
> too right! Layer7 permits up to 8192 for the regex - like anyone is
> going to want to run a regex that long on every packet (well the first
> few of each connection)
> 
> Whats anyones feelings on flexible sizes of iptables match structs?

Its not possible with the current architecture, and overcoming this
would probably not be worth it measured in both time and the resulting
uglyness compared to just introducing a netlink interface.

> Right now layer7 does a linear search through a cache of pre-compiled
> regexes with the original regex as the key - PER PACKET - it would make
> much more sense to store a pointer to the cached regex in the matchinfo
> - which is what I'm doing now; but the lack of extra kernelside fields
> is restrictive, so I'm canibalizing (in an ugly way) the last few bytes
> of the refex field.

Thats a bit of a different problem. Per-instance private data will soon
be possible in a nicer way.

>>.. anyway, you need to initialize the
>>.matchsize field to sizeof(struct ...) (the one shared with userspace).
> 
> 
> aye, that works fine, thanks.
> To my surprise I'm getting checkinfo called lots of times, I thought it
> would only be called once when a new rule was being accepted
> kernel-side. Do you know why it would be called many times (with the
> same value matchinfo pointer)

It gets called whenever you add a new rule. Thats a result of the
atomic-exchange of the entire ruleset, each "generation" of your
ruleset (while adding rules incrementally) is an entirely new
ruleset to the kernel.

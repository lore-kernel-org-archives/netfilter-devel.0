From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] priv_data 0/2
Date: Mon, 14 Aug 2006 17:43:29 +0200
Message-ID: <44E09A21.6000503@trash.net>
References: <200606261641.47294.max@nucleus.it>
	<20060814141751.GR7194@kriss.csbnet.se>
	<44E08727.6070403@trash.net>
	<20060814153521.GV7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060814153521.GV7194@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> 2006-08-14 16:22:31+0200, Patrick McHardy <kaber@trash.net> ->
> 
>>Joakim Axelsson wrote:
>>
>>>I'm currently porting some of my modules to use this API with priv_data.
>>>However, I ran into some troubles. For example i'm writing a revision 1 for
>>>the quota module which allows the count to go negative, and in the same time
>>>I'm porting it to use this API (as it's using the same stupid thing as -m
>>>limit with q->master = q;). However, having the quota counter in the
>>>priv_data struct makes it impossible to report the counter to userspace when
>>>the user issues iptables -L.
>>
>>That is actually a bug in the current module IMO (I looked into fixing
>>this yesterday as well). iptables-save/restore won't work properly since
>>they will save the _remaining_ quota, not the one the rule was created
>>with. This might be useful as well, but it diverges from what other
>>modules do.
> 
> Well, the priv_data patch will then solve this problem. As the userspace
> struct will always have the initial quota unaltered. The priv_data quota will
> decrease.

That was the initial idea, forgetting about the atomic table exchange.

> However i guess you want to be able to see both.

Not really "want", its necessary, otherwise the quota will be refilled
on each ruleset update.

> And in my case,
> saving the remaining quota with iptables-save is what i want. (I case of the
> router for some reason craches, the last state must be saved and as accurate
> as possible.)

I can see that this would also be useful, however none of the other
stateful matches does this, so the more important point IMO is to
get quota to do the expected thing. If we can do both, also fine,
but it would have to be optional and I can't see how to cleanly do
this.

> Solution for this might be using two parameters for the userspace struct.
> One for initial quota and one for remaining, saving both. Possible even an
> option saying with figure should be set when iptables-restore is used.

Yes. Without breaking compatibility, we could make quota fixed, use
the master pointer to store the current quota and put the new master
pointer somewhere outside of the struct. But thats really not very
pretty.

> Still, we can't nicly access the remaining quota with priv_data unless the
> modules each time it "matches" writes in both priv_data and userspace info,
> which is kinda ugly.

As I said, I don't see saving current state as necessary (we don't do
it anywhere and it solves an entirely different problem). The
unfortunate fact though is that we need to pass it to userspace anyway,
because of the limitations of the userspace interface.

> There is also the way of using a /proc-entry to list the current remaining
> quota. Also restoring it by echoing a new figure to the entry. Keep the
> iptables-save/restore only with the initial quota figure.
> 
> I can write this if this is what we want?


Definitely not :) We want a better userspace interface that doesn't
require us to put in hacks like this.

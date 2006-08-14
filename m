From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 18:13:37 +0200
Message-ID: <20060814161337.GY7194@kriss.csbnet.se>
References: <44E07BCD.8030206@trash.net>
	<20060814142559.GS7194@kriss.csbnet.se>
	<44E08946.1040105@trash.net>
	<20060814152026.GU7194@kriss.csbnet.se> <44E09746.60302@trash.net>
	<20060814154005.GW7194@kriss.csbnet.se>
	<44E09AF3.2080406@trash.net>
	<20060814155642.GA15328@kriss.csbnet.se>
	<44E09E4F.3040506@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44E09E4F.3040506@trash.net>
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

2006-08-14 18:01:19+0200, Patrick McHardy <kaber@trash.net> ->
> Joakim Axelsson wrote:
> > 2006-08-14 17:46:59+0200, Patrick McHardy <kaber@trash.net> ->
> > 
> >>Thats not true, the master pointer is reinitialized on every change by
> >>the checkentry function (which, as you note, is called on all rules for
> >>every change). The simple reason why it keeps its current state is
> >>because it is dumped to userspace and echoed back. If you move it out of
> >>the structure shared with userspace, this can not happen anymore.
> > 
> > 
> > I think we define reinitiated differently then. I define reinitated by
> > checkentry() being runned even tho the match/rule isn't a new (or altered)
> > match/rule. 
> > 
> > If checkentry() is runned for _all_ matches/targers everytime an unrelated
> > rule is altered then limit will lose its state because the code resets the
> > bucket and refills it.
> 
> 
> You're right. That is actually a bug in my opinion.
> 
> > Meaning that if I have a limit of 1 packet each hour
> > and I change an (unrelated) rule every 30mins the limit will be a limit of 1
> > packet every 30min instead. The (ugly) workaround i posted will solve this
> > issue by keeping track if it has been running the checkentry() before. This
> > is where the priv_data is needed.
> 
> 
> No, we can simply check if f.e. credit is non-zero.
> 

It needs to be coded then :-). It's not the case today.

> > But if you say that the priv_data pointer will be lost for all rules on any
> > alter of rules its kinda void to have it. However a solution keeping that
> > priv_data pointer intact could be very useful. 
> 
> 
> That would mean the kernel needs to associate new rules with rules in
> the old table (or the individual modules itself need to do it somehow,
> like hashlimit or recent). This is really getting too ugly to even
> consider in my opinion, especially since the obvious solution of not
> doing an atomic table exchange also solves a lot of other problems.

I agree. A better solution is needed or no solution at all. However building
a new API that actually only will change the parts it needs to will need a
huge amount of work and will most probably break existing userspace. It will
be very hard to keep backwards compability.

As i see it some new hooks are needed on every module to retrieve the kernel
data. This means we need 5 things:
1. start a new rule/match/target (todays checkentry())
2. remove an old rule/match/target (todays destroy())
3. the worker (todays match() and target())
4. A new 'list' that will feed info needed by iptables -L and iptables-save
to userspace.
5. Possible a new 'alter' that will alter info in the rules/match/targets
private kernel data.

Point 4 and 5 can be views as read and write of the rule. Point 1 and 2 as
create and destroy.

A uniq ID will be needed for each rule so userspace can define which rule it
wishes to alter/remove.

Fairly simple interface to build with netlink. However the real challenge is
to try to keep backward compability. 

--
Joakim Axelsson

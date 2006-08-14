From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 18:40:48 +0200
Message-ID: <20060814164048.GB7194@kriss.csbnet.se>
References: <20060814142559.GS7194@kriss.csbnet.se>
	<44E08946.1040105@trash.net>
	<20060814152026.GU7194@kriss.csbnet.se> <44E09746.60302@trash.net>
	<20060814154005.GW7194@kriss.csbnet.se>
	<44E09AF3.2080406@trash.net>
	<20060814155642.GA15328@kriss.csbnet.se>
	<44E09E4F.3040506@trash.net>
	<20060814161337.GY7194@kriss.csbnet.se> <44E0A42D.604@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44E0A42D.604@trash.net>
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

2006-08-14 18:26:21+0200, Patrick McHardy <kaber@trash.net> ->
> Joakim Axelsson wrote:
> > 2006-08-14 18:01:19+0200, Patrick McHardy <kaber@trash.net> ->
> > 
> >>[...]
> > 
> > I agree. A better solution is needed or no solution at all. However building
> > a new API that actually only will change the parts it needs to will need a
> > huge amount of work and will most probably break existing userspace. It will
> > be very hard to keep backwards compability.
> 
> We need to keep the current API stable of course, but that doesn't
> prevent us from introducing an entirely new one. Matches and targets
> probably can be reused to a certain amount, although I wouldn't
> mind getting rid of the excessive amount of matches doing basically
> the same thing at the same time.
> 
> > As i see it some new hooks are needed on every module to retrieve the kernel
> > data. This means we need 5 things:
> > 1. start a new rule/match/target (todays checkentry())
> > 2. remove an old rule/match/target (todays destroy())
> > 3. the worker (todays match() and target())
> > 4. A new 'list' that will feed info needed by iptables -L and iptables-save
> > to userspace.
> 
> Commonly called dump in other netlink interfaces.
> 
> > 5. Possible a new 'alter' that will alter info in the rules/match/targets
> > private kernel data.
> 
> This is tricky to get right on the rule level, a rule consist of
> multiple elements that would need to be changed atomically.
> 

Yes, sorry. I mean per match/target.

> > Point 4 and 5 can be views as read and write of the rule. Point 1 and 2 as
> > create and destroy.
> > 
> > A uniq ID will be needed for each rule so userspace can define which rule it
> > wishes to alter/remove.
> 
> Yes.
> 
> > Fairly simple interface to build with netlink. However the real challenge is
> > to try to keep backward compability. 
> 
> That is basically impossible. We can keep a compatible command-line
> interface, but the ABI can't be kept compatible. The interface itself
> it quite simple, but we also need new ruleset evaluation functions,
> new loop detection and probably a few other things.

This work is huge, but really needed. I don't feel I am skilled enough to
write it, only contribute with porting matches and other things. I did
however write most of the code that ipset is based on now. So I have the
"extreme amount of hook functions needed" in my back. 

The real question is. Do we really want to force each match/target to
implement a fair amount of functions for it to work? We need to think big
from the start here, not missing some feature that will be hard to add
after. I rather see one too many needed function then one too few.

Is this really something we want? It will most probably end up in a new
ipfwadmin/ipchains/iptables -version. Its the easiest way todo it. Drop the
backward compability completly and possibly only make a new iptables
userspace command-line compability tool using the new API.

--
Joakim Axelsson
 

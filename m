From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 19:11:11 +0200
Message-ID: <20060814171111.GD7194@kriss.csbnet.se>
References: <20060814152026.GU7194@kriss.csbnet.se> <44E09746.60302@trash.net>
	<20060814154005.GW7194@kriss.csbnet.se>
	<44E09AF3.2080406@trash.net>
	<20060814155642.GA15328@kriss.csbnet.se>
	<44E09E4F.3040506@trash.net>
	<20060814161337.GY7194@kriss.csbnet.se> <44E0A42D.604@trash.net>
	<20060814164048.GB7194@kriss.csbnet.se>
	<44E0A9D4.6060704@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44E0A9D4.6060704@trash.net>
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

2006-08-14 18:50:28+0200, Patrick McHardy <kaber@trash.net> ->
> Joakim Axelsson wrote:
> > 2006-08-14 18:26:21+0200, Patrick McHardy <kaber@trash.net> ->
> > 
> >>>5. Possible a new 'alter' that will alter info in the rules/match/targets
> >>>private kernel data.
> >>
> >>This is tricky to get right on the rule level, a rule consist of
> >>multiple elements that would need to be changed atomically.
> >>
> > 
> > Yes, sorry. I mean per match/target.
> 
> 
> Is that really useful without beeing able to change more than
> one component
> 

I don't really understand your consern here?

> >>That is basically impossible. We can keep a compatible command-line
> >>interface, but the ABI can't be kept compatible. The interface itself
> >>it quite simple, but we also need new ruleset evaluation functions,
> >>new loop detection and probably a few other things.
> > 
> > 
> > This work is huge, but really needed. I don't feel I am skilled enough to
> > write it, only contribute with porting matches and other things. I did
> > however write most of the code that ipset is based on now. So I have the
> > "extreme amount of hook functions needed" in my back. 
> > 
> > The real question is. Do we really want to force each match/target to
> > implement a fair amount of functions for it to work? We need to think big
> > from the start here, not missing some feature that will be hard to add
> > after. I rather see one too many needed function then one too few.
> 
> Its not so much. The interface comes down to "init", "destroy", "dump",
> "do something". If we really want "change" it should be possible to
> do it in one function with "init".
> 

So we are down to 4 function:
1. init
2. destroy
3. match/target (use)
4. dump (list)

Meaning an alter is really a "dump, destroy, init"? This might/will give you
atomic problems. I rather add one too many function not being used by most
modules rather than one too few. Remeber its one hook for each modules, not
for each rule. Its not a memory waster. Also think large matcher as recent
here. If we are to skip any /proc -involement we would like to be able to
remove one IP in a recent-match. That's an "alter".

Perhaps we should add one or two "userdefined" functions. Something that the
modules can define for them self to use. For example in the quota-case this
can be "add more quota". It sure will make the new iptables-structure really
flexible. 

Example:
iptables -U1 --match-id xxxxx -m module --params
iptables -U1 --match-id 12345 -m quota --add-quota 4000

We might be able to do this in an alter if we construct the alter to be able
to take commands that the module can specify. Easily done if a seperate
struct is passed with defined data that the module can interpetrate it self.

We will probably be needing to be able to identify a rule and/or a
match/target/module in some way uniqly. A simple tripple (chainname,
rulenumber, matchnumber) might do it though.

> And as I already said, I would like to get rid of the large amount of
> matches doing the same thing anyway. connbytes, connmark, conntrack,
> helper, ... basically all do "take data from conntrack, compare".
> realm, length, pkttype, .. do the same with skb metadata. A lot
> of matches on real packet data are also quite similar. We could
> easily get rid of 50%-75% of all matches and still have the same
> functionality.
>

Just like u32 match. It can replace alot of matches.
 
> > Is this really something we want? It will most probably end up in a new
> > ipfwadmin/ipchains/iptables -version. Its the easiest way todo it. Drop the
> > backward compability completly and possibly only make a new iptables
> > userspace command-line compability tool using the new API.
> 
> We can't do this, people expect to be able to user old versions of
> the iptables tool. But we can introduce a new interface and new
> tools without breaking the old ones.

Chainging to using RCU-list instead of tables will probably break old
iptables badly. We can try writing a new iptables using the new API, but i
guess nobody will be really intressed in doing this work.

--
Joakim Axelsson

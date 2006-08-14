From: Patrick McHardy <kaber@trash.net>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 18:50:28 +0200
Message-ID: <44E0A9D4.6060704@trash.net>
References: <20060814142559.GS7194@kriss.csbnet.se>
	<44E08946.1040105@trash.net>
	<20060814152026.GU7194@kriss.csbnet.se> <44E09746.60302@trash.net>
	<20060814154005.GW7194@kriss.csbnet.se>
	<44E09AF3.2080406@trash.net>
	<20060814155642.GA15328@kriss.csbnet.se>
	<44E09E4F.3040506@trash.net>
	<20060814161337.GY7194@kriss.csbnet.se> <44E0A42D.604@trash.net>
	<20060814164048.GB7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060814164048.GB7194@kriss.csbnet.se>
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
> 2006-08-14 18:26:21+0200, Patrick McHardy <kaber@trash.net> ->
> 
>>>5. Possible a new 'alter' that will alter info in the rules/match/targets
>>>private kernel data.
>>
>>This is tricky to get right on the rule level, a rule consist of
>>multiple elements that would need to be changed atomically.
>>
> 
> Yes, sorry. I mean per match/target.


Is that really useful without beeing able to change more than
one component

>>That is basically impossible. We can keep a compatible command-line
>>interface, but the ABI can't be kept compatible. The interface itself
>>it quite simple, but we also need new ruleset evaluation functions,
>>new loop detection and probably a few other things.
> 
> 
> This work is huge, but really needed. I don't feel I am skilled enough to
> write it, only contribute with porting matches and other things. I did
> however write most of the code that ipset is based on now. So I have the
> "extreme amount of hook functions needed" in my back. 
> 
> The real question is. Do we really want to force each match/target to
> implement a fair amount of functions for it to work? We need to think big
> from the start here, not missing some feature that will be hard to add
> after. I rather see one too many needed function then one too few.

Its not so much. The interface comes down to "init", "destroy", "dump",
"do something". If we really want "change" it should be possible to
do it in one function with "init".

And as I already said, I would like to get rid of the large amount of
matches doing the same thing anyway. connbytes, connmark, conntrack,
helper, ... basically all do "take data from conntrack, compare".
realm, length, pkttype, .. do the same with skb metadata. A lot
of matches on real packet data are also quite similar. We could
easily get rid of 50%-75% of all matches and still have the same
functionality.

> Is this really something we want? It will most probably end up in a new
> ipfwadmin/ipchains/iptables -version. Its the easiest way todo it. Drop the
> backward compability completly and possibly only make a new iptables
> userspace command-line compability tool using the new API.

We can't do this, people expect to be able to user old versions of
the iptables tool. But we can introduce a new interface and new
tools without breaking the old ones.

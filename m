From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: NF structural changes (was: dangerous?)
Date: Wed, 14 Mar 2007 22:23:22 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703142207180.1199@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
	<45F8637D.3060600@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>,
	Hendrik Nordstrom <henrik@henriknordstrom.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F8637D.3060600@trash.net>
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


On Mar 14 2007 22:05, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> As a result of the "dangerous? Setting mark in nat table" thread, I have 
>> just drawn this idea of mine down, where:
>> 
>>  - filter and mangle tables are merged
>
>We need to preserve compatibility (meaning we must keep the rerouting
>in mangle), so I don't see the advantage over simply removing the
>restrictions to mangle.

I think I kept that, did not I? Basically, I took PacketFlow-new, and
removed the filter table - which leaves rerouting working, and turned the
mangle into a filter/mangle (which automatically satisfies the 2nd point).
Or could you please enlighten me a bit what exactly you meant?

>
>>  - filtering comes early, even before nat
>>    (so that, for example, packets do not needlessy be MARKed, mangled,
>etc.)
>
>Would probably make life easier (no more -m conntrack --ctorigdst),

--ctorigdst is still needed (or at least, it's a benefit), in the
filter/mangle-INPUT box and filter/mangle-POSTROUTING.

>but I don't see how this could be changed without breaking rulesets.

Right. Of course this is a problem. To that end, I can really only say
that a divide needs to be made someday. People lived through ipfwadm,
ipchains and now iptables (and a change from one to another required
ruleset changes too). There also have been "minor" annoyances, such as
double-NAT removal (IIRC), and NAT of local outgoing connections (which
left the "warn_if_extra_mangle" function till today). Then support for
multiple ranges got removed in SNAT/DNAT and friends, perhaps breaking a
few rulesets again. The latest breakage was the switch from L3-dependent
to L3-independent. Though POM and external modules are not as supported as
mainline matches/targets, they are useful for a number of people, did not
get compiled, and hence, broke rulesets again. I have compilation fixes
for ROUTE, SYSRQ, ipp2p, time, u32, layer7 to make them work with L3-ind.
tproxy has not been updated yet by balabit.

Let's start a new netfilter that can coexist [at the Kconfig level] with
what people know, therefore making them aware of changes. ("You choose
CONFIG_NETFILTER2, you know your scripts will break.") Perhaps call it
CONFIG_PKTTABLES ;-)



Jan
-- 

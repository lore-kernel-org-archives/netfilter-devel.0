From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Plans for future iptables versions / jumpset feature
Date: Thu, 22 May 2008 21:57:15 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805222140160.9332@fbirervta.pbzchgretzou.qr>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de> <4835C6F0.5080604@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Thomas Jacob <jacob@internet24.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55798 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYEVT5R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 15:57:17 -0400
In-Reply-To: <4835C6F0.5080604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-05-22 21:18, Patrick McHardy wrote:

> Thomas Jacob wrote:
>> Hello list,
>>
>> In a reply to a post last week about netfilter/iptables's performanc=
e
>> (see below for link), Patrick McHardy wrote about him working on a s=
uccessor
>> to iptables that would be able to manipulate
>> single rules in a set without any need to replace the whole
>> ruleset, and that would also include native support
>> for match sets and the like:
>>
>> http://marc.info/?l=3Dnetfilter-devel&m=3D121085934512644

There have been a few changes regarding insertion speed. Even if one
has 500 rules (see that URL), they can probably be optimized using
IPMARK or chaintrees. Also, one should use iptables-restore for
updates, at least when changing more than one rule in a go. Lots of
people fail to actually use it.

Patrick McHardy wrote (see URL):
>Additionally it natively supports sets, bitmaps and hashes, so your
>500 source IP rules can be represented as a single rule with,
>depending on how the IPs are distributed, either O(1) or O(n) lookup
>time.

That sounds just like what ipsets does today. Also, netlink, at least
when using the TLV infrastructure it provides, does not come without
a cost=E2=80=94namely encoding and decoding to/from nlmsg structures. I
suggest to test-run the current binary protocol (a concatenation of
struct ipt_entries etc.) over netlink first before changing it to
something dynamic. Also, from what I have read from the iproute2
source so far, each attribute has an index, and that's rather bad for
add-on modules which want to define arbitrary attributes.

>> Are the plans for that online somewhere? Is there
>> a envisioned time line?
>
> The plans come mostly from multiple discussions on this list
> and in private, as well as my dislikes of certains aspects
> of iptables (like the insane amount of modules).

If it's just the number of source files, then that is an easy
target; these can be collapsed into one file. That would
reduce both compile time and the runtime overhead.

Concrete thoughts: combine
- xt_{CLASSIFY,CONNMARK,CONNSECMARK,MARK,SECMARK,connmark,mark}
- xt_{ah,esp,policy}
- xt_{conntrack,state}, though I'd say let's obsolete xt_state
- xt_{RATEEST,rateest}
- xt_{connbytes,connlimit,length,limit,hashlimit,quota,statistic}
- xt_{ECN,DSCP,HL,TTL,ecn,hl,dscp,ttl}
- xt_{comment,string,time,u32}
- xt_{addrtype,pkttype}
- xt_{hbh,dst,frag,eui64,ipv6header}

>> I'm asking because I'm thinking about whether or not
>> it's feasible and/or sensibly to write some kind
>> of target module that I'm choosing to call "jumpset" for now, that
>> would act as a fast (>O(log(n)) "jump diststribution point".
>
> Thats one of the things I also want to add (halfway finished yet).
> Jumps are regular verdicts in my new design and verdicts can be
> gathered though lookups in sets, hashes etc. So you could do:
>
> unnamed ... -j { 192.168.0.1:chain_1, 192.168.0.2:chain_2, ...}

This comes at the expense of ease-of-use. But you can persuade me to
agree on something =C3=A0 la
	iptables -N 'chainx[0]'
	iptables -N 'chainx[1]'
	iptables -s 192.168.17.0/24 -j 'chainx[]'

> I also want to have the same working for mark etc:
>
> unnamed ... -j MARK --set-mark { 192.168.0.1:1, 192.168.0.2: 2, .. }

See IPMARK.

> or alternatively:
>
> unnamed ... -j MARK --set-mark ip-dst & 0xFF

See IPMARK!

(Hint: http://dev.medozas.de/gitweb.cgi?p=3Dxtables-addons )
Hint2:
	... -j IPMARK --addr dst
	... -j MARK --and-mask 0xFF
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

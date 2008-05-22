From: Patrick McHardy <kaber@trash.net>
Subject: Re: Plans for future iptables versions / jumpset feature
Date: Thu, 22 May 2008 22:15:55 +0200
Message-ID: <4835D47B.8010304@trash.net>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de> <4835C6F0.5080604@trash.net> <alpine.LNX.1.10.0805222140160.9332@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Thomas Jacob <jacob@internet24.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46048 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbYEVURl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 16:17:41 -0400
In-Reply-To: <alpine.LNX.1.10.0805222140160.9332@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2008-05-22 21:18, Patrick McHardy wrote:
>
>  =20
>
>> Additionally it natively supports sets, bitmaps and hashes, so your
>> 500 source IP rules can be represented as a single rule with,
>> depending on how the IPs are distributed, either O(1) or O(n) lookup
>> time.
>>    =20
>
> That sounds just like what ipsets does today.

Yes, but not for arbitary data. Even verdicts (including jumps) and
argument selection for other modules like MARK, ...

>  Also, netlink, at least
> when using the TLV infrastructure it provides, does not come without
> a cost=E2=80=94namely encoding and decoding to/from nlmsg structures.=
 I
> suggest to test-run the current binary protocol (a concatenation of
> struct ipt_entries etc.) over netlink first before changing it to
> something dynamic. Also, from what I have read from the iproute2
> source so far, each attribute has an index, and that's rather bad for
> add-on modules which want to define arbitrary attributes.
>  =20

Netlink message size is limited, but you can of course use
lists of attributes or structures.

>  =20
>>> Are the plans for that online somewhere? Is there
>>> a envisioned time line?
>>>      =20
>> The plans come mostly from multiple discussions on this list
>> and in private, as well as my dislikes of certains aspects
>> of iptables (like the insane amount of modules).
>>    =20
>
> If it's just the number of source files, then that is an easy
> target; these can be collapsed into one file. That would
> reduce both compile time and the runtime overhead.
>
> Concrete thoughts: combine
> - xt_{CLASSIFY,CONNMARK,CONNSECMARK,MARK,SECMARK,connmark,mark}
> - xt_{ah,esp,policy}
> - xt_{conntrack,state}, though I'd say let's obsolete xt_state
> - xt_{RATEEST,rateest}
> - xt_{connbytes,connlimit,length,limit,hashlimit,quota,statistic}
> - xt_{ECN,DSCP,HL,TTL,ecn,hl,dscp,ttl}
> - xt_{comment,string,time,u32}
> - xt_{addrtype,pkttype}
> - xt_{hbh,dst,frag,eui64,ipv6header}

Roughly, there will be:

- data module: any packet data: headers, payload
- meta module: meta-data associated with packet, maybe also conntrack t=
hings
  and others
- maybe conntrack module if not contained in meta module
- existing stateful modules like limit, hashlimit, ...

And whatever is still missing. The logic how to use them will
be completely in userspace. Meaning the data module doesn't
care at all what kind of data it looks at, the set lookup
doesn't care whether its a port number, an IP address or
an ifindex, ...

>  =20
>>> I'm asking because I'm thinking about whether or not
>>> it's feasible and/or sensibly to write some kind
>>> of target module that I'm choosing to call "jumpset" for now, that
>>> would act as a fast (>O(log(n)) "jump diststribution point".
>>>      =20
>> Thats one of the things I also want to add (halfway finished yet).
>> Jumps are regular verdicts in my new design and verdicts can be
>> gathered though lookups in sets, hashes etc. So you could do:
>>
>> unnamed ... -j { 192.168.0.1:chain_1, 192.168.0.2:chain_2, ...}
>>    =20
>
> This comes at the expense of ease-of-use. But you can persuade me to
> agree on something =C3=A0 la
> 	iptables -N 'chainx[0]'
> 	iptables -N 'chainx[1]'
> 	iptables -s 192.168.17.0/24 -j 'chainx[]'
>  =20

Thats not any simpler. Besides such optimization also may be
performed by the userspace tool, the user doesn't necessarily
has to do them himself. Though this is not planned for an
initial version.

>  =20
>> I also want to have the same working for mark etc:
>>
>> unnamed ... -j MARK --set-mark { 192.168.0.1:1, 192.168.0.2: 2, .. }
>>    =20
>
> See IPMARK.
>
>  =20
>> or alternatively:
>>
>> unnamed ... -j MARK --set-mark ip-dst & 0xFF
>>    =20
>
> See IPMARK!
>
> (Hint: http://dev.medozas.de/gitweb.cgi?p=3Dxtables-addons )
> Hint2:
> 	... -j IPMARK --addr dst
> 	... -j MARK --and-mask 0xFF
>  =20

1. So?

2. You don't get it. Thats another special-casing module, exactly
the think I *don't* like. How many more of these (with slightly
differing semantic and features) should we add?


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

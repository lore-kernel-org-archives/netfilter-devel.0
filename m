From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH:RFC 5/5] bridge-netfilter: use the vlan id as part of
 the connection tracking tuple for bridged traffic
Date: Thu, 01 Apr 2010 13:02:45 +0200
Message-ID: <4BB47D55.8020704@pandora.be>
References: <4BB207B5.2020001@pandora.be> <1269962855.10116.15.camel@edumazet-laptop> <4BB3094C.7000505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:42568 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab0DALCu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:02:50 -0400
In-Reply-To: <4BB3094C.7000505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Eric Dumazet wrote:
>  =20
>> Le mardi 30 mars 2010 =E0 16:16 +0200, Bart De Schuymer a =E9crit :
>>    =20
>>> @@ -163,7 +166,11 @@ static inline bool __nf_ct_tuple_dst_equ
>>>  {
>>>  	return (nf_inet_addr_cmp(&t1->dst.u3, &t2->dst.u3) &&
>>>  		t1->dst.u.all =3D=3D t2->dst.u.all &&
>>> -		t1->dst.protonum =3D=3D t2->dst.protonum);
>>> +		t1->dst.protonum =3D=3D t2->dst.protonum
>>> +#ifdef CONFIG_BRIDGE_NETFILTER
>>> +		&& likely(t1->dst.vlan_id =3D=3D t2->dst.vlan_id)
>>> +#endif
>>> +		);
>>>  }
>>> =20
>>>  static inline bool nf_ct_tuple_equal(const struct nf_conntrack_tup=
le *t1,
>>>
>>>      =20
>> This really sounds very strange, layering violation or something.
>>
>> You mix conntracking, bridge and vlan here.
>>    =20
>
> I agree, this is really wrong.
>  =20
Using the conntrack zone workaround to achieve what my patch does is
basically doing the same thing, IMHO.
But it's indeed much cleaner to use the generic CT target scheme, which
also solves the "multiple bridges" scenario mentioned by Pascal. I
wasn't yet aware of this target.

I've tested the following setup with 2.6.34-rc3 and it successfully
separates the networks (without my vlan patch).

# set up the connection tracking zones
iptables -t raw -A PREROUTING -m mark --mark 1 -j CT --zone 1
iptables -t raw -A PREROUTING -m mark --mark 2 -j CT --zone 2
# mark packets according to the vlan id
ebtables -t nat -A PREROUTING -p 802_1Q --vlan-id 1 -j mark --mark-set =
1
ebtables -t nat -A PREROUTING -p 802_1Q --vlan-id 5 -j mark --mark-set =
2

So this is good news. The security risk is solvable starting from
v2.6.34. I'll need to mention this clearly in the documentation.

What about the other patches? I'm aware they don't all cleanly patch
versus the most recent kernel, but do you have any objections apart fro=
m
that?

cheers,
Bart

--=20
Bart De Schuymer
www.artinalgorithms.be

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

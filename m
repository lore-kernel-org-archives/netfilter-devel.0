From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH:RFC 5/5] bridge-netfilter: use the vlan id as part of
 the connection tracking tuple for bridged traffic
Date: Wed, 31 Mar 2010 10:35:24 +0200
Message-ID: <4BB3094C.7000505@trash.net>
References: <4BB207B5.2020001@pandora.be> <1269962855.10116.15.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57086 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab0CaIfZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:35:25 -0400
In-Reply-To: <1269962855.10116.15.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> Le mardi 30 mars 2010 =E0 16:16 +0200, Bart De Schuymer a =E9crit :
>> @@ -163,7 +166,11 @@ static inline bool __nf_ct_tuple_dst_equ
>>  {
>>  	return (nf_inet_addr_cmp(&t1->dst.u3, &t2->dst.u3) &&
>>  		t1->dst.u.all =3D=3D t2->dst.u.all &&
>> -		t1->dst.protonum =3D=3D t2->dst.protonum);
>> +		t1->dst.protonum =3D=3D t2->dst.protonum
>> +#ifdef CONFIG_BRIDGE_NETFILTER
>> +		&& likely(t1->dst.vlan_id =3D=3D t2->dst.vlan_id)
>> +#endif
>> +		);
>>  }
>> =20
>>  static inline bool nf_ct_tuple_equal(const struct nf_conntrack_tupl=
e *t1,
>>
>=20
> This really sounds very strange, layering violation or something.
>=20
> You mix conntracking, bridge and vlan here.

I agree, this is really wrong.

> Why setups without bridge should not care of vlan + conntracking side
> effects ?
>=20
> This whole idea was discussed last November :=20
>=20
> http://www.spinics.net/lists/netfilter-devel/msg10692.html
>=20
> Patrick spoke of 'conntrack zone', and we added this concept.

Indeed, this seems like a better way.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

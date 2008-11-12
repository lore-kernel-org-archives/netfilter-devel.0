From: Patrick McHardy <kaber@trash.net>
Subject: Re: libiptc, arptables, ebtables plans or so - and header files
Date: Wed, 12 Nov 2008 12:13:23 +0100
Message-ID: <491ABA53.8040703@trash.net>
References: <alpine.LNX.1.10.0811101726310.23956@fbirervta.pbzchgretzou.qr> <49187862.50306@trash.net> <alpine.LNX.1.10.0811101936100.3005@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38560 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbYKLLNZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:13:25 -0500
In-Reply-To: <alpine.LNX.1.10.0811101936100.3005@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-11-10 19:07, Patrick McHardy wrote:
>> Without having looked at it in much detail, I think it should
>> be pretty easy to define per-family functions to fill the
>> ipt_entry/ip6t_entry structs and a struct to describe the
>> length and offset differences. The remaining parts are invariant
>> across families, so the code should be easily unifiable.
>=20
> struct iptc_handle {
> 	struct ipt_getinfo {
> 	};
> 	struct ipt_get_entries {
> 		struct ipt_entry [];
> 	};
> };
>=20
> TC_INIT/create_tc_socket(table)
> {
> 	STRUCT_GETINFO info;
> 	strcpy(info.name, table);
> 	getsockopt(sockfd, TC_IPPROTO, SO_GET_INFO, &info...);
> 	h =3D alloc_handle(info.name, info.size, info.num_entries);
> }
>=20
> Just look at this pseudocode. The primitive transformation approach w=
ould be
>=20
> 	create_v4_socket(table)
> 	{
> 		struct ip6t_getinfo info;
> 		strcpy...
> 		getsockopt..
> 		h =3D alloc_handle...
> 	}
> =09
> 	create_v6_socket(table)
> 	{
> 		struct ip6t_getinfo info;
> 		strcpy...
> 		getsockopt..
> 		h =3D alloc_handle...
> 	}
> =09
> 	create_socket(table, proto)
> 	{
> 		return proto_vft[proto]->create_socket(table)
> 	}
>=20
> This because every line where a member of info is accessed is
> essentially af-dependent already.

An af-dependant function to get a pointer to the sub-structures
might simplify this a bit.

> And I am not even down to
> ipt_entry. It's not clear what to do here -- apart from ugly
> tricks to record the offsets of members and then dereferencing
> through void =E0 la  (char *)(((void *)&info) + af->name_offset).

proto_vft[proto]->fill_entry(...)?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

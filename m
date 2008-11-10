From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: libiptc, arptables, ebtables plans or so - and header files
Date: Mon, 10 Nov 2008 19:47:52 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811101936100.3005@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0811101726310.23956@fbirervta.pbzchgretzou.qr> <49187862.50306@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41627 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbYKJSrz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:47:55 -0500
In-Reply-To: <49187862.50306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-11-10 19:07, Patrick McHardy wrote:
>
> Without having looked at it in much detail, I think it should
> be pretty easy to define per-family functions to fill the
> ipt_entry/ip6t_entry structs and a struct to describe the
> length and offset differences. The remaining parts are invariant
> across families, so the code should be easily unifiable.

struct iptc_handle {
	struct ipt_getinfo {
	};
	struct ipt_get_entries {
		struct ipt_entry [];
	};
};

TC_INIT/create_tc_socket(table)
{
	STRUCT_GETINFO info;
	strcpy(info.name, table);
	getsockopt(sockfd, TC_IPPROTO, SO_GET_INFO, &info...);
	h =3D alloc_handle(info.name, info.size, info.num_entries);
}

Just look at this pseudocode. The primitive transformation approach wou=
ld be

	create_v4_socket(table)
	{
		struct ip6t_getinfo info;
		strcpy...
		getsockopt..
		h =3D alloc_handle...
	}
=09
	create_v6_socket(table)
	{
		struct ip6t_getinfo info;
		strcpy...
		getsockopt..
		h =3D alloc_handle...
	}
=09
	create_socket(table, proto)
	{
		return proto_vft[proto]->create_socket(table)
	}

This because every line where a member of info is accessed is
essentially af-dependent already. And I am not even down to
ipt_entry. It's not clear what to do here -- apart from ugly
tricks to record the offsets of members and then dereferencing
through void =C3=A0 la  (char *)(((void *)&info) + af->name_offset).
(Where's Captain Obvious when you need him?!)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

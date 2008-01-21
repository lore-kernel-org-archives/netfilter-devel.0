From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: xt_owner-xt_socket plans
Date: Mon, 21 Jan 2008 12:58:26 +0100
Message-ID: <479488E2.6000604@balabit.hu>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr> <479461C2.1060703@balabit.hu> <Pine.LNX.4.64.0801211156320.24186@fbirervta.pbzchgretzou.qr>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:51428 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759070AbYAUL63 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 06:58:29 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 09456C15F7
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Jan 2008 12:58:28 +0100 (CET)
In-Reply-To: <Pine.LNX.4.64.0801211156320.24186@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt =EDrta:
> On Jan 21 2008 10:11, Laszlo Attila Toth wrote:
>> http://people.netfilter.org/hidden/tproxy/tproxy4-2.6.24-20071019005=
0.tar.bz2
>>
> In the xt_socket code, I just noticed:
>=20
> 	struct udphdr *hp;
> 	hp =3D skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_hdr), &_hdr);
>=20
> Does that mean xt_socket only receives UDP? Also, the header should a=
lways be
> available so that skb_header_pointer is not necessary.
> Where am I being misled?
>=20

No, both tcp and udp packets are receiving.

Usage of udphdr is beacuse the first two members of the struct=20
{udp,tcp}hdr types are the same, they are the source and destionation=20
ports, and they are used as parameters of nf_tproxy_get_sock_v4 functio=
n:
          __be16  source;
          __be16  dest;

Either tcphdr or udphdr can be used, and the latter one is the simplier=
=20
type.


--=20
Attila
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

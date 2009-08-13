From: Patrick McHardy <kaber@trash.net>
Subject: Re: [bug?] netfilter/ipvs : suspected race bugs related to atomic
 	operations
Date: Thu, 13 Aug 2009 15:44:27 +0200
Message-ID: <4A8418BB.4060100@trash.net>
References: <2014bcab0908120743w2d96c359t818729b64c9da62b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Wensong Zhang <wensong@linux-vs.org>,
	Horms <horms@verge.net.au>
To: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63250 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZHMNod (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2009 09:44:33 -0400
In-Reply-To: <2014bcab0908120743w2d96c359t818729b64c9da62b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=ED=99=8D=EC=8B=A0 shin hong wrote:
> Hi. I am reporting two suspected race bug related to atomic operation=
s
> while I read net/netfilter/ipvs of Linux 2.6.30.4.
>=20
> (1) In net/netfilter/ipvs/ip_vs_core.c, ip_vs_in() first increments &=
cp->in_pkts
>      and then reads variable for condition checking at line 1346-1351=
=2E
>=20
>      However, these two atomic operations may not be executed atomica=
lly.
>      For this reason, it may result race with other concurrent execut=
ions
>      which manipulates &cp->in_pkts.
>=20
> (2) In net/netfilter/ipvs/ip_vs_wrr.c, ip_vs_wrr_max_weight() first
> checks &dest->weight
>      and then reads the variable again to assign its value to a local=
 variable.
>      For the similar reason above, it seems that two atomic_read() op=
erations
>      may result different values so that it may result race condition=
=2E
>=20
> Please examine the code and let me know your opinion. Thanks.

I'm not sure whether the IPVS guys are following the netfilter-devel
list, so I've CCed Wensong and Simon.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

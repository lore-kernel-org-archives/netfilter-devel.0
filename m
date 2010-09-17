From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: problem with flowi structure
Date: Fri, 17 Sep 2010 18:34:55 +0200
Message-ID: <1284741295.3391.100.camel@edumazet-laptop>
References: <AANLkTi=bGsvMqnTSanA73FhDH_DashmXTcA1sddtj0P6@mail.gmail.com>
	 <1284650768.3352.37.camel@edumazet-laptop>
	 <AANLkTimo1AeBS3rpQj0KtZL15Ct-DGTQMBUsL8hrVNOL@mail.gmail.com>
	 <1284652453.3352.38.camel@edumazet-laptop>
	 <AANLkTi=Y7beG4vPDx5eNg-gTN1CVg_G=1+dWwi2Xd2-R@mail.gmail.com>
	 <AANLkTim7TeMCG9RQyrrk8WS4+S_y1q06+8FG2-X=1cB-@mail.gmail.com>
	 <AANLkTimpnqNSE21u=2qjb5VGJrn_3_--Bqp4veCNXMPE@mail.gmail.com>
	 <1284714533.3391.53.camel@edumazet-laptop>
	 <AANLkTi=r__RA=5UfNnhsKizDF6OFVYXcSe9KOPx1zW0u@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: AIJAZ BAIG <aijazbaig1@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev@vger.kernel.org
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48644 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab0IQQfA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:35:00 -0400
In-Reply-To: <AANLkTi=r__RA=5UfNnhsKizDF6OFVYXcSe9KOPx1zW0u@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 17 septembre 2010 =C3=A0 18:27 +0200, Nicola Padovano a =C3=
=A9crit :
> > With different keys (src addr, tos, fwmark, ...) we can have a lot =
of
> > different routes for apparently same destination
> and why this reasoning it isn't present on the routing table?
> I mean: there will be a reason for which this isn't present in the ro=
uting table
>=20
>=20

It is present, of course, since route cache can be flushed (or
bypassed), you need to be able to rebuild it from a stable reference.

ip rule ls

ip ro list table xxx



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

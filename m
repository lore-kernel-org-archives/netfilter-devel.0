From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: problem with flowi structure
Date: Thu, 16 Sep 2010 17:54:13 +0200
Message-ID: <1284652453.3352.38.camel@edumazet-laptop>
References: <AANLkTi=bGsvMqnTSanA73FhDH_DashmXTcA1sddtj0P6@mail.gmail.com>
	 <1284650768.3352.37.camel@edumazet-laptop>
	 <AANLkTimo1AeBS3rpQj0KtZL15Ct-DGTQMBUsL8hrVNOL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev@vger.kernel.org
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57192 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0IPPyS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:54:18 -0400
In-Reply-To: <AANLkTimo1AeBS3rpQj0KtZL15Ct-DGTQMBUsL8hrVNOL@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 16 septembre 2010 =C3=A0 17:30 +0200, Nicola Padovano a =C3=A9=
crit :
> > This means ip_route_output_key() is allowed to chose whatever sourc=
e ip
> > address to reach remote peer.
>=20
> I don't well understand it yet...what is the reason for choosing
> whatever source ip?
>=20
>=20
>=20

Because some users want a particular source IP ?

man bind



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: iproute2: use automake
Date: Mon, 15 Nov 2010 23:32:36 +0100
Message-ID: <1289860356.3364.19.camel@edumazet-laptop>
References: <1289859785-3098-1-git-send-email-jengelh@medozas.de>
	 <20101115142600.66a7e3c3@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>, stephen.hemminger@vyatta.com,
	netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59127 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665Ab0KOWcs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:32:48 -0500
Received: by eye27 with SMTP id 27so3305556eye.19
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2010 14:32:46 -0800 (PST)
In-Reply-To: <20101115142600.66a7e3c3@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 15 novembre 2010 =C3=A0 14:26 -0800, Stephen Hemminger a =C3=A9=
crit :
> On Mon, 15 Nov 2010 23:23:02 +0100
> Jan Engelhardt <jengelh@medozas.de> wrote:
>=20
> >=20
> > The following changes since commit 3f5c1a01e6bc15593635705aa0b19dca=
c965be26:
> >=20
> >   Update to 2.6.36 headers (2010-10-20 17:38:04 -0700)
> >=20
> > are available in the git repository at:
> >   git://dev.medozas.de/iproute2 master
> >=20
> > Jan Engelhardt (2):
> >       Fix up permissions on scripts
> >       build: start using Automake for building
>=20
> NAK. I agree with Alexey, automake is an abomination.
>=20
>=20

Jan, if you have some free time, could you take a look at=20

ip link show dev xxxxx

to _not_ use 'dump all interfaces and zap all but one'=20

;)

Also, iproute2 patches should be CCed to netdev

Thanks !


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

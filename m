From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fixing to check the lower bound of valid ACK
Date: Wed, 25 Jun 2008 12:50:50 +0200
Message-ID: <4862230A.4040002@trash.net>
References: <Pine.LNX.4.64.0806251151400.21979@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?ISO-8859-15?Q?Thomas_B=E4tzler?= <t.baetzler@bringe.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49599 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbYFYKuz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:50:55 -0400
In-Reply-To: <Pine.LNX.4.64.0806251151400.21979@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> Hi Patrick,
>=20
> Lost connections was reported by Thomas B=E4tzler (running 2.6.25 ker=
nel) on=20
> the netfilter mailing list (see the thread "Weird nat/conntrack Probl=
em=20
> with PASV FTP upload"). He provided tcpdump recordings which helped t=
o=20
> find a long lingering bug in conntrack.
>=20
> In TCP connection tracking, checking the lower bound of valid ACK cou=
ld=20
> lead to mark valid packets as INVALID because:
>=20
>  - We have got a "higher or equal" inequality, but the test checked
>    the "higher" condition only; fixed.
>  - If the packet contains a SACK option, it could occur that the ACK
>    value was before the left edge of our (S)ACK "window": if a previo=
us
>    packet from the other party intersected the right edge of the wind=
ow
>    of the receiver, we could move forward the window parameters beyon=
d
>    accepting a valid ack. Therefore in this patch we check the rightm=
ost
>    SACK edge instead of the ACK value in the lower bound of valid (S)=
ACK
>    test.

Applied, thanks. I'll also push this patch to -stable once
its in Linus' tree.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

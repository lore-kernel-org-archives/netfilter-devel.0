From: David Miller <davem@davemloft.net>
Subject: Re: netfilter: nf_conntrack_tcp: fixing to check the lower bound
 of valid ACK
Date: Mon, 30 Jun 2008 12:43:47 -0700 (PDT)
Message-ID: <20080630.124347.261417798.davem@davemloft.net>
References: <20080630155609.24326.34250.sendpatchset@localhost.localdomain>
	<20080630155610.24326.75331.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56840
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbYF3Tnr convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:43:47 -0400
In-Reply-To: <20080630155610.24326.75331.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>
Date: Mon, 30 Jun 2008 17:56:10 +0200 (MEST)

> netfilter: nf_conntrack_tcp: fixing to check the lower bound of valid=
 ACK
>=20
> Lost connections was reported by Thomas B=E4tzler (running 2.6.25 ker=
nel) on
> the netfilter mailing list (see the thread "Weird nat/conntrack Probl=
em
> with PASV FTP upload"). He provided tcpdump recordings which helped t=
o
> find a long lingering bug in conntrack.
>=20
> In TCP connection tracking, checking the lower bound of valid ACK cou=
ld
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
>=20
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

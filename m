From: d i <navilein@hotmail.com>
Subject: RE: loopback forwarding not working (aka implicit source local NAT)
Date: Thu, 18 Sep 2008 15:56:34 +0000
Message-ID: <BLU144-W65E390B10D162E55F8657D14F0@phx.gbl>
References: <BLU144-W44C48F9DBE68BEE223EE6FD14C0@phx.gbl>
 <alpine.LNX.1.10.0809171309130.14575@fbirervta.pbzchgretzou.qr>
 <BLU144-W62E5044D0CD5A32D3132FD14C0@phx.gbl>
 <alpine.LNX.1.10.0809171934190.1817@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blu0-omc1-s29.blu0.hotmail.com ([65.55.116.40]:27733 "EHLO
	blu0-omc1-s29.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754613AbYIRP4f convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:56:35 -0400
In-Reply-To: <alpine.LNX.1.10.0809171934190.1817@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>>any commercial application is likely to create extra unnecessary
>>overhead and complications. a kernel based solution is much cleaner
>>and lighter.  yes, i have the ssh on top of it, but i can live with
>>that. i'm using the tunnel for other things as well.
>=20
> Then openswan is probably your best bet.


you know, i have 2 machines in my subnet, and my router is a 20 years o=
ld thing, with 64MB Ram, and 166 MHz...
this openswan and vpn in general, seem to me dedicate for larger and mo=
re .... professional environments. I will look into your suggestion of =
using openswan, but (based on my knowledge so far) i would really prefe=
r something more basic, light and simple=20

searching more on the net I found some references to the RAWDNET and RA=
WSNET targets for the RAW table. but neither work with my iptables (ver=
=2E 1.4.0)

is there any information available about this by any chance ? could you=
 tell me anything more about the RAW table, that is not in the man page=
l (there isn't much in the man page about this)?

thanks!
_________________________________________________________________
Connect to the next generation of MSN Messenger=A0
http://imagine-msn.com/messenger/launch80/default.aspx?locale=3Den-us&s=
ource=3Dwlmailtagline--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

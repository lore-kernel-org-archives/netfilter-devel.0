From: Robby Workman <rw@rlworkman.net>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.3
Date: Mon, 23 Mar 2009 11:38:02 -0500
Message-ID: <20090323113802.4694b205@liberty.rlwhome.lan>
References: <49C79C90.80804@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:52696 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980AbZCWQiY convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:38:24 -0400
In-Reply-To: <49C79C90.80804@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 23 Mar 2009 15:28:32 +0100
Patrick McHardy <kaber@trash.net> wrote:

> The netfilter coreteam presents:
>=20
>      iptables version 1.4.3


Jan,

Is this a problem locally here, or can you reproduce?
Seems to be introduced with iptables-1.4.3, as xtables-addons-1.12
builds fine with iptables-1.4.2 installed.

make[3]: Leaving directory
`/tmp/xtables-addons-1.12/extensions/ipset' CC
libxt_DHCPADDR.oo In file included from libxt_DHCPADDR.c:19:
mac.c: In function =E2=80=98mac_parse=E2=80=99:
mac.c:22: warning: implicit declaration of function =E2=80=98strtonum=E2=
=80=99
libxt_DHCPADDR.c: In function =E2=80=98dhcpaddr_tg_parse=E2=80=99:
libxt_DHCPADDR.c:45: warning: implicit declaration of function
=E2=80=98param_act=E2=80=99 libxt_DHCPADDR.c:45: error: =E2=80=98P_ONLY=
_ONCE=E2=80=99 undeclared (first
use in this function) libxt_DHCPADDR.c:45: error: (Each undeclared
identifier is reported only once libxt_DHCPADDR.c:45: error: for each
function it appears in.) libxt_DHCPADDR.c:46: error: =E2=80=98P_NO_INVE=
RT=E2=80=99
undeclared (first use in this function) libxt_DHCPADDR.c:48: error:
=E2=80=98P_BAD_VALUE=E2=80=99 undeclared (first use in this function) l=
ibxt_DHCPADDR.c:
In function =E2=80=98dhcpaddr_tg_check=E2=80=99: libxt_DHCPADDR.c:59: w=
arning: implicit
declaration of function =E2=80=98exit_error=E2=80=99 make[2]: *** [libx=
t_DHCPADDR.oo]
Error 1 make[2]: Leaving directory
`/tmp/xtables-addons-1.12/extensions' make[1]: *** [all-recursive]
Error 1 make[1]: Leaving directory `/tmp/xtables-addons-1.12'
make: *** [all] Error 2


-RW
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

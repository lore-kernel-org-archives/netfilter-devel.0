From: Amin Azez <azez@ufomechanic.net>
Subject: RE: [PATCH] xt_gateway match
Date: Mon, 4 Jun 2007 11:14:26 +0100
Message-ID: <200706041133.l54BXqv07802@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Sorry for the horrible quoting style, pocket outlook is nasty, and the herm=
es linux port isn't progressed enough for me to switch...

Thanks for looking at this, Jan. I'm away from a testing box right now, but=
 I think you got a test wrong. The gateway test is meant to exclude cases w=
here the neighbour table matches AND the daddr matches, because that means =
the packet wasn't routed to that target AS a gateway.

For nexthop we don't want to match daddr regardless, only if it is also mat=
ching the neighbor table.

Gateway: match neighbourtable and not match daddr
Nexthop: match neighbour table.

Note: if --gateway is used, a downstream snat'd network can't ping the gate=
way (no math, no snat) but can ping beyond the gateway.

Sam
-----Original Message-----
From: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
To: "Amin Azez" <azez@ufomechanic.net>
Cc: netfilter-devel@lists.netfilter.org
Sent: 02/06/07 17:56
Subject: [PATCH] xt_gateway match
...
+               info->flags ^=3D info->flags & IPT_GATEWAY_ROUTE;          =
      =20

Stunning line.

So, I refreshed this to be xtables-style, xt_gateway. It builds cleanly,
but only done limited testing on it yet. Especially, I decoupled that
bigass return statement to make it easier to read. I hope I got all the
conditions right.

How things look:
 inet 192.168.222.36/24
 default gw 192.168.222.1

What I did:
 iptables -A OUTPUT -m gateway --gateway 192.168.222.1
 iptables -A OUTPUT -m gateway --nexthop 192.168.222.1
 ping -c1 192.168.222.1
 iptables -nvL
    +1 for the --gateway rule
    +1 for the --nexthop rule
 ping -c1 134.76.13.21
    +1 for the --gateway rule
    +0 for the --nexthop rule

Route to 134.76.13.21 is:
   (192.168.222.36)
    192.168.222.1
    10.10.96.1
    134.76.63.254
    134.76.13.21

Does xt_gateway still do the right thing? Please check, thanks!

(patches as a response to this mail,
or svnized for now @=20
https://dev.computergmbh.de/svn/misc_kernel/xt_gateway/trunk/ )


	Jan
--=20

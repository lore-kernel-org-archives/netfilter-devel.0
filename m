From: "zze-Proxy GRALL O ext FTRD/SVA/LAN" <ograll.ext@rd.francetelecom.com>
Subject: RE : Apply rules to 1 UDP port but port used as a socket: possible?
Date: Wed, 11 Feb 2004 11:38:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <D4EF10CCEB2CE742BEEA9838C590B0E80113FD36@ftrdmel2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Henrik Nordstrom" <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I think that receiving on the UDP socket set the table Conntrack  after =
the packet passed into the table Filter for the hook INPUT:

[INPUT]
   |   Filter
   |
   |   Conntrack=20
   |
   V

For the following packets that I need to NAT, they will pass in =
conntrack PREROUTING before mangle PREROUTING and before nat =
PREROUTING... So then packets will be sent to the socket (filter INPUT) =
due to conntrack PREROUTING isn't it ?

--->[PREROUTING]------>[INPUT]
     |            =EE
     | Conntrack -|
     |=20
     | Mangle
     |=20
     | Nat
     |=20
     V

-----Message d'origine-----
De : Henrik Nordstrom [mailto:hno@marasystems.com]=20
Envoy=E9 : mercredi 11 f=E9vrier 2004 08:53
=C0 : zze-Proxy GRALL O ext FTRD/SVA/LAN
Cc : netfilter-devel@lists.netfilter.org
Objet : Re: Apply rules to 1 UDP port but port used as a socket: =
possible?


On Tue, 10 Feb 2004, zze-Proxy GRALL O ext FTRD/SVA/LAN wrote:

> I'm trying to use a socket (on port 1727) to decode some proprietary=20
> UDP packets. When I've decoded them I want to apply a DNAT rule (and=20
> then a SNAT  too) to this port using a filter on @IP:port source for=20
> all following packets...

This will be tricky if you accept the packet on the socket. The problem =
is=20
that the connection entry is then already set up and can not be NAT:ed.

You should be able to use QUEUE in a table before nat PREROUTING such as =
mangle PREROUTING, allowing you to inspect the packet before the =
connection is set up.

Regards
Henrik

From: "Vishwas Manral" <Vishwas@sinett.com>
Subject: RE: LAND check: 2.4.20
Date: Tue, 15 Mar 2005 23:29:59 -0800
Message-ID: <BB6D74C75CC76A419B6D6FA7C38317B26A2716@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Cedric Blancher <blancher@cartel-securite.fr>, Martijn Lievaart <m@rtij.nl>
Content-class: urn:content-classes:message
To: "Patrick Schaaf" <bof@bof.de>
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

Hi Peter,

Thanks for pointing out. The check is called uRPF check needs to be
enabled only in case we have symmetric routing and we are not using
multihoming.

If you are saying RPF is done by default, it's a bigger problem. You may
want to see the IETF opsec mailing list for the same.

Thanks,
Vishwas
-----Original Message-----
From: Patrick Schaaf [mailto:bof@bof.de]=20
Sent: Wednesday, March 16, 2005 12:00 PM
To: Vishwas Manral
Cc: Cedric Blancher; Martijn Lievaart;
netfilter-devel@lists.netfilter.org
Subject: Re: LAND check: 2.4.20

> 3. I am not sure which routing code checks for Source IP Address? Can
you point me to some code (destroy it as a packet with local IP as
source must be received on loopback)?

net/ipv4/fib_frontend.c, function fib_validate_source().

The logic will be: destroy it because the route back to that source IP
resolves to destination device lo, and not the device the packet came
from.

> The solution as done by most firewalls is to add a simple check in the
check_tcp and check_udp. I think we need to add this to the iptables
code.

No, we don't.

best regards
  Patrick

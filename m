From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: New target 'ROUTE' and new table 'rsip'
Date: 10 Jun 2002 11:23:12 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023700992.3124.29.camel@descartes>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Here is an extension to directly reroute packets without modifying
them, even and especially if those packets are destined to the router
itself. Those packets are locally delivered and cannot be forwarded to
another computer using the standard routing mechanisms.
Sometimes, this is useful to redirect them to another computer, without
modification, e.g. when using the new RSIP protocol (RFC3102, RFC3103,
see http://openresources.info.ucl.ac.be/rsip for more info).

This extension includes a new target, called 'ROUTE', and a new table,
called 'rsip'. It provides a way to reroute those packets to an
interface selected by the user.=20

Source files are available at
  http://openresources.info.ucl.ac.be/rsip/netfilter/

These files are not yet packaged in any way. Sorry.


Example
-------

With RSIP, we can lease some ports (8000-8200 here) to one of
our private host. The host has the same IP as its router, so that
packets may remain unmodified when going through the router.
We want to reroute tcp packets coming from eth0 with dst port
8000-8200 towards iface tunl1 (in order to forward them to the
host) :

          eth0  +------+ 192.168.0.1        192.168.0.2 +----+
----------------|router|--------------------------------|host|
IP: 150.150.0.1 +------+                                +----+
                    | | tunl1      tunnel IP: 150.150.0.1 | |
                    | +-----------------------------------+ |
                    +---------------------------------------+

We do :

 iptables -A PREROUTING -i eth0 -p tcp --dport 8000:8200 -j ROUTE
--iface tunl1



The new files
-------------

a) The new 'ROUTE' target :

*  ipt_ROUTE.c        in /usr/src/linux/net/ipv4/netfilter
*  ipt_ROUTE.h        in /usr/src/linux/include/linux/netfilter_ipv4

b) A new 'rsip' table, with only PREROUTING hook, and priority -170=20
   =3D=3D after Conntrack but before Mangle, NAT,... (since we do not
   want those packet being altered in any way)

*  iptable_rsip.c     in /usr/src/linux/net/ipv4/netfilter

c) Extension to make iptables support the new 'ROUTE' target :

*  libipt_ROUTE.c     in iptables-x.x.X/extensions

Any comment ?

Thanks,

C=E9dric

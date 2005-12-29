From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Kernel build suspicious warnings 2.6.14-5, iptables 1.3.4,
	POM-20051227
Date: Thu, 29 Dec 2005 09:05:00 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A26D44@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "David S. Miller" <davem@davemloft.net>
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

It looks like the h323 modules are also broken.  I've been watching my
latest kernel build closely this time and ran across the extract below.
This probably explains why the undefined symbols when linking the
kernel. =20
.
.
.
  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_udp.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_icmp.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_h323_core.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_h323_h225.o
net/ipv4/netfilter/ip_conntrack_h323_h225.c: In function
'h225_parse_connect_uuie':
net/ipv4/netfilter/ip_conntrack_h323_h225.c:135: warning: implicit
declaration of function 'ip_conntrack_expect_free'
  CC [M]  net/ipv4/netfilter/ip_conntrack_h323_h245.o
net/ipv4/netfilter/ip_conntrack_h323_h245.c: In function
'h245_parse_h2250_lchannel_params':
net/ipv4/netfilter/ip_conntrack_h323_h245.c:322: warning: implicit
declaration of function 'ip_conntrack_expect_free'
  CC [M]  net/ipv4/netfilter/asn1_per.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_helper_pptp.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_gre.o
  CC [M]  net/ipv4/netfilter/ip_nat_core.o
  CC [M]  net/ipv4/netfilter/ip_nat_helper.o
  CC [M]  net/ipv4/netfilter/ip_nat_proto_unknown.o
  CC [M]  net/ipv4/netfilter/ip_nat_proto_tcp.o
  CC [M]  net/ipv4/netfilter/ip_nat_proto_udp.o
  CC [M]  net/ipv4/netfilter/ip_nat_proto_icmp.o
  CC [M]  net/ipv4/netfilter/ip_nat_helper_pptp.o
  CC [M]  net/ipv4/netfilter/ip_nat_proto_gre.o
  CC [M]  net/ipv4/netfilter/ip_nat_rule.o
  CC [M]  net/ipv4/netfilter/ip_nat_standalone.o
  LD [M]  net/ipv4/netfilter/ip_conntrack.o
  LD [M]  net/ipv4/netfilter/ip_conntrack_h323.o
  CC [M]  net/ipv4/netfilter/ip_nat_h323.o
net/ipv4/netfilter/ip_nat_h323.c: In function 'ip_nat_h225':
net/ipv4/netfilter/ip_nat_h323.c:111: warning: implicit declaration of
function 'ip_conntrack_expect_free'
  CC [M]  net/ipv4/netfilter/ip_conntrack_sip.o
  CC [M]  net/ipv4/netfilter/ip_nat_sip.o
net/ipv4/netfilter/ip_nat_sip.c: In function 'ip_nat_sip':
net/ipv4/netfilter/ip_nat_sip.c:97: warning: ISO C90 forbids mixed
declarations and code
  LD [M]  net/ipv4/netfilter/ip_nat.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_netlink.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_sctp.o
  LD [M]  net/ipv4/netfilter/ip_conntrack_pptp.o
  CC [M]  net/ipv4/netfilter/ip_conntrack_amanda.o

.
.
.

- Greg Scott




-----Original Message-----
From: Greg Scott=20
Sent: Thursday, December 29, 2005 7:48 AM
To: 'David S. Miller'
Cc: netfilter-devel@lists.netfilter.org
Subject: RE: Kernel build suspicious warnings 2.6.14-5, iptables 1.3.4,
POM-20051227


Sorry...I should have checked the archives for references to the tarpit
module.  But that doesn't explain these warnings:

*** Warning: "ip_conntrack_expect_free"
[net/ipv4/netfilter/ip_nat_h323.ko] undefined!
*** Warning: "ip_conntrack_expect_free"
[net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!

The h323 modules were broken before with a missing argument.  I wonder
if they are still broken even after applying Vinay's patch?

I am trying again without the tarpit module. =20

- Greg
=20

-----Original Message-----
From: David S. Miller [mailto:davem@davemloft.net]=20
Sent: Thursday, December 29, 2005 4:30 AM
To: Greg Scott
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: Kernel build suspicious warnings 2.6.14-5, iptables 1.3.4,
POM-20051227


From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Date: Thu, 29 Dec 2005 00:44:02 -0600

> These are only warnings but they make me suspicious.  Should I be
> worried?  Could the warnings below be because something in the kernel=20
> calls the modules in question but the modules haven't been built yet?=20
> But why would anything in the inline kernel call an optional module=20
> loaded from POM?  I've run into several errors getting this far.  I'll

> try a "make mrproper" and then "make all" to build it all from scratch

> now and see what happens.

That tarpit module, as mentioned here by myself in a posting from last
week, is broken and is depending on a symbol that is not exported for a
reason.

To reiterate: It is trying to get the ttl to use in outgoing ipv4 frames
from the sysctl, but that should instead be obtained from the routing
metrics.

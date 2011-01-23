From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: netfilter: marking IPv6 packets sends them to the wrong interface
Date: Sun, 23 Jan 2011 13:21:09 +0100
Message-ID: <20110123122108.GA30305@darkside.kls.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I have a strange issue with netfilter MARK on IPv6 which I cannot
explain and which I believe to be a kernel bug:
If I mark outgoing IPv6 packets they appear to be transmitted via the
wrong physical interface. At least multicast packets - at least some of
them.

I'm running a Linux-based router with two local interfaces and radvd
advertises stateless autoconfiguration information on them.
If I mark all outgoing IPv6 packets, after some time all hosts on both
subnets appear to be autoconfigured for both subnets, i.e. they all have
two IPv6 addresses - one of each subnet and two default routes - one for
each router interface. Of course, only one of them really works on each
host.

The gateway does pretty normal routing, no routing policies,
particularly no fwmark rules, does no bridging or something like that.
The network interfaces are Intel driven by e100.

The following debug session is done with a 2.6.32 kernel, the condensed
packet information originates from tcpdump:

Without marking everything runs as it should be.
Marking eth0 packets results in all advertisements transmitted via eth1.
The behaviour goes back to normal as soon as the marking disappears.
Marking eth1 packets doesn't appear to change the normal behaviour at
the first glance, but with that I experience hiccups after some time of
inactivity (i.e. from time to time ping6 from one subnet to the other
gets no answers for the first 6 to 8 packets).=20

I also tried marking with 0xff00 instead of 1 - same results.
I tested this on kernels 2.6.26, 2.6.32, and 2.6.37 - all show the same
behaviour.

# ifconfig eth0; ifconfig eth1
eth0      Link encap:Ethernet  HWaddr 00:d0:b7:06:6b:36 =20
          inet addr:192.168.12.254  Bcast:192.168.12.255  Mask:255.255.255.0
          inet6 addr: 2001:6f8:90c:12::1/64 Scope:Global
          inet6 addr: fe80::2d0:b7ff:fe06:6b36/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
=2E..
eth1      Link encap:Ethernet  HWaddr 00:a0:c9:e6:90:ce =20
          inet addr:192.168.10.254  Bcast:192.168.10.255  Mask:255.255.255.0
          inet6 addr: 2001:6f8:90c:10::1/64 Scope:Global
          inet6 addr: fe80::2a0:c9ff:fee6:90ce/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
=2E..
# ip -6 route show
2001:6f8:900:62f::/64 via :: dev sixxs  proto kernel  metric 256  mtu 1280 =
advmss 1220 hoplimit 0
2001:6f8:90c:10::/64 dev eth1  proto kernel  metric 256  mtu 1500 advmss 14=
32 hoplimit 0
2001:6f8:90c:12::/64 dev eth0  proto kernel  metric 256  mtu 1500 advmss 14=
32 hoplimit 0
fe80::/64 dev eth0  proto kernel  metric 256  mtu 1500 advmss 1432 hoplimit=
 0
fe80::/64 dev eth1  proto kernel  metric 256  mtu 1500 advmss 1432 hoplimit=
 0
fe80::/64 via :: dev sixxs  proto kernel  metric 256  mtu 1280 advmss 1220 =
hoplimit 0
default via 2001:6f8:900:62f::1 dev sixxs  metric 1024  mtu 1280 advmss 122=
0 hoplimit 0
# ip -6 rule list
0:      from all lookup local=20
32766:  from all lookup main=20
# zgrep BRI /proc/config.gz=20
# CONFIG_BRIDGE is not set
# cat /etc/radvd.conf
interface eth0 {
        AdvSendAdvert on;
        prefix 2001:6f8:90c:12::/64 {};
};
interface eth1 {
        AdvSendAdvert on;
        prefix 2001:6f8:90c:10::/64 {};
};
# ip6tables -t raw -F
# ip6tables -t mangle -F
# ip6tables -t filter -F
# /etc/init.d/radvd start
-> eth0: fe80::2d0:b7ff:fe06:6b36 > ff02::1: prefix 2001:6f8:90c:12::/64
-> eth1: fe80::2a0:c9ff:fee6:90ce > ff02::1: prefix 2001:6f8:90c:10::/64
# /etc/init.d/radvd stop
# ip6tables -t mangle -A OUTPUT -o eth0 -j MARK --set-mark 1
# /etc/init.d/radvd start
-> eth0: <no traffic>
-> eth1: fe80::2a0:c9ff:fee6:90ce > ff02::1: prefix 2001:6f8:90c:10::/64
-> eth1: fe80::2d0:b7ff:fe06:6b36 > ff02::1: prefix 2001:6f8:90c:12::/64
# /etc/init.d/radvd stop
# ip6tables -t mangle -F
# /etc/init.d/radvd start
-> eth0: fe80::2d0:b7ff:fe06:6b36 > ff02::1: prefix 2001:6f8:90c:12::/64
-> eth1: fe80::2a0:c9ff:fee6:90ce > ff02::1: prefix 2001:6f8:90c:10::/64
# /etc/init.d/radvd stop
# ip6tables -t mangle -A OUTPUT -o eth1 -j MARK --set-mark 1
# /etc/init.d/radvd start
-> eth0: fe80::2d0:b7ff:fe06:6b36 > ff02::1: prefix 2001:6f8:90c:12::/64
-> eth1: fe80::2a0:c9ff:fee6:90ce > ff02::1: prefix 2001:6f8:90c:10::/64
# /etc/init.d/radvd stop

--=20
Doing it right is no excuse for not meeting the schedule.
                                -- Plant Manager, Delphi Corporation

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTTwdNBS+e2HeSPbpAQL6qwf9Ez+rgGmYTIw1yzPrVyx5kQ517Etp1++y
T1V0dTnphDcmIJadPkREWORoIch8uypAzlLglGv4cBZEepyWr3bjyg/7ADcYDdHe
vwZ0orco5BYUiWYCDIxS/HFoHlCDWR8+Qd2s8UGK8OpZFwOA6MTDxqrUii/m07Wd
MLIXrFrZMLzFPRHnlU/5z/WXj7oglPLXDw8TkQdjV2iRdy8q/uUEePg/Z57sM+1P
iQRI73XTr9zGg9ObqsLq+1APOjh0iW5J+fdD3m8CB6W5DaZaZ4djP046/a+OWcwp
JCrFGzN38jVM99Cm0+gYfGLxCGfE0vcgBKQfvAM/gvWl/SJ/+GagpA==
=6nFK
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--

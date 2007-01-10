From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: dst cache overflow (bridged wan interfaces)
Date: Wed, 10 Jan 2007 21:14:00 +0100 (CET)
Message-ID: <41878.84.123.236.132.1168460040.squirrel@www.arcoscom.com>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, lartc@mailman.ds9a.nl
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

I recompiled yet 2.6.19.1 kernel (using iptables with the same patches to=
o).

The configuration for this test is:
   1) linux box with 2.6.19.1 kernel (SMP machine) with these
patches/modules:
      a) l7-filter
      b) ipp2p
      c) connlimit
      d) set
   2) 4 ethernet interfaces:
      a) 2 external (eth1 and eth3) interfaces with balanced links (as
described in nato-howto) bridged as wan0 with static IPs assigned to
wan0 and wan0:1
      b) 2 internal ineterfaces (eth0 and eth2) in bridge zlan0 with STP
enabled and configured.

IPTABLES relevant configuration:
# iptables -t nat -vn -L POSTROUTING
Chain POSTROUTING (policy ACCEPT 185 packets, 16649 bytes)
 pkts bytes target     prot opt in     out     source             =20
destination
   26  1529 MASQUERADE  0    --  *      wan0    10.1.1.0/27        =20
0.0.0.0/0
    0     0 MASQUERADE  0    --  *      wan0:1  10.1.1.0/27        =20
0.0.0.0/0


ROUTES CONFIGURATION:
# service rt status
=3D=3D=3D REGLAS DE ENRUTAMIENTO =3D=3D=3D
0:      from all lookup local
50:     from all lookup main
151:    from NET_PUB1 lookup 151
152:    from NET_PUB2 lookup 152
220:    from all lookup 220
32766:  from all lookup main
32767:  from all lookup default
=3D=3D=3D TABLAS DE RUTAS =3D=3D=3D
=3D=3D=3D MAIN =3D=3D=3D
NET_PUB1/26 dev wan0  proto kernel  scope link  src IP_PUB1
NET_PUB2/24 dev wan0  proto kernel  scope link  src IP_PUB2
192.168.3.0/24 dev zlan0  proto kernel  scope link  src 192.168.3.247
192.168.2.0/24 dev zlan0  proto kernel  scope link  src 192.168.2.247
192.168.1.0/24 dev zlan0  proto kernel  scope link  src 192.168.1.247
10.1.1.0/24 dev zlan0  proto kernel  scope link  src 10.1.1.6
169.254.0.0/16 dev zlan0  scope link
239.0.0.0/8 dev zlan0  scope link
=3D=3D=3D wan0 TABLA 151 =3D=3D=3D
default via GW_PUB1 dev wan0  proto static  src IP_PUB1
prohibit default  proto static  metric 1
=3D=3D=3D wan0 TABLA 152 =3D=3D=3D
default via GW_PUB2 dev wan0  proto static  src IP_PUB2
prohibit default  proto static  metric 1
=3D=3D=3D TABLA 220 (defecto) =3D=3D=3D
default  proto static
        nexthop via GW_PUB1  dev wan0 weight 1
        nexthop via GW_PUB2  dev wan0 weight 1

ROUTING parameters configuration:
# grep . /proc/sys/net/ipv4/route/*
/proc/sys/net/ipv4/route/error_burst:5000
/proc/sys/net/ipv4/route/error_cost:1000
grep: /proc/sys/net/ipv4/route/flush: Operaci=F3n no permitida
/proc/sys/net/ipv4/route/gc_elasticity:8
/proc/sys/net/ipv4/route/gc_interval:60
/proc/sys/net/ipv4/route/gc_min_interval:0
/proc/sys/net/ipv4/route/gc_min_interval_ms:500
/proc/sys/net/ipv4/route/gc_thresh:32768
/proc/sys/net/ipv4/route/gc_timeout:300
/proc/sys/net/ipv4/route/max_delay:10
/proc/sys/net/ipv4/route/max_size:524288
/proc/sys/net/ipv4/route/min_adv_mss:256
/proc/sys/net/ipv4/route/min_delay:2
/proc/sys/net/ipv4/route/min_pmtu:552
/proc/sys/net/ipv4/route/mtu_expires:600
/proc/sys/net/ipv4/route/redirect_load:20
/proc/sys/net/ipv4/route/redirect_number:9
/proc/sys/net/ipv4/route/redirect_silence:20480
/proc/sys/net/ipv4/route/secret_interval:600

When I test it along some weeks with intensive traffic I'll put here more
info about this test.

If somebody has any idea on how to solve the problem, please, tell us. I'=
m
a bit desesperate with this issue.

Regards

From: Nico Schottelius <nico-linux-net@schottelius.org>
Subject: [BUG] Netfilter in Linux 2.6.1
Date: Fri, 23 Jan 2004 17:03:19 +0100
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20040123160319.GA2733@schottelius.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Cc: gregor@tecmafia.de, netfilter-devel@lists.netfilter.org
Return-path: <linux-net-owner@vger.kernel.org>
To: linux-net@vger.kernel.org
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

While experiement with ipsec I found the following problems:

Encapsulated ipsec data (esp) passes through iptables and becomes
decrypted. So far so fine.

Now what happens with thoso unencrypted packages? It looks like
they travel through iptables again!

Have a look at this example:

I use=20

http://schotteli.us/~nico/firewall-masq

as my firewall script on the host named "bruehe".

With a notebook (named scice) I start an ipsec connection
with isakmpd via wlan to bruehe:

isampd.scice -> wlan0.scice -> wlan0.bruehe -> isakmpd.bruehe.

So far no problems.

The SAs are set fine: [ipsec-bug.setkey]

When I try to ping bruehe it is successful:

scice% ping -c2 192.168.42.1
PING 192.168.42.1 (192.168.42.1): 56 data bytes
64 bytes from 192.168.42.1: icmp_seq=3D0 ttl=3D64 time=3D8.4 ms
64 bytes from 192.168.42.1: icmp_seq=3D1 ttl=3D64 time=3D4.8 ms

--- 192.168.42.1 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max =3D 4.8/6.6/8.4 ms


logged from host named baby, which is sniffing in the wlan:

03:11:04.577573 scice.wlan.intern.schottelius.org >
bruehe.wlan.intern.schottelius.org: ESP(spi=3D0xd4b291d4,seq=3D0x3) (DF)
03:11:04.579071 bruehe.wlan.intern.schottelius.org >
scice.wlan.intern.schottelius.org: ESP(spi=3D0xaa714402,seq=3D0x3)
03:11:06.193495 scice.wlan.intern.schottelius.org >
bruehe.wlan.intern.schottelius.org: ESP(spi=3D0xd4b291d4,seq=3D0x4) (DF)
03:11:06.199202 bruehe.wlan.intern.schottelius.org >
scice.wlan.intern.schottelius.org: ESP(spi=3D0xaa714402,seq=3D0x4)


Now I try to ssh to 192.168.42.2 =3D=3D bruehe.

I don't get any reply, only a timeout (because of the -j DROP rule).

Log from baby:

03:14:42.538601 scice.wlan.intern.schottelius.org >
bruehe.wlan.intern.schottelius.org: ESP(spi=3D0xd4b291d4,seq=3D0x8) (DF)
03:14:47.390054 scice.wlan.intern.schottelius.org >
bruehe.wlan.intern.schottelius.org: ESP(spi=3D0xd4b291d4,seq=3D0x9) (DF)
03:14:57.094131 scice.wlan.intern.schottelius.org >
bruehe.wlan.intern.schottelius.org: ESP(spi=3D0xd4b291d4,seq=3D0xa) (DF)

As you see, no response, although the rules should match them:

#=20
# IKE from wlan
#=20
iptables  -I INPUT -i $DEV_WLAN  -p udp --sport 500 --dport 500 -j
ACCEPT
ip6tables -I INPUT -i $DEV_WLAN  -p udp --sport 500 --dport 500 -j
ACCEPT

#
# ESP encryption and authentication from wlan
#
iptables  -I INPUT -i $DEV_WLAN -p esp -j ACCEPT
ip6tables -I INPUT -i $DEV_WLAN -p esp -j ACCEPT

#
# AH=20
#=20
iptables  -I INPUT -i $DEV_WLAN -p ah -j ACCEPT
ip6tables -I INPUT -i $DEV_WLAN -p ah -j ACCEPT


As ssh gets blocked, I assume after decryting the packages they
are matching against the rules again.

Is that right?

This looks for me like bug in netfilter...

Greetings,

Nico

ps: I am on the linux-net ML, not on the netfilter ML, so
    please CC-me when replying.

--=20
Keep it simple & stupid, use what's available.
pgp: 8D0E E27A          | Nico Schottelius
http://nerd-hosting.net | http://linux.schottelius.org

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ipsec-bug.setkey"
Content-Transfer-Encoding: quoted-printable

bruehe:/usr/src/linux# setkey -D
192.168.42.2 192.168.42.1=20
        esp mode=3Dtunnel spi=3D3568472532(0xd4b291d4) reqid=3D0(0x00000000)
        E: rijndael-cbc  95a4ad71 799ae14e 9c145bb1 3628a4d8
        A: hmac-sha1  4bbea868 1b4e334f 3f7317e2 40b221b6 f4a5c58e
        seq=3D0x00000000 replay=3D0 flags=3D0x00000000 state=3Dmature=20
        created: Jan 23 16:43:23 2004   current: Jan 23 16:47:18 2004
        diff: 235(s)    hard: 1200(s)   soft: 1080(s)
        last:                           hard: 0(s)      soft: 0(s)
        current: 0(bytes)       hard: 0(bytes)  soft: 0(bytes)
        allocated: 0    hard: 0 soft: 0
        sadb_seq=3D1 pid=3D9319 refcnt=3D0
192.168.42.1 192.168.42.2=20
        esp mode=3Dtunnel spi=3D2859549698(0xaa714402) reqid=3D0(0x00000000)
        E: rijndael-cbc  3c94ab69 28414ac0 9069dc1f 282d376d
        A: hmac-sha1  72710b06 754daf00 8f2aca9f d8e63ac5 7f468a99
        seq=3D0x00000000 replay=3D0 flags=3D0x00000000 state=3Dmature=20
        created: Jan 23 16:43:23 2004   current: Jan 23 16:47:18 2004
        diff: 235(s)    hard: 1200(s)   soft: 1080(s)
        last:                           hard: 0(s)      soft: 0(s)
        current: 0(bytes)       hard: 0(bytes)  soft: 0(bytes)
        allocated: 0    hard: 0 soft: 0
        sadb_seq=3D0 pid=3D9319 refcnt=3D0



scice# setkey -D
192.168.42.2 192.168.42.1=20
        esp mode=3Dtunnel spi=3D3568472532(0xd4b291d4) reqid=3D0(0x00000000)
        E: rijndael-cbc  95a4ad71 799ae14e 9c145bb1 3628a4d8
        A: hmac-sha1  4bbea868 1b4e334f 3f7317e2 40b221b6 f4a5c58e
        seq=3D0x00000000 replay=3D16 flags=3D0x00000000 state=3Dmature=20
        created: Jan 23 16:43:18 2004   current: Jan 23 16:47:54 2004
        diff: 276(s)    hard: 1200(s)   soft: 1080(s)
        last:                           hard: 0(s)      soft: 0(s)
        current: 0(bytes)       hard: 0(bytes)  soft: 0(bytes)
        allocated: 0    hard: 0 soft: 0
        sadb_seq=3D1 pid=3D2783 refcnt=3D0
192.168.42.1 192.168.42.2=20
        esp mode=3Dtunnel spi=3D2859549698(0xaa714402) reqid=3D0(0x00000000)
        E: rijndael-cbc  3c94ab69 28414ac0 9069dc1f 282d376d
        A: hmac-sha1  72710b06 754daf00 8f2aca9f d8e63ac5 7f468a99
        seq=3D0x00000000 replay=3D16 flags=3D0x00000000 state=3Dmature=20
        created: Jan 23 16:43:18 2004   current: Jan 23 16:47:54 2004
        diff: 276(s)    hard: 1200(s)   soft: 1080(s)
        last:                           hard: 0(s)      soft: 0(s)
        current: 0(bytes)       hard: 0(bytes)  soft: 0(bytes)
        allocated: 0    hard: 0 soft: 0
        sadb_seq=3D0 pid=3D2783 refcnt=3D0


--lrZ03NoBR/3+SXJZ--

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAEUXHzGnTqo0OJ6QRAv6hAJ9nUrnYrNJTNshvoeaL64Wuz8j4VwCgjlV8
G8DQcaiyJLrNWjT8tC1WHm4=
=cog5
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--

From: Christophe Saout <christophe@saout.de>
Subject: Re: 2.6.16-rc1-mm3 XFRM+NAT issue
Date: Sun, 29 Jan 2006 21:59:13 +0100
Message-ID: <1138568354.21229.1.camel@leto.intern.saout.de>
References: <1138563710.26998.22.camel@leto.intern.saout.de>
	<43DD1E3E.70503@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-YlO3o+NNvwVkQ/RAYked"
Cc: netfilter-devel@lists.netfilter.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43DD1E3E.70503@trash.net>
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


--=-YlO3o+NNvwVkQ/RAYked
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Patrick McHardy wrote:

> > I'm very glad that you found some time to get these patches into the
> > mainline kernel. Unfortunately I think I'm running into a case where
> > it's not working (it's working with 2.6.12 + the old unofficial IPSEC
> > +NAT patches).
> >=20
> >           .--- gateway host ---.            .-- pub. host -.
> > priv net -|NAT + IPSEC endpoint|- internet -|IPSEC endpoint|
> >           '--------------------'            '--------------'
> >=20
> > ping ----->---*NAT*---*XFRM*********>*********XFRM*--------.
> >                                                            v
> >                    ???.....*********<*********XFRM*- pong -'
> >=20
> > Without IPSEC turned on I can reach the host on the far right from any
> > host in the private network on the left without problem. The private
> > address is source-NATted (masqueraeded) at the gateway.
> >=20
> > When turning on the IPSEC connection between the gateway and the
> > internet host, the host in the private network can't reach the internet
> > host (on the right) anymore. It's still reachable from the gateway
> > itself though.
> >=20
> > When pinging from the host behind the gateway the packet passes through
> > the gateway, gets to the internet host, which responds to the ping and
> > sends an encrypted packet back through the IPSEC connection which then
> > arrives at the gatway. But then the gateway simply ignores the packet
> > instead of decapsulating and DNATting it back to the host in the privat=
e
> > network. At least that's what I can gather from tcpdump. If I run
> > tcpdump on ppp0 on the gateway I can see encrypted packets go out to th=
e
> > host on the right and encrypted packets coming back and that's it.
>=20
> It should work just fine. Please add logging rules for both encrypted
> and decrypted packets to all chains in the mangle table and enable
> logging of invalid packets in connection tracking
> (echo 255 > /proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid)
> and post the results.

I did, but it doesn't seem conclusive.

Trying to open a tcp connection: (note that there are no entries with
IN=3Deth0 ???)

Jan 29 21:51:23 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D100 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3D41=20
Jan 29 21:51:23 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D100 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3D41=20
Jan 29 21:51:23 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D152 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3DESP SPI=
=3D0x1249d895=20
Jan 29 21:51:23 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D152 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3DESP SPI=
=3D0x1249d895=20
Jan 29 21:51:23 server IN=3Dppp0 OUT=3D MAC=3D SRC=3D<inet host> DST=3D<gat=
eway pub ip> LEN=3D152 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF PROTO=3DES=
P SPI=3D0xbdbf1ca7=20
Jan 29 21:51:23 server IN=3Dppp0 OUT=3D MAC=3D SRC=3D<inet host> DST=3D<gat=
eway pub ip> LEN=3D152 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF PROTO=3DES=
P SPI=3D0xbdbf1ca7=20
Jan 29 21:51:23 server IN=3Dppp0 OUT=3D MAC=3D45:00:00:98:00:00:40:00:37:29=
:56:8d:d5:ef:c5:f1:54:38:fc:8d:bd:bf SRC=3D<inet host> DST=3D<gateway pub i=
p> LEN=3D100 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF PROTO=3D41=20
Jan 29 21:51:23 server IN=3Dppp0 OUT=3D MAC=3D45:00:00:98:00:00:40:00:37:29=
:56:8d:d5:ef:c5:f1:54:38:fc:8d:bd:bf SRC=3D<inet host> DST=3D<gateway pub i=
p> LEN=3D100 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF PROTO=3D41=20
Jan 29 21:51:23 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D148 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3D41=20
Jan 29 21:51:23 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D148 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3D41=20
Jan 29 21:51:23 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D200 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3DESP SPI=
=3D0x1249d895=20
Jan 29 21:51:23 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D200 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3DESP SPI=
=3D0x1249d895=20

Pinging inet host from behind NAT:

Jan 29 21:51:42 server IN=3Deth0 OUT=3D MAC=3D00:01:80:5c:0f:48:00:02:8a:ba=
:b8:58:08:00 SRC=3D192.168.80.90 DST=3D<inet host> LEN=3D84 TOS=3D0x00 PREC=
=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3DICMP TYPE=3D8 CODE=3D0 ID=3D48978 SEQ=3D=
1=20
Jan 29 21:51:42 server IN=3Deth0 OUT=3Dppp0 SRC=3D192.168.80.90 DST=3D<inet=
 host> LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D63 ID=3D0 DF PROTO=3DICMP TYPE=
=3D8 CODE=3D0 ID=3D48978 SEQ=3D1=20
Jan 29 21:51:42 server IN=3D OUT=3Dppp0 SRC=3D192.168.80.90 DST=3D<inet hos=
t> LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D63 ID=3D0 DF PROTO=3DICMP TYPE=3D8=
 CODE=3D0 ID=3D48978 SEQ=3D1=20
Jan 29 21:51:42 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D136 TOS=3D0x00 PREC=3D0x00 TTL=3D63 ID=3D0 DF PROTO=3DESP SPI=
=3D0x1249d895=20
Jan 29 21:51:42 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D136 TOS=3D0x00 PREC=3D0x00 TTL=3D63 ID=3D0 DF PROTO=3DESP SPI=
=3D0x1249d895=20
Jan 29 21:51:42 server IN=3Dppp0 OUT=3D MAC=3D SRC=3D<inet host> DST=3D<gat=
eway pub ip> LEN=3D136 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D20240 PROTO=3DE=
SP SPI=3D0xbdbf1ca7=20
Jan 29 21:51:42 server IN=3Dppp0 OUT=3D MAC=3D SRC=3D<inet host> DST=3D<gat=
eway pub ip> LEN=3D136 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D20240 PROTO=3DE=
SP SPI=3D0xbdbf1ca7=20
Jan 29 21:51:42 server IN=3Dppp0 OUT=3D MAC=3D45:00:00:88:4f:10:00:00:37:01=
:47:8d:d5:ef:c5:f1:54:38:fc:8d:bd:bf SRC=3D<inet host> DST=3D<gateway pub i=
p> LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D20240 PROTO=3DICMP TYPE=3D=
0 CODE=3D0 ID=3D48978 SEQ=3D1=20
Jan 29 21:51:42 server IN=3Dppp0 OUT=3D MAC=3D45:00:00:88:4f:10:00:00:37:01=
:47:8d:d5:ef:c5:f1:54:38:fc:8d:bd:bf SRC=3D<inet host> DST=3D192.168.80.90 =
LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D20240 PROTO=3DICMP TYPE=3D0 C=
ODE=3D0 ID=3D48978 SEQ=3D1=20

Perhaps I also should note that *tunnel* mode works fine, it's just the
transport mode that is broken.


--=-YlO3o+NNvwVkQ/RAYked
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD4DBQBD3SyhZCYBcts5dM0RAuPXAKCqaaFj/f1aS0yGkqWd0dReQ/AmIgCYiwXQ
+Fa/V3dckL6HzRTzzIp1Ag==
=BzuD
-----END PGP SIGNATURE-----

--=-YlO3o+NNvwVkQ/RAYked--

From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Checksum problem in tcp-window-tracking
Date: Tue, 15 Jun 2004 20:51:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087325507.1019.64.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0406151510320.15738-100000@blackhole.kfki.hu>
	 <40CF40B3.7040109@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qe/DPrpDh97rJXiS6r2k"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40CF40B3.7040109@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-qe/DPrpDh97rJXiS6r2k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-06-15 at 20:32, Patrick McHardy wrote:

Hi Patrick

> Jozsef Kadlecsik wrote:
> > I committed the fixed version of the patch in cvs. Besides the fix the
> > talkative log messages were trimmed in order to fit (better) into the
> > ULOG buffer.
>=20
> I think there is still a problem.
>=20
> +       if (csum_tcpudp_magic(iph->saddr, iph->daddr,
> +                             tcplen, IPPROTO_TCP,
> +                             skb->ip_summed =3D=3D CHECKSUM_HW
> +                             && hooknum =3D=3D NF_IP_PRE_ROUTING
> +                               ? skb->csum
> +                               : skb_checksum(skb, iph->ihl*4, tcplen,=20
> 0))) {
>=20
> On the outgoing path, the NIC is supposed to checksum the packet when
> CHECKSUM_HW is set, so it hasn't got a valid checksum when the check is
> performed. Do we need to check the checksum in LOCAL_OUT at all ?
> Other than from raw-sockets, invalid packets can not occur.
>=20
> Regards
> Patrick
>=20
> PS: Martin, how did you trigger these errors ?

Upgraded the kernel on my desktop-machine :)

Kernel 2.6.7-rc3-bk4 + tcp-windowtracking without the latest change made
by Jozsef.

It's just local imap and irc servers (bitlbee for icq) and clients
connecting to 127.0.0.1

I get one logentry per packet or so, in both directions.

I now have 28.000 lines of these complains in a logfile :)

--=20
/Martin

--=-qe/DPrpDh97rJXiS6r2k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAz0VDWm2vlfa207ERAn41AJ9S5PRO4TcGMoBhbVRdo0hcosKDhQCfTBaY
tn0d1uOm/D/3VDjPE6h/uBg=
=jS/O
-----END PGP SIGNATURE-----

--=-qe/DPrpDh97rJXiS6r2k--

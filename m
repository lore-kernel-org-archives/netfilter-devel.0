From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: bug in icmp tracking?
Date: Tue, 09 Mar 2004 21:47:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1078865277.3615.34.camel@tux.rsn.bth.se>
References: <404E1E90.3060509@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jUsDTGerLD1FzzygNnys"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <404E1E90.3060509@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-jUsDTGerLD1FzzygNnys
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-03-09 at 20:44, Pablo Neira wrote:
> Hi list,
>=20
> I sent some ICMP echo's request and I received the echo's reply with no=20
> problems but the conntrack doesn't track them.

Conntrack tracks icmp-echo-requests and icmp-echo-replies just fine.

> This is because the value returned by icmp_error_track called from=20
> ip_conntrack_in.
>=20
> snipped from icmp_error_track(...):
>=20
> 514         if (inside.icmp.type !=3D ICMP_DEST_UNREACH
> 515             && inside.icmp.type !=3D ICMP_SOURCE_QUENCH
> 516             && inside.icmp.type !=3D ICMP_TIME_EXCEEDED
> 517             && inside.icmp.type !=3D ICMP_PARAMETERPROB
> 518             && inside.icmp.type !=3D ICMP_REDIRECT)
> 519                 return NULL;
>=20
> I also had a look at the docs and I didn't find anything like "icmp are=20
> not tracked because of something...".
>=20
> So, is this a bug or a feature?

from ip_conntrack_in()

        /* It may be an icmp error... */
        if ((*pskb)->nh.iph->protocol =3D=3D IPPROTO_ICMP
            && icmp_error_track(*pskb, &ctinfo, hooknum))
                return NF_ACCEPT;

An icmp-echo-request/reply causes icmp_error_track() to return NULL and
thus the above if-statement won't match... =3D the packets are tracked.
You probably won't see them in /proc/net/ip_conntrack since they are
removed as soon as the reply has been seen, which probably is around 1ms
after you were added, you have to be quite lucky in order to see them in
that file.

Apply the ctstat patch and see for yourself when you ping.

--=20
/Martin

--=-jUsDTGerLD1FzzygNnys
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBATi19Wm2vlfa207ERAlHCAKDFZckcN6UEI4JdXGLf4CQ3WHIjpQCgo+k2
zyt8QB4mMGeoPGOK4pidr50=
=//NV
-----END PGP SIGNATURE-----

--=-jUsDTGerLD1FzzygNnys--

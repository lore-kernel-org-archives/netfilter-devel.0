From: Sami Farin <safari-netfilter@safari.iki.fi>
Subject: Re: xt_TARPIT 20070806
Date: Sun, 12 Aug 2007 15:57:45 +0300
Message-ID: <20070812125745.3g7hmmfyjmeak7jp@m.safari.iki.fi>
References: <Pine.LNX.4.64.0708061455480.13469@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0708121330370.28963@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ixrazmtnzr273udd"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708121330370.28963@fbirervta.pbzchgretzou.qr>
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


--ixrazmtnzr273udd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 12, 2007 at 13:31:43 +0200, Jan Engelhardt wrote:
>=20
> On Aug 6 2007 15:06, Jan Engelhardt wrote:
> >Subject: xt_TARPIT 20070806
>=20
> I'd like to get some comments if possible.
> Otherwise I assume it's ready to be included ;-)

It would be really nice if this was included in the kernel
because the version in POM-NG tends to rot and everyone
who uses TARPIT module has to fix it on their own when
new kernel is released because usually TARPIT module
is not updated to work or even compile with latest kernel(s).
That has been my experience with TARPIT module since 2004 (or 2003?)...

But isn't this redundant?
        if (oldskb->len < ip_hdrlen(oldskb) + sizeof(struct tcphdr))
                return;

Shouldn't this be enough?

        /* A truncated TCP header is not going to be useful */
        otcph =3D skb_header_pointer(oldskb, ip_hdrlen(oldskb),
                                   sizeof(_otcph), &_otcph);
        if (otcph =3D=3D NULL)
                return;

--=20
Do what you love because life is too short for anything else.


--ixrazmtnzr273udd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQFGvwPJMCYCLUwuV18RAiMBAJ9Upl3P+SRco3DxQY5OYCd0tnaBvQCg18FG
7SqVJbeUJHvzkSIxAkuGVVs=
=KY0H
-----END PGP SIGNATURE-----

--ixrazmtnzr273udd--

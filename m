From: Harald Welte <laforge@netfilter.org>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Sun, 18 Jan 2004 08:20:44 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040118132044.GA14663@obroa-skai.de.gnumonks.org>
References: <20040117110952.GI18505@obroa-skai.de.gnumonks.org> <Pine.LNX.4.44.0401171737300.10400-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Cc: Julian Anastasov <ja@ssi.bg>, linux-net@vger.kernel.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401171737300.10400-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 17, 2004 at 06:50:21PM +0100, Henrik Nordstrom wrote:
> It is fine by me. It is a trivial thing to add as the extension is not=20
> yet frozen.

yup. Please submit your changes against pom-ng (and patch-o-matic if you
want, but as of now I don't think we'll see another pom-old release).

> > Last, but not least:  We'd need an etry for the iptables(8) manpage.
>=20
> Already there from the beginning, but lost in p-o-m due to the lack of a
> clear structure on how manpage additions should be maintained for not yet=
=20
> official extensions. (the help is copy-paste from the manpage output)
>=20
> Should I also write a more module like help text for these modules?

the 'help' file in patch-o-matic-ng/CONNMARK/ is fine.

> Btw, any plans on how iptables manpage snippets for extra/not yet
> submitted matches/targets should be maintained?

well, we could do some semi-automated mechanism, like splitting it up in
one file per extension, and then concatenate the whole manpage from
those snippets depending on PF_EXT_LIBS / PF6_EXT_LIBS during the
iptables userspace make process.

If somebody wants to take that job, I'd be more than happy.

As for pkttables, the design includes automatic manpage generation from the
helptexts (included in libpktt_FOO.so).  But that's yet-to-do.

> The requested changes has been done but is not yet tested. Testing should=
=20
> be finished tomorrow whenI will submit the changes.

great.  I'm again on the road (LWE), so expect some delays.

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFACogrXaXGVTD0i/8RAnuRAJ4+tQBZVAaZZsr5/VGfHFQw8AUGWACdFrmO
V52AeUnKihAUGGtx34lACG0=
=K8cA
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--

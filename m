From: Harald Welte <laforge@netfilter.org>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Wed, 21 Jan 2004 18:49:04 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040121234904.GF1810@obroa-skai.de.gnumonks.org>
References: <20040120011305.GD1142@eychenne.org> <Pine.LNX.4.44.0401200743490.23963-100000@filer.marasystems.com> <20040120232103.GB1143@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W2ydbIOJmkm74tJ2"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20040120232103.GB1143@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--W2ydbIOJmkm74tJ2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2004 at 12:21:03AM +0100, Herve Eychenne wrote:

> Yes, and that is another question I want to raise...
> I don't really understand why p-o-m would not add both parts (kernel/user=
).
> That would mean not distributing an iptables tarball with every
> extensions. According to me, adding an extension should be treated
> equally on user and kernel sides (as they are heavily coupled).

the issue is, that quite an amount of patch-o-matic kernel code
eventually appears in the mainstream kernel at some point.  For those
extensions it's better if their userspace counterparts are already
present in already-shipped iptables packages.

> Why isn't this done already? ;-)

As usual: Because nobody sent the respective patches.

> Well... the "extension" manpage would simply not be part of the
> package itself (which is static, by essence)... but the package would
> include the doc (manpage, if we want) generator.

No, this is not going to be accepted (by the distributions/vendors).

> > So then we should try to have this better documented than it is today. =
=20
> > Mentioning p-o-m in the iptables documentation would be a start..
>=20
> p-o-m is already mentionned, but in the netfilter extensions HOWTO, I
> think. It is not mentionned in the manpage, but iptables manpage is
> about userspace anyway. And that has been a moment since I think that
> there really should be a manpage about userspace (iptables), a manpage
> about kernel (there are some things to tell, and I have started one,
> which I'll sent in a few days), and one about extensions.

Please let's not replicate too much information that already exists in
some HOWTO inside of the manpages.  This results in a maintainance
nightmare, since every piece of documentation has to be updates once
something changes.=20

I'd rather add the howto's to the iptables tar.gz, so the vendors can
put them in /usr/share/doc.  The manpage would then just point to them.

>  Herve
> (=B0=3D  Herv=E9 Eychenne
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--W2ydbIOJmkm74tJ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFADw/wXaXGVTD0i/8RAvZTAJ9jShfUHArf8XPYWTGzrB30LRAmAQCgntEn
PzpwG67Ve/vJhHDRk9qxtRo=
=cQVh
-----END PGP SIGNATURE-----

--W2ydbIOJmkm74tJ2--

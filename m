From: Harald Welte <laforge@netfilter.org>
Subject: Re: sctp conntrack
Date: Sun, 1 Aug 2004 18:50:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040801165005.GA14539@sunbeam2>
References: <20040722191649.GJ14946@obroa-skai.de.gnumonks.org> <200407271348.34615.immidi@spymac.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kiran Kumar Immidi <immidi@spymac.com>
Content-Disposition: inline
In-Reply-To: <200407271348.34615.immidi@spymac.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 27, 2004 at 01:48:34PM +0530, Kiran Kumar Immidi wrote:
> On Friday 23 July 2004 12:46 am, Harald Welte wrote:
>=20
> > I was about to include the SCTP conntrack patch into my set of pending
> > patches for 2.6.9 but then discovered that you don't export the timeouts
> > via /proc (similar to what recent versions of ip_conntrack_tcp do).
> >
> > Would you please include suport for /proc tuning of the timeouts and
> > submit a patch against current CVS?
>=20
>   The attached patch adds this support. It is a diff against current cvs =
pom=20
> sctp-conntrack-nat module, the following doubt remains:

thanks, applied.

>=20
> - The type of these timeouts in case of TCP is unsigned long, though the =
code=20
> in ip_conntrack_standalone.c treats them as unsigned int. I am not sure o=
f=20
> the working, but I suspect something wrong here. I have followed the same=
=20
> pattern however.

yes, indeed. on 64bit archs this is going to cause trouble :(

> Regards,
> Kiran Kumar Immidi
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDR89XaXGVTD0i/8RAsk4AKCjxFmHG4Qw1I3jkXScHOjlXlw3PQCfbQw8
Z1pz6GOd4VyivTTheRqkJd0=
=OKNe
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--

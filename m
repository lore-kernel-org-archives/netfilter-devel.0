From: Harald Welte <laforge@netfilter.org>
Subject: Re: HOPLIMIT
Date: Thu, 19 Feb 2004 21:38:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040219203855.GK4797@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0402161319410.13183-100000@filer.marasystems.com> <004501c3f494$c2150340$0e25fe96@pysiak>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9pltayyoy9lWEMH"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <004501c3f494$c2150340$0e25fe96@pysiak>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--M9pltayyoy9lWEMH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 16, 2004 at 02:57:04PM +0100, Maciej Soltysiak wrote:
> Ok, going back to the issue here.
>=20
> I called the target "HL" but it was later on renamed in pom-ng to HOPLIMI=
T.
>=20
> Running pom-ng and applying HOPLIMIT causes the kernels
> which have HL (2.4.21-pre4+ and 2.5.65+) to have these duplicated.

oops.  I should have renamed them before submitting to the mainstream
kernel.  My fault :(

> Now, either we rename HOPLIMIT in pom-ng to HL (I opt on this)
> or we fix the names/paths in HOPLIMIT pom-ng and submit a patch
> to the kernels to rename HL to HOPLIMIT.

No, we go back to 'hl'.

> I would like to take care of this, but I would like to have a clear
> decision. Let's decide whether we stay with HL or switch to HOPLIMIT.
> I am in favor of HL.

Thanks, please submit a patch.

> Regards,
> Maciej

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--M9pltayyoy9lWEMH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANR7fXaXGVTD0i/8RAg3aAJ90Fj8Tz9iSSU1OdtDUhAVWHzYhHgCfZTc5
wRQeLjau6EZ7zTLK4eom+oE=
=Nf0D
-----END PGP SIGNATURE-----

--M9pltayyoy9lWEMH--

From: Harald Welte <laforge@netfilter.org>
Subject: iptables.8 manpage not complete
Date: Mon, 3 Mar 2003 18:25:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030303172520.GD11384@sunbeam.de.gnumonks.org>
References: <200302132039.58656.bdschuym@pandora.be> <20030214072944.GI14794@sunbeam.de.gnumonks.org> <20030218164739.GF445@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0/kgSOzhNoDC5T3a"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20030218164739.GF445@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0/kgSOzhNoDC5T3a
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2003 at 05:47:40PM +0100, Herv=E9 Eychenne wrote:
> > What also is on my TODO list for some time:  Put manpage sections for
> > all recently-added-to-mainstream-kernel matches+targets.  I think the
> > manpage hasn't been synced with the by-default available matches/targets
> > for quite some time.
>=20
> Oh, really?
> It seems to me that my last patch added the missing matches and
> targets, and that none has been added since (although I remember
> having posted a request on netfilter-devel about the possible
> inclusion of NETMAP in mainstream kernel and received no answer...).

the 'helper' match present in 2.4.20 is at least one example which is
not in the manpage yet. We already had this in 1.2.7a!

>  Herve
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0/kgSOzhNoDC5T3a
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Y5AAXaXGVTD0i/8RAkhmAJ0UV/bUkjvDR5GBg0AIvqSdgR7JEQCgju//
y+dSa0QfjFA5K5jBXp/TAqY=
=CugK
-----END PGP SIGNATURE-----

--0/kgSOzhNoDC5T3a--

From: Harald Welte <laforge@netfilter.org>
Subject: Re: {PATCH]: fix expectation eviction order
Date: Wed, 1 Oct 2003 09:38:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031001073845.GP5758@sunbeam.de.gnumonks.org>
References: <3F775469.6070107@trash.net> <20030930195427.GC734@obroa-skai.de.gnumonks.org> <3F7A4340.2010003@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6bKodGeYF53agbop"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F7A4340.2010003@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6bKodGeYF53agbop
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2003 at 05:00:16AM +0200, Patrick McHardy wrote:
> Harald Welte wrote:
>=20
> >Committed to CVS now.
> >
> Status: Pending for kernel inclusion, needs testing
>=20
> I may have changed a bit too much for a simple bugfix, since I wanted
> to be sure to keep correct behaviour in case of multiple manglings
> to one packet I just deleted and rewrote it. At that occasion I changed
> the lookup stuff to list_for_each_entry ;) This patch is a little less
> intrusive, IIRC Martin is working on the list stuff anyways so maybe
> it's more appropriate.

I'm fine with the original patch - however if Martin has clashing
changes, he's free to update or revert your patch in CVS ;)

> Best regards,
> Patrick
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6bKodGeYF53agbop
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/eoSEXaXGVTD0i/8RAuAfAJ45K+fkqYgXK5EEdppc0XNnITqc+wCggmgP
JINoCN836C2i5Ifvc0Uh2VU=
=najf
-----END PGP SIGNATURE-----

--6bKodGeYF53agbop--

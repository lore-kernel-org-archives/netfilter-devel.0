From: Harald Welte <laforge@netfilter.org>
Subject: Re: Changing the conntrack / NATP information.
Date: Wed, 17 Mar 2004 14:59:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040317135934.GB21899@sunbeam.de.gnumonks.org>
References: <4055C7C3.2030003@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Content-Disposition: inline
In-Reply-To: <4055C7C3.2030003@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 15, 2004 at 05:12:03PM +0200, Emmanuel Guiton wrote:
>=20
> Hi!
>=20
> I wish to change the connection tracking / NAPT information of my target=
=20
> upon reception of a certain nf_conntrack event. Is it possible to do so=
=20
> by doing the following for example:

you can do so.  Please make sure you get the locking right
(ip_conntrack_find_get() / _put()) and note that any change after the
first packet has already been transformed is too late since it will
break the connection.
>                Emmanuel

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAWFnGXaXGVTD0i/8RAgl7AKCaGffEDVFa5Lb00kezOX3mVTCCNACgl3BI
tMLP65qiY5kkyOx/Os2R6OQ=
=zJLk
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--

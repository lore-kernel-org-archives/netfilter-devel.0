From: Harald Welte <laforge@netfilter.org>
Subject: Re: struct iptc_handle ?
Date: Fri, 3 Oct 2003 12:58:43 +0200
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <20031003105843.GG5758@sunbeam.de.gnumonks.org>
References: <3F70918A.5050904@sezampro.yu>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bTvu1DYXfJBfnm9"
Cc: netfilter@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: slists@sezampro.yu
Content-Disposition: inline
In-Reply-To: <3F70918A.5050904@sezampro.yu>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org


--4bTvu1DYXfJBfnm9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2003 at 08:31:38PM +0200, slists@sezampro.yu wrote:
> Hi,
>=20
> Where is "struct iptc_handle" declared ? I've only find "typedef struct=
=20
> iptc_handle *iptc_handle_t;" in libiptc.h
> but no "struct iptc_handle" declaration...

search for 'STRUCT_TC_HANDLE' in libiptc.c

> Regards,

*sigh* why is everybody asking development questions on the user list?

Most of the developers don't really read this list.  So _PLEASE_ ask on
the right list..

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4bTvu1DYXfJBfnm9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fVZjXaXGVTD0i/8RAjEMAJ4tvwB0NsGmenq5Md3TiD+qH0y/rACdHbN5
4fwgObrYw9fE+Wg8a/WTvtY=
=PgjB
-----END PGP SIGNATURE-----

--4bTvu1DYXfJBfnm9--

From: Harald Welte <laforge@netfilter.org>
Subject: Re: /proc/net/ip_conntrack problem
Date: Sun, 15 Feb 2004 17:01:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040215160140.GR15567@sunbeam.de.gnumonks.org>
References: <E1Ap9md-000c35-CG@alf1.lmb.internal>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fqIB0bRxfTYxTb/F"
Cc: netfilter@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "T. Horsnell (tsh)" <tsh@mrc-lmb.cam.ac.uk>
Content-Disposition: inline
In-Reply-To: <E1Ap9md-000c35-CG@alf1.lmb.internal>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--fqIB0bRxfTYxTb/F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 06, 2004 at 05:28:51PM +0000, T. Horsnell (tsh) wrote:
>=20
> I need to maintain a log of SNAT'd connections/disconnections
> which contain the source/dest ip/port of the host before
> SNAT'ing. As discussed on this list before, the POSTROUTING -j LOG
> target doesnt provide this information, so I've written a crude
> logger of my own.
>=20
> This logger is a perl script which does the following:

please don't do it.  frequent reading of /proc/net/ip_conntrack is not
reliable and will slow down your firewall significantly.

I recommend using ctnetlink for this kind of program.

> What happens if the ip_conntrack data is being updated
> at the instant /proc/net/ip_conntrack is being read?
> Is there the possibility of a race condition here which
> might explain what I'm seeing? Any suggestions welcome.

yes, there almost certainly is one.

> Cheers,
> Terry.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--fqIB0bRxfTYxTb/F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAL5fkXaXGVTD0i/8RAonjAJ9/W3JmRhgJ8h6582wKRvc+3GT70wCgmCH/
hfSKhiYGlPX7TmntI0245GQ=
=cxTD
-----END PGP SIGNATURE-----

--fqIB0bRxfTYxTb/F--

From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP connection tracking and NAT patches
Date: Wed, 26 Mar 2003 16:48:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326154821.GC21953@sunbeam.de.gnumonks.org>
References: <Pine.GSO.4.03.10303190516050.23211-100000@shemp.vdata.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tpZe61tYkA9f+p/0"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jeff Hall <hall@vdata.com>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.03.10303190516050.23211-100000@shemp.vdata.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tpZe61tYkA9f+p/0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2003 at 03:32:46AM -0500, Jeff Hall wrote:
> +			if ( other_exp !=3D exp )

I've changed this into=20
			if (other_exp !=3D exp && other_exp->seq =3D=3D exp->seq)

to make sure we really delete only the corresponding expectation in the
other direction.  At least theoretically we can have more than one call
in a single session...

Can you please try (+test) ip_conntrack_pptp.c version 1.8 from
netfilter-extensions CVS in combination with the
'pending/25_natcore_nohelper.patch' of patch-o-matic?

Thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tpZe61tYkA9f+p/0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gcvFXaXGVTD0i/8RAjbJAKCXhB/dXJM67wUR2ilxZfghTKlxXACfajEc
vvj9m/6oh+MxjUI7jJ8+48g=
=CqcY
-----END PGP SIGNATURE-----

--tpZe61tYkA9f+p/0--

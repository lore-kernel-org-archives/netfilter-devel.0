From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT for IPv6
Date: Wed, 26 Nov 2003 20:48:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031126194852.GD3740@obroa-skai.de.gnumonks.org>
References: <20031122052856.5228.24236.Mailman@netfilter-sponsored-by.noris.net> <16319.2729.387658.806467@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-nfil@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <16319.2729.387658.806467@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2003 at 11:05:13PM -0800, Don Cohen wrote:

> I also don't see that IPV6 reduces my need for NAT.
> For instance, my ISP will probably still give me only one IP address=20
> that I'll want to share with my home network.

That is actually violating the address allocation guidelines of the
RIR's, IIRC.

Unless there is only a single segment on the other side, you should
receive a /48.  If there is only a single segment, a /64.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/xQOkXaXGVTD0i/8RAq1FAJ9pgz7YAa04iwxaCzI9ZFPu7wnu3ACeNEp3
1XzFyXVBf7lrRkRx2tWzvxA=
=p+YN
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--

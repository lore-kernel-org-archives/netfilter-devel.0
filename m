From: Harald Welte <laforge@netfilter.org>
Subject: Re: Fw: [Bug 133788] New: ip_conntrack_in: Frag of proto 17
Date: Wed, 29 Sep 2004 09:43:29 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040929074328.GB31674@sunbeam.de.gnumonks.org>
References: <20040928130512.57479400.davem@davemloft.net>
	<20040928220532.GN29961@sunbeam.de.gnumonks.org>
	<4159F559.3040400@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4159F559.3040400@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2004 at 01:35:53AM +0200, Patrick McHardy wrote:
> Harald Welte wrote:
>=20
> >The conntrack message basically means that at NF_IP_PRE_ROUTING we
> >suddenly see fragmented packets.  This "can never happen" since at the
> >same PRE_ROUTING hook we defragment just before
> >via ip_conntrack_defrag() -> ip_ct_gather_frags() -> ip_defrag()
> >=20
> >
>=20
> Here is the patch. Untracked and already tracked (loopback) packets
> are not defragmented, but the check in ip_conntrack_in for
> untracked/already tracked is after the check for fragments.
> This patch moves it up.

Sometimes I feel like I'm blind.  Thanks, Patrick.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBWmegXaXGVTD0i/8RAn6LAJ4gQ/fwYgvRXNrNSSq8lkDdyN0ccgCgp8fn
Gqv7mK2hz45gXSg7V7QH+fI=
=F0eW
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--

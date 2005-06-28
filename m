From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Tue, 28 Jun 2005 09:13:08 +0200
Message-ID: <20050628071308.GE13239@sunbeam.de.gnumonks.org>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WkfBGePaEyrk4zXB"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42C0806E.3010400@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--WkfBGePaEyrk4zXB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2005 at 12:40:46AM +0200, Patrick McHardy wrote:
> +struct cta_proto {
> +       unsigned char num_proto;        /* Protocol number IPPROTO_X */
> +       union ip_conntrack_proto proto;
> +};
>=20
> These should be changed not to use internal conntrack structures, it
> will hurt us when we want to change them. Instead it should replicate
> the fields interesting for the user. Also please use fixed-size types
> instead of unions etc. All structures including u64 types should be
> padded to multiples of 8 so they are equally sized on 32-bit and 64-bit
> systems.

agreed.  However, we still don't have some kind of versioning in the
protocol, too.  I think we've learned by now that we need versioned
structures ;)

> +/* ctnetlink multicast groups: reports any change of ctinfo,
> + * ctstatus, or protocol state change.
> + */
> +#define NFGRP_IPV4_CT_TCP      0x01
> +#define NFGRP_IPV4_CT_UDP      0x02
> +#define NFGRP_IPV4_CT_ICMP     0x04
> +#define NFGRP_IPV4_CT_OTHER    0x08
>=20
> I'm not sure how useful these groups are. I think groups for different
> event-types might be more useful to reduce the noise.

that was my idea in the beginning (since I didn't think of events at
that point).

Still, I think creating messages for any kind of event (even if noone
listens) is too much overhead.  netlink needs to be extended to deal
with that issue.

Maybe the 'which socket is subscribed to which group' accounting should
be done by the core netlink layer, which would then only export a
merged bitmask of all netlink sockets.  This way ctnetlink can easily
check whether it makes sense to create a certain event message or not.

This should be useful for other netlink users, too.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WkfBGePaEyrk4zXB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCwPiEXaXGVTD0i/8RAr2TAJ94ipHodK08FoloTKA8ycc+5cFquACgrwuV
Mzc243+TXcWx/OibLsh2SkY=
=GPsV
-----END PGP SIGNATURE-----

--WkfBGePaEyrk4zXB--

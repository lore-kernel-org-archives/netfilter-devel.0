From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and optimization
Date: Sun, 1 Aug 2004 20:11:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040801181150.GI14539@sunbeam2>
References: <200406250457.NAA07080@toshiba.co.jp> <Pine.LNX.4.33.0406251133230.11001-100000@blackhole.kfki.hu> <20040721213653.GR27487@obroa-skai.de.gnumonks.org> <200407290609.PAA13928@toshiba.co.jp> <20040801164653.GA10656@sunbeam2> <410D23AB.2070203@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dCSxeJc5W8HZXZrD"
Cc: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	kadlec@blackhole.kfki.hu, netfilter-devel@lists.netfilter.org,
	kisza@securityaudit.hu, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <410D23AB.2070203@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dCSxeJc5W8HZXZrD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 01, 2004 at 07:08:59PM +0200, Patrick McHardy wrote:

> >>	struct tcphdr hdr;
> >>	struct tcphdr *tcph
> >>
> >>	tcph =3D skb_get_bits(skb, &hdr, skb->nh.iph->ihl*4, sizeof(hdr));
> >>
> >>If skb is neither shared nor cloned, this function linearize up to tcp=
=20
> >>header and returns the pointer to tcp header in skb.
> >>Otherwise, copies tcp header to "hdr" and return the pointer to it.
> >>If error, return NULL.
>
> The number of copies will still depend on the ruleset with non-linear skb=
s.
> skb_linearize_partial sounds like a much better idea to me.

Oh yes, indeed.  I somehow mis-interpreted Yasuyiki's approach.  We
should linearize with the first call, so that every 2nd, 3rd, ... call
do nothing but immediately return.

> Regards
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

--dCSxeJc5W8HZXZrD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDTJmXaXGVTD0i/8RAgcXAJ98XRW38WY2RLgvb9txCMQk399y7ACfXndn
RaI8VHI8ty+XVy71BrSjPcs=
=KbUq
-----END PGP SIGNATURE-----

--dCSxeJc5W8HZXZrD--

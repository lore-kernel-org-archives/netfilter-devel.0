From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Introducing the Change API
Date: Thu, 16 Dec 2004 13:40:49 +0100
Message-ID: <20041216124049.GF10165@sunbeam.de.gnumonks.org>
References: <41B236F6.9090405@eurodev.net> <41B36E59.5020800@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s5/bjXLgkIwAv6Hi"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <41B36E59.5020800@trash.net>
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


--s5/bjXLgkIwAv6Hi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 05, 2004 at 09:23:53PM +0100, Patrick McHardy wrote:

> I think that depends on what we want to do with ip_conntrack once
> nf_conntrack is merged. Since I really don't feel like keeping
> three codebases in sync (ip_conntrack 2.4 + 2.6 and nf_conntrack),
> I would prefer to remove it. If we do this, it doesn't make much
> sense to add further features to it. But I'm not sure what Harald's
> and Krisztian's plans are for ct_sync, so they might disagree with me.

I think we should move to nf_conntrack ASAP.  All new
code/features/API's should be developed on top of nf_conntrack.  We
really should put ip_conntrack into a maintainance-only mode once
nf_conntrack becomes mainline.

Actually I only want to do some nf_conntrack vs. ip_conntrack
benchmarking, which I never got aroun doing up to now :(  With a little
luck, I can do this over the weekend.  If the results are acceptable,
nf_conntrack will be submitted maybe as soon as 2.6.11.=20

nfnetlink-ctnetlink in it's existing form will not be submitted to
mainline.  I'm workin on a new (ctnetlink2) patch, that is
template-based and to a certain degree arch/alignment/endian
independent.   If this ctnetlink2 will be submitted upstream, it will at
least support nf_conntrack, maybe also ip_conntrack - but not the other
way around.

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

--s5/bjXLgkIwAv6Hi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBwYJRXaXGVTD0i/8RAs/yAJ9izqWM7jIbo2PWgxmUb2gal2E+egCgg2UZ
jD17aNvb/JddNkUyi/n10Fc=
=mAus
-----END PGP SIGNATURE-----

--s5/bjXLgkIwAv6Hi--

From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack & NAT
Date: Wed, 7 Dec 2005 18:36:51 +0530
Message-ID: <20051207130650.GA4151@rama.exocore.com>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
	<20051207070517.GA4361@rama.exocore.com>
	<20051207070039.GC474@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Cc: netfilter-devel@lists.netfilter.org, Jan Kasprzak <kas@fi.muni.cz>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	Herve Eychenne <rv@wallfire.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20051207070039.GC474@oknodo.bof.de>
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


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2005 at 08:00:39AM +0100, Patrick Schaaf wrote:
> For example, I use ipset bitmaps to determine, at conntrack-NEW-time,
> whether some connection should be REDIRECTed, or not. This decision,
> once made, should stay stable for the same connection, even if the
> ipset bitmap is modified wrt to another new connection between the
> same partners.

Patrick, whatever kind of special-case applications you might have, I
honestly don't care at this point.

The fundamental issue at this time is to get nf_conntrack
feature-complete with what ip_conntrack offers.  This allows us to get
rid of ip_conntrack and therby remove lots of duplicate code that was
only meant as an intermediate solution.

The other fundamental issue is that we don't want to extend the current
full-blown ip_nat/iptable_nat code to offer the same functionality for
IPv6.

So that's why nf_conntrack based stateful nat will be restricted to
IPv4.

If we later need something different for IPv6, then let's do that at
this later point.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDlt5qXaXGVTD0i/8RAt+5AJ4wznOavxQDosfZyIm1PKfa+qJ9lACbBPQr
CqYGnlJgEDiZHocADEitHOg=
=O1MT
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--

From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
	infrastrure for netfilter]
Date: Fri, 14 Jan 2005 09:31:55 +0100
Message-ID: <20050114083154.GG9070@sunbeam.de.gnumonks.org>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
	<41E73258.7030002@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="84ND8YJRMFlzkrP4"
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <41E73258.7030002@trash.net>
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


--84ND8YJRMFlzkrP4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 14, 2005 at 03:45:44AM +0100, Patrick McHardy wrote:

> But unlike ct_extend, the get_features stuff is very unflexible. The
> way it is currently implemented it only works for a single dynamically
> allocated part without leaving holes, and it even it if could handle more,
> they all need to be determined at allocation time, so a worst-case=20
> assumption
> has to be made for anything depending on the ruleset. This is especially
> a concern with modules and distribution-kernels, NAT could be loaded at a=
ny
> time, so the memory needs to be allocated in advance.

Nobody should ever load iptable_nat if it isn't actually used.  That's
what module autoloading is about.  If a distribution does this, it is
straight forward broken.

Also, I haven't seen this in practise so far, so it's not a valid
optimization target from my point of view.

> >But, then think of a firewall in front of an FTP (IRC/...) Server, and
> >your traffic pattern immediately looks like 50% of your connections (not
> >talking about traffic) have helper private data... and my argument
> >becomes stronger again.
> >
> Sure, but helpers are slow anyway. The additional allocation is a one-time
> effort, the two disjunct pieces of memory shouldn't hurt too much since
> nf_conntrack is very large and covers multiple cache-lines already. Rusty
> mentioned he got struct ip_conntrack down to ~150b, this makes it possible
> to have a lot more active connections without exceeding the cache.

Ok, agreed for the helper case.  But my argument for NAT still holds, at
least as far as I see.  Also, stuff like the accounting counters are a
similar case.

So maybe in the end we need 'features' for those, and ct_extend for
helper related data?

> One more thing I was thinking about. If we put ip_conntrack in maintenance
> mode and probably deprecate it at some time, I see little reason to remove
> ipchains compat just now. Why not just let it fade out together with
> ip_conntrack once nf_conntrack is in ? I haven't checked if it was because
> of incompatibilities or required changes with Rusty's latest work, if so
> that would be a good reason.

I don't have a particular favour for or against any of the proposed
solutions.

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

--84ND8YJRMFlzkrP4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB54N6XaXGVTD0i/8RAkqlAKCghno+2LpxCcIaat8yv5INU8p4PgCeJuO/
uAWsDRr4GKIiJWr8nEjy09M=
=SHb5
-----END PGP SIGNATURE-----

--84ND8YJRMFlzkrP4--

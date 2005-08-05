From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Drop expectation refcount after unlinking expectation
Date: Fri, 5 Aug 2005 15:17:21 +0200
Message-ID: <20050805131721.GJ4245@rama.de.gnumonks.org>
References: <42F2B507.8070207@eurodev.net> <42F33D8C.5070904@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yr/DzoowOgTDcSCF"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42F33D8C.5070904@trash.net>
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


--yr/DzoowOgTDcSCF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 05, 2005 at 12:21:00PM +0200, Patrick McHardy wrote:
> Pablo Neira wrote:
> > This patch comes from the following thread:
> >=20
> > [PATCH 6/7] Fix expectation creation
> >=20
> > In unlink_expect, the expectation is removed from the list so the
> > refcount must be dropped as well.
>=20
> The patch is fine, but it leaves the somewhat broken function
> __ip_ct_expect_unlink_destroy around. I'm not sure what the
> intention of this function is, it looks like a lazy way of
> killing conntracks without manually dropping the timer refcnt.
> Anyway it invites people to use it in the wrong place and
> should die IMO.

Ok, if it dies we'd have to export unlink_expect() for ctnetlink.

However, all places calling unlink_expect() also call expect_put()
immediately after it - with one exception: find_expectation() :(

Getting back to your comment: =20
> it looks like a lazy way of killing conntracks without manually
> dropping the timer refcnt.

Sorry, I can't follow you: Did you mean something like 'lazy way of
killing expects without manually expiring the timer' ? =20

So your whole objection is to not have timer_del() inside
__ip_ct_expect_unlink_destroy() ?   this can be changed easily.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yr/DzoowOgTDcSCF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC82bhXaXGVTD0i/8RAiqiAJ9+WfVPCLd7vTrZKbYIJyf0H6xmMQCfVher
OwJ3SNQqB9mrRDLRI7LMOXs=
=Sj4r
-----END PGP SIGNATURE-----

--yr/DzoowOgTDcSCF--

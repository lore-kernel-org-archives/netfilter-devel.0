From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH][MARKCB] Balancing connections betewen a few internet links with HA.
Date: Mon, 22 Sep 2003 00:28:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921222853.GA30961@sunbeam.de.gnumonks.org>
References: <3F68C63E.4070309@zobniow.net> <20030921142233.GD20986@sunbeam.de.gnumonks.org> <3F6E1ED5.4080304@zobniow.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciek Zobniow <maciek@zobniow.net>
Content-Disposition: inline
In-Reply-To: <3F6E1ED5.4080304@zobniow.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 21, 2003 at 11:57:41PM +0200, Maciek Zobniow wrote:
> >You can build a solution based on the CONNMARK target/match, together
> >with the 'nth' match, the MARK target and policyrouting.
>
> If I am good understanding what you mean, your suggested solution will=20
> have only WRR balancing algoritm, without HA.=20

This is true, at least as long as you only use 'nth'.  There are also
the 'fuzzy' and 'random' matches, which would give slightly different
behaviour.

> Additonaly related connections will have possability to go by diffrent
> ways.=20

No, since CONNMARK givs us the inherited connection mark (and thus the
needed persistency for related connections)

> In my module you can chose another algorytm and I will extend the set
> of possibly balance algoritms (there is a lot of possibilites).

yes.  However, you implement thos algorithms specifically for your
module.  If the algorithm was somehow implemented as iptables match,
everybody could use it [even for a different purpose].

> Anyway, one from reasons why I like the *nix world is that in this world=
=20
>  for each problem you can find a few ways to solve it.

Sure! However as of now I don't think that your proposed solution is
going to be integrated as 'standard solution' for the problem of
balancing connections, sorry.

> Maciej Zobniow
> Open Source - Free software for free people.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/biYlXaXGVTD0i/8RAtePAJ474KG6QLZZNg38xPPtVpx1WQbAkwCfWx3d
NFttu933tJaIUv5Qq2UYANM=
=nVKn
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--

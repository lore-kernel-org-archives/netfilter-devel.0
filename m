From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] [PATCH] ctnetlink updates
Date: Fri, 1 Apr 2005 08:59:06 +0200
Message-ID: <20050401065906.GQ19835@sunbeam.de.gnumonks.org>
References: <424747E3.7000300@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3wyj3Xt2kUWLNC5K"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <424747E3.7000300@eurodev.net>
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


--3wyj3Xt2kUWLNC5K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 28, 2005 at 01:55:15AM +0200, Pablo Neira wrote:
> Hi,
>=20
> I've ported nfnetlink-ctnetlink to 2.6 ip_conntrack to make the transitio=
n=20
> easier. So my intentions are porting it to nfconntrack once it gets pushe=
d=20
> forward. My work is done on top of the ct-event-API.

We have the habit of working simultaneously in the same area :(
Unfortunately I've reorganized the tree and shuffled the files, so I'll
have a hard time merging...

> There are some issues I'd like to discuss:
>=20
> o Declaring ID as unsigned int. I think it's just fine.
>=20
> 	- A conntrack must be identified with one of the tuples
> 	(original or reply) and its id. That way it can be uniquely
> 	identified.
>=20
> 	- Using u_int64_t just reduces the possibility of the wrapping
> 	around but such possible problem is still there.

Well, those of you who know the discussion know my point of view: I
don't want an Id and/or an ordered list.  If the user tells us to delete
a connection with a given tuple, we simply delete it. =20


--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3wyj3Xt2kUWLNC5K
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCTPE6XaXGVTD0i/8RAs70AJwNthyTkZSu4lhHVFEWHFcMJfa5RQCfUVqt
ADvntJHa5oHzM9lIG4mAJ80=
=boj6
-----END PGP SIGNATURE-----

--3wyj3Xt2kUWLNC5K--

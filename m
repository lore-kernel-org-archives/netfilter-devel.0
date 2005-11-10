From: Michael Bellion <mbellion@hipac.org>
Subject: Re: [ANNOUNCE] Release of nf-HiPAC 0.9.0
Date: Thu, 10 Nov 2005 02:07:24 +0100
Message-ID: <200511100207.25108.mbellion@hipac.org>
References: <200509260441.42483.mbellion@hipac.org>
	<200510021430.21697.mbellion@hipac.org>
	<1131575752.3423.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4146011.P4spjQs24Z";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter@lists.netfilter.org, Bart De Schuymer <bdschuym@pandora.be>,
	Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1131575752.3423.33.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--nextPart4146011.P4spjQs24Z
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

> Op zo, 02-10-2005 te 14:30 +0200, schreef Michael Bellion:
> > > Also, is it not possible to make a B+ tree with the standard iptables?
> > > I don't see why it shouldn't be possible. The jump to a new chain can
> > > be seen as going deeper into the B+ tree. So it should be possible to
> > > construct an iptables table structure that looks very similar to the =
B+
> > > tree of nf-hipac, for some given rule set. I guess this will be
> > > somewhat slower than nf-hipac, but I'd like to see the performance
> > > difference...
> >
> > Sorry, but you seem to confuse some things.
> > nf-HiPAC is not based on B+trees or any other kind of B-trees.
>
> So the algorithm of nf-hipac was changed in view of the one you were
> using in 2003? I remembered from your talk then that you used B+trees
> and this is confirmed by the slides you've finally put online.

The reason why I said that b-trees are not used in hipac was that the b-tre=
es=20
are not the main data structure and are not the main solution of the proble=
m.

The problem is solved by a graph that consists of a lot of nodes.

During a lookup this graph is traversed and each node that is visited=20
internally uses again a certain data structure. In 2003 btrees were used=20
internally at each node of the graph. In the current implementation simple=
=20
static binary search is used instead.

So basically you can forget about the btrees. They are not important for th=
e=20
solution of the problem. Have a closer look at the slides of the more recen=
t=20
presentations.

Best regards
	Michael Bellion

--nextPart4146011.P4spjQs24Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDcp1NqKCdDrsF/xIRAr9CAJ0aU5Bcoj3sM1+6kmqfkxX8Ur+dsgCgiMK4
V4NLYeuTWNpFjlANFxkGsTc=
=g+TB
-----END PGP SIGNATURE-----

--nextPart4146011.P4spjQs24Z--

From: Michael Bellion <mbellion@hipac.org>
Subject: Re: [ANNOUNCE] Release of nf-HiPAC 0.9.0
Date: Sun, 2 Oct 2005 14:30:13 +0200
Message-ID: <200510021430.21697.mbellion@hipac.org>
References: <200509260441.42483.mbellion@hipac.org>
	<433AA30E.7060709@ufomechanic.net>
	<1128252040.3388.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1562104.OhjE1XUbhN";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter@lists.netfilter.org, Bart De Schuymer <bdschuym@pandora.be>,
	Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1128252040.3388.15.camel@localhost.localdomain>
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

--nextPart1562104.OhjE1XUbhN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

> > Speaking under fear of blasphemy I'm wondering what stops this becoming
> > iptables proper? (ipv4 anyway)?  OK, it would want linking to
> > nf_conntrack instead of ip_conntrack and a v6 version doing type stuff,
> > but it seems the biz.
>
> http://www.hipac.org/documentation/user_guide.html states some
> incompatibilities with iptables.

Yes, currently there are some negligible differences. Most of them can be=20
worked around easily and will be fixed in future versions.

> What's always resisted me from looking to it closely is that there is no
> documentation about the implementation.=20

Yes, that is true and a big problem.
There are a lot of people that think that nf-HIPAC would rearrange the rule=
s=20
in some user-defined chains. But that is completely wrong. Nf-HiPAC used a=
=20
completely different approach. The rules are translated into a very efficie=
nt=20
data structure that does not have anything to do with iptables'=20
representation of rules in tables and chains.
I really need to add some documention about the algorithmic approach.=20

> The reason why counters aren't supported
> interests me too, I can't see why adding 1 to a 64-bit integer would
> result in a noticeable performance drop.

It does make a difference, because it means a write to an otherwise complet=
ely=20
read-only ruleset.=20
But independent from that, the netfilter developers agree that it is a bad=
=20
approach to have counters enabled by default for each and every rule=20
(refering to last years netfilter workshop). Future versions of iptables (o=
r=20
successors of iptables) won't come with counters enabled by default on all=
=20
rules.

It is very easy to add support for counters to nf-HiPAC. Just write an=20
iptables match or target for it.

> Also, is it not possible to make a B+ tree with the standard iptables? I
> don't see why it shouldn't be possible. The jump to a new chain can be
> seen as going deeper into the B+ tree. So it should be possible to
> construct an iptables table structure that looks very similar to the B+
> tree of nf-hipac, for some given rule set. I guess this will be somewhat
> slower than nf-hipac, but I'd like to see the performance difference...

Sorry, but you seem to confuse some things.
nf-HiPAC is not based on B+trees or any other kind of B-trees.=20
nf-HiPAC does not rearrange the rules in some custom userdefined chains in=
=20
order to achieve better performance.
Instead nf-HiPAC translates the iptables representation of tables and chain=
s=20
into a completely different data structure that is much more efficient.

And, trust me, the lookup data structure used in nf-HiPAC will be much fast=
er=20
than anything you can construct based on iptables and user-defined chains.

Regards
	Michael Bellion


--nextPart1562104.OhjE1XUbhN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDP9LdqKCdDrsF/xIRAh1WAJ9GcccuBLEd9APUzqaF3gsLrhpxqwCcCc40
xtvGLIueZ78LPAA5YN2fGd8=
=3NLR
-----END PGP SIGNATURE-----

--nextPart1562104.OhjE1XUbhN--

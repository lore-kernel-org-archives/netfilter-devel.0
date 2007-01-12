From: =?iso-8859-15?q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Subject: Re: [Patch 0/2] Avoid direct connections between NATed hosts
Date: Fri, 12 Jan 2007 19:39:39 +0200
Message-ID: <200701121939.42232@auguste.remlab.net>
References: <1168621167.28615.14.camel@localhost.localdomain>
	<200701121911.48617@auguste.remlab.net>
	<45A7C377.2060600@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1512840.8enYxLr2RT";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45A7C377.2060600@trash.net>
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

--nextPart1512840.8enYxLr2RT
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le vendredi 12 janvier 2007 19:20, Patrick McHardy a =E9crit :
> > In this particular case, your approach is a completely associal
> > short-term solution. In the long run, it will simply cause people
> > with normal/correct NATs to have to relay even more traffic when
> > they should not have to, because of people like you. And it
> > certainly won't prevent Skype from running on your network either.
>
> Port randomization would still be a useful feature, not to wilfully
> break skype, but to make spoofing attacks harder. Currently we
> undo randomization done by the operating system/application. Since
> its optional I don't see real harm in it.

Right, randomizing port numbers when they are allocated can make it=20
slightly more difficult to spoof DNS. Does the "regular" socket code=20
picks port at random or not though? And is the port allocation logic=20
shared between socket and NAT code (IMHO it should either be shared or=20
at least be equivalent)? It makes little sense to secure host behind=20
the NAT and not secure yourself; that also imples there should be no=20
need for an iptables option to enable/disable it.

My concern is with when (and how) Netfilter NAT code allocates a new=20
port number. If the source private-IP/port are identical, the external=20
NATed-IP/port ought be identical too, and certainly not another=20
randomized value.

With that, you have the advantage of random source port numbers (better=20
spoof protection), while not breaking any NAT-aware P2P app.

Sorry for the misunderstanding.

=2D-=20
R=E9mi Denis-Courmont
http://www.remlab.net/

--nextPart1512840.8enYxLr2RT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFp8few+xtvt1tEr0RAsKsAJ4mKb3eQZ/PG7V+ywY4iIdQm8GkPACfYb8G
rWxy8orZLg87rBNHBqFgwCQ=
=C6FT
-----END PGP SIGNATURE-----

--nextPart1512840.8enYxLr2RT--

From: Anatoly Pugachev <mator@rootshell.ru>
Subject: Re: [PATCH] u32 match ported to 2.6 and ipv6
Date: Sat, 16 Apr 2005 12:13:37 +0400
Message-ID: <20050416081337.GA9325@helminth.linuxhacker.ru>
References: <425BF67E.4040903@outerspace.dyndns.org>
	<20050415092754.GE25433@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Cc: Harald Welte <laforge@netfilter.org>, Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050415092754.GE25433@sunbeam.de.gnumonks.org>
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


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2005 at 11:27:54AM +0200, Harald Welte wrote:
> On Tue, Apr 12, 2005 at 04:25:34PM +0000, Jonas Berlin wrote:
> > Here goes, it compiles, haven't tested it. :)
>=20
> well, I would really like the author (i.e. you) to test it (at least
> basic features) before we include it.
>=20
> Would that be possible?

ok, i've just finished testing it with the following configuration:

-m u32 --u32 "117&0xFFFF=3D0x1804"=20

and it "works for me". It is ipv4 only test, since we don't have ipv6 here.
Whole iptables command was following:

iptables -t nat -I PREROUTING -i eth1 -m u32 --u32 "117&0xFFFF=3D0x1804" -m=
 length --length 200:1000 -p udp -d 192.168.5.255 --dport 138 -j DNAT --to =
192.168.0.255=20

as you can see i'm DNAT'ing to broadcast address , pretty unusual, eh? :)

--=20
Anatoly Pugachev

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFCYMkvoubiDytudlARApI4AJ46P9YTd4cTrrqGn1kgy+XF87MBkQCfR836
/f4C3H0Ti43kU8SyDvOnPZU=
=inFA
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--

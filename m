From: Stephen Frost <sfrost@snowman.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Mon, 12 Jul 2004 22:37:00 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040713023700.GM21419@ns.snowman.net>
References: <20040415212034.GE7611@obs.bg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8RJ6MkOGpKElHlfH"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040415212034.GE7611@obs.bg>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8RJ6MkOGpKElHlfH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Ivan Mitev (imitev@obs.bg) wrote:
> i'm using the CVS (20040415) version of iptables and pom-ng, and kernel
> 2.6.5, to test the new ipsec patches (ipsec-XX + policy). =20

I'm doing basically the same thing.  20040710 or so of POM and iptables
and 2.6.7.  Got everything built/compiled/installed/etc.  IPSEC is all
working and whatnot.  My problem is matching things.  I've been trying
to match using spi and I just can't seem to get it to work.  I'm using
the spi I get from setkey -D and from tcpdump but no matter what I try
it doesn't work.

Sorry I can't give more details, but is this supposted to work?  I'll
see about adding something to ipt_policy.c to get it to print out what
it thinks the SPI is tommorow, hopefully.  Anyone else tried this?

The match works if I don't have --spi 0x<blah>, doesn't work if I do. :/

	Thanks,

		Stephen

--8RJ6MkOGpKElHlfH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA80rMrzgMPqB3kigRAn3/AKCJRn9Y3jg5TtAETV8qtwHc5DIXPQCZAY+8
8cZmMwP1EglsejeImqcdvuk=
=BF1h
-----END PGP SIGNATURE-----

--8RJ6MkOGpKElHlfH--

From: Stephen Frost <sfrost@snowman.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Tue, 13 Jul 2004 07:53:06 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040713115306.GN21419@ns.snowman.net>
References: <20040415212034.GE7611@obs.bg> <20040713023700.GM21419@ns.snowman.net> <40F34EF2.2010405@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vH3HHxf962mwD/qo"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40F34EF2.2010405@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vH3HHxf962mwD/qo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Patrick McHardy (kaber@trash.net) wrote:
> Stephen Frost wrote:
> >I'm doing basically the same thing.  20040710 or so of POM and iptables
> >and 2.6.7.  Got everything built/compiled/installed/etc.  IPSEC is all
> >working and whatnot.  My problem is matching things.  I've been trying
> >to match using spi and I just can't seem to get it to work.  I'm using
> >the spi I get from setkey -D and from tcpdump but no matter what I try
> >it doesn't work.
> >
> >Sorry I can't give more details, but is this supposted to work?  I'll
> >see about adding something to ipt_policy.c to get it to print out what
> >it thinks the SPI is tommorow, hopefully.  Anyone else tried this?
> >
> >The match works if I don't have --spi 0x<blah>, doesn't work if I do. :/
>=20
> The --spi option matches the spi given in the setkey policy with
> unique:number. I'll update the manpage ..

Ahhh, now that makes much more sense.  I just had 'require' before.  I'm
getting closer it seems.  Now, at least, I seem to be able to match the
number I put after the 'unique:' using '--reqid'.  Still doesn't work
when using '--spi' though.  Not sure that I care though, unless someone
can tell me a reason why I should?  It's important, of course, to match
the right packets, since I'm doing tunneling and different remote sites
will have access to different things and so different firewall rules to
handle them...

	Thanks,

		Stephen

--vH3HHxf962mwD/qo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA880irzgMPqB3kigRAjN5AJ9aHAASmfue8ARQe9SyEwthi4O0BwCeN0b3
vj06Bj6XDkJS/8Ngt6CuCAk=
=e5nr
-----END PGP SIGNATURE-----

--vH3HHxf962mwD/qo--

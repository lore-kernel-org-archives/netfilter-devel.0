From: Harald Welte <laforge@netfilter.org>
Subject: Re: Support for ip-ranges.
Date: Sat, 23 Aug 2003 23:05:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030823210508.GC6750@sunbeam.de.gnumonks.org>
References: <m3n0ekpevv.fsf@tyfon.gullik.net> <m34r0dub2x.fsf@trylle.birdstep.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Lars Gullik =?iso-8859-1?Q?Bj=F8nnes?= <larsbj@birdstep.com>
Content-Disposition: inline
In-Reply-To: <m34r0dub2x.fsf@trylle.birdstep.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2003 at 01:43:34PM +0200, Lars Gullik Bj=F8nnes wrote:
> Anyway I found the iprange patch on the web page, what are the
> prospects on getting this patch into ipfilter/iptables proper?

we just went through the list of all patch-o-matic patches at the
netfilter developer workshop.  In the case of the iprange match, we
decided that we want to submit it.

Expect it to show up in 2.6 and 2.4.23 (too late for 2.4.22).

> 	Lgb

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R9cEXaXGVTD0i/8RAr7wAJ9jAwDZRVuATq/OumA6HWty0fvPuQCfTXrS
OJ2UVzApZ+jybayVDmP4ZMM=
=t2q4
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--

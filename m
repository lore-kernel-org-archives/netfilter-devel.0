From: Harald Welte <laforge@netfilter.org>
Subject: Re: QUEUE target: fragmented IP appears in reversed order
Date: Fri, 7 Nov 2003 02:38:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031107013812.GG5741@sunbeam.de.gnumonks.org>
References: <20031106215706.GA10641@skunk.one.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hD6P3ib1XCFtz2ni"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: michal salaban <emes@pld-linux.org>
Content-Disposition: inline
In-Reply-To: <20031106215706.GA10641@skunk.one.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hD6P3ib1XCFtz2ni
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2003 at 10:57:06PM +0100, michal salaban wrote:

> is that OK? does kernel IP layer send fragments reversed (don't believe)
> or netfilter changes order for some reason?

is ip_conntrack loaded?

> michal salaban -|- emes (at) pld-linux.org -|- jabber: emes@jabber.org

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--hD6P3ib1XCFtz2ni
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/qveEXaXGVTD0i/8RAt/PAJ98BeVH5N2vw6MYIih47au579AcHQCfWYo4
78pWDuB136Z4vpmipCpiSmg=
=bs5v
-----END PGP SIGNATURE-----

--hD6P3ib1XCFtz2ni--

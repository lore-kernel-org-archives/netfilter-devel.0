From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Layer-7 HTTP Matching Module
Date: Sun, 9 Feb 2003 10:47:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030209094712.GS13269@naboo.fugue.com>
References: <Pine.LNX.4.44.0302040925160.12235-100000@kaybee.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7PAM/4G1BR2SfWzg"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kirk Bauer <kirk@kaybee.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0302040925160.12235-100000@kaybee.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--7PAM/4G1BR2SfWzg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 04, 2003 at 09:29:53AM -0500, Kirk Bauer wrote:
> Does such a module exist or is it being developed?  If not, I may write
> one when I have time if other people think it would be useful.

No, it doesn't exist.  Feel free to go ahead adn implement it.

But be prepared [if you intend it to appear in the kernel], I personally
oppose putting too much stuff like this [string matching] into the kernel. =
=20

> Kirk Bauer <kirk@kaybee.org>

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--7PAM/4G1BR2SfWzg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+RiOgXaXGVTD0i/8RAhgkAJ4iNOrLAny5c4LNP5jJE7EaHaONfwCfUCKv
cQcL1EPGXrR+HXhV1adW3iE=
=ZLUU
-----END PGP SIGNATURE-----

--7PAM/4G1BR2SfWzg--

From: Harald Welte <laforge@netfilter.org>
Subject: Re: Machine Freeze
Date: Wed, 18 Jun 2003 18:40:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030618164026.GF1661@naboo>
References: <Sea2-F31UTvRVuQ6z6w00012065@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OZkY3AIuv2LYvjdk"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ricky Foo <blue_pion@hotmail.com>
Content-Disposition: inline
In-Reply-To: <Sea2-F31UTvRVuQ6z6w00012065@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--OZkY3AIuv2LYvjdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2003 at 07:10:02AM +0000, Ricky Foo wrote:

> My problem now is that with the following helper routine, the entire=20
> machine freezes upon loading the helper module. I have traced the problem=
=20
> to the line "ip_conntrack_expect_related(ct, &expect);".
> Everything seems in place to me. Can anyone see what is the problem?

Sorry, from reading the code I cannot really see where the problem is.

How did you trace the problem down to that line?  Are you using a kernel
debugger or running user-mode-linux with a tracing thread?

If you do so, you should be able to trace the problem down by
single-stepping through ip_conntrack_Expect_related().

>    Ricky

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OZkY3AIuv2LYvjdk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+8JX5XaXGVTD0i/8RAhavAKCWXH+vI3sIh6oqcE66BLLmQW0f1ACcD/WZ
YqfJTCp37FPMrzvolGzcf9k=
=tttY
-----END PGP SIGNATURE-----

--OZkY3AIuv2LYvjdk--

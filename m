From: Harald Welte <laforge@gnumonks.org>
Subject: Re: IPTABLES problem
Date: Mon, 9 Dec 2002 17:31:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021209163108.GM2223@sunbeam.de.gnumonks.org>
References: <039c01c28f1d$e6ad3610$1543a8c0@sanches>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V3eawNQxI9TAjvgi"
Cc: netfilter-devel@lists.netfilter.org, Regina.Tsujiguchi@stj.gov.br,
	Pim Van Heuven <pim.vanheuven@intec2.rug.ac.be>,
	RSVP <ds_mpls@atlantis.rug.ac.be>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexandre Carlos <alexandre@redes.unb.br>
Content-Disposition: inline
In-Reply-To: <039c01c28f1d$e6ad3610$1543a8c0@sanches>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--V3eawNQxI9TAjvgi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2002 at 01:16:46PM -0300, Alexandre Carlos wrote:

> I=B4m using IPTABLES version 1.2.4-dscp do set up the tos value of the
> packets. I=B4m creating the following rule on A and C

Unfortunately this is a very old version of iptables (about one year)
and the FTOS target is not officially supported by the project.

If there were any issues, I wouldn't even remember, sorry.

Please try a more recent version of iptables

> Alex

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--V3eawNQxI9TAjvgi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE99MVMXaXGVTD0i/8RAs29AKCnljVszzNYh7jSvf5BE8OnFWoS5gCff+Ys
f+D2G8dYi0xqxcGHo+mU0KI=
=SJRd
-----END PGP SIGNATURE-----

--V3eawNQxI9TAjvgi--

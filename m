From: Harald Welte <laforge@netfilter.org>
Subject: Re: Set NAT to Full Cone
Date: Tue, 4 Jan 2005 11:37:43 +0100
Message-ID: <20050104103742.GT11370@sunbeam.de.gnumonks.org>
References: <I9690Z$CF67F2C818604363F16F9093A1422E17@bol.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L1jMvVksOaqpmjJm"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: fernandonach <fernandonach@bol.com.br>
Content-Disposition: inline
In-Reply-To: <I9690Z$CF67F2C818604363F16F9093A1422E17@bol.com.br>
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


--L1jMvVksOaqpmjJm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 23, 2004 at 08:55:47AM -0200, fernandonach wrote:

> I need to set IPtables to work on Full Cone mode. If possible, how can
> I do that!?!?

no way, it is impossible.  iptable_nat is a fully symmetric nat
implementation, the most perfect variant of NAT ;)

> Fernando

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--L1jMvVksOaqpmjJm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB2nH2XaXGVTD0i/8RAlgQAKCE4l45VV+KHzraY3osSja7zpNd8ACcCyrl
lW5foB7yL0mGRvDWtideW4U=
=kwY5
-----END PGP SIGNATURE-----

--L1jMvVksOaqpmjJm--

From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Fri, 5 Nov 2004 11:48:45 +0100
Message-ID: <20041105104845.GF5606@sunbeam.de.gnumonks.org>
References: <20041102210440.GA1851@linuxace.com> <418999B2.3070600@trash.net>
	<20041104154355.GA8553@linuxace.com> <418A6D29.60004@trash.net>
	<Pine.LNX.4.61.0411042254020.18136@filer.marasystems.com>
	<418AAF0A.4000201@trash.net>
	<Pine.LNX.4.61.0411050036560.19958@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VgNP6wxEowREGVu+"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0411050036560.19958@filer.marasystems.com>
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


--VgNP6wxEowREGVu+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 05, 2004 at 12:40:03AM +0100, Henrik Nordstrom wrote:

> I am not saying that the current code is correct, only that I see no=20
> reason why MASQUERADE should consider being overly friendly to people=20
> having multiple IP addresses on their dynamic IP interface.

I totally agree with Henrik in this issue. But we relly need to document
it.  Maybe printk() some warning in case somebody adds a second address
to an interface that uses MASQUERADE (from within the notifier)?

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VgNP6wxEowREGVu+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBi1qNXaXGVTD0i/8RAhc1AJ9DtX70pUhZ8dlpAEx/2o+H9NetjwCgnS6X
1+Fbg56Nk6sfIxHt8nBxttM=
=JQg5
-----END PGP SIGNATURE-----

--VgNP6wxEowREGVu+--

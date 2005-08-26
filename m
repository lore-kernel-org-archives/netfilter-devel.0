From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] TTL target goes mainline ?
Date: Fri, 26 Aug 2005 15:19:01 +0200
Message-ID: <20050826131901.GY4226@rama.de.gnumonks.org>
References: <20050826111832.GT4226@rama.de.gnumonks.org>
	<430F007B.20605@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aJDJANv8BPX70wwH"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <430F007B.20605@trash.net>
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


--aJDJANv8BPX70wwH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 26, 2005 at 01:43:55PM +0200, Patrick McHardy wrote:

> Why not, people can just as easy shoot themselves using bridging or
> tc actions. But I'm not sure about enabling only parts of functionality
> without CONFIG_EXPERIMENTAL, why not simply depend entirely on it?

because decrementing the TTL is considered safe, routers do it all the day =
;)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--aJDJANv8BPX70wwH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDDxbEXaXGVTD0i/8RAqyTAJ4wkph9DSrf9ejjG34G/ZFPGamj+ACeLXGu
SAP+KToyAr5B1nf1ItkNluc=
=wroK
-----END PGP SIGNATURE-----

--aJDJANv8BPX70wwH--

From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [netfilter-core] netfilter violates RFC 1812
Date: Mon, 9 Dec 2002 19:43:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021209184312.GO2223@sunbeam.de.gnumonks.org>
References: <20021204130651.GF9736@naboo.club.berlin.ccc.de> <3DEF0176.3020208@rz.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8CNmCRe8Sh4keFKJ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Wolfgang Kueter <wolfgang@shconnect.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jens Hektor <hektor@rz.rwth-aachen.de>
Content-Disposition: inline
In-Reply-To: <3DEF0176.3020208@rz.rwth-aachen.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8CNmCRe8Sh4keFKJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 05, 2002 at 08:34:14AM +0100, Jens Hektor wrote:
> The situation as I see it could be described as such:
>  [...]
> I think it would be a good idea to say that there is a new version
> of kernel as well as iptables which fixes it and can be used only
> together. Anyone who wants something else should stick to older versions
> or patch his kernel/iptables by his own.

Agreed. I will test one of the proposed patches and put it in the queue
of pending netfilter patches for 2.4.21-preX

> Jens Hektor, RWTH Aachen, Rechenzentrum, Seffenter Weg 23, 52074 Aachen

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--8CNmCRe8Sh4keFKJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE99ORAXaXGVTD0i/8RAnx0AJ9paVWI3TsRZSYrvYqM6zLrGNh0QwCfeCyV
CyWdxv5kRxCUkqZZge5y2xE=
=1TNV
-----END PGP SIGNATURE-----

--8CNmCRe8Sh4keFKJ--

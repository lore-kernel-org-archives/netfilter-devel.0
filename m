From: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
Subject: Re: [PATCH 2.4/2.5]
Date: 30 Jun 2003 08:42:10 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056976930.5553.26.camel@pc>
References: <1056913883.1068.70.camel@exile> <1056915465.9614.59.camel@pc>
	 <1056918054.1068.96.camel@exile> <1056918710.23456.80.camel@pc>
	 <20030630120556.GI2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1bKzsejE9ccZvcXoSzlG"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030630120556.GI2645@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-1bKzsejE9ccZvcXoSzlG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2003-06-30 at 08:05, Harald Welte wrote:
>=20
> I don't really see the need for such a patch unless the port numbers
> used by amanda can be tuned somehow (by an amanda server/client config
> file).   I'm not that familiar with the amanda suite, could somebody
> please investicate this?

The port numbers can certainly be tuned.  In the case of the client
(which having configurable ports as per Filip's patch addresses) the
client is simply started from the [x]inetd super-server, so it can be on
any port the admin wishes.

b.

--=20
Brian J. Murrell <netfilter@interlinx.bc.ca>

--=-1bKzsejE9ccZvcXoSzlG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/ADAil3EQlGLyuXARAuShAJ9tw1NBSFn8HXMa7TMNiJcMTRftagCfaWJg
Nj0lPcM2nuNM5hxbsajFOXs=
=3+nf
-----END PGP SIGNATURE-----

--=-1bKzsejE9ccZvcXoSzlG--

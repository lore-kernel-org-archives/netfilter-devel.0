From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH NF_CONNTRACK 1/2] cleanup of unregistering ftp helper in
	init()
Date: Fri, 26 Aug 2005 13:02:02 +0200
Message-ID: <20050826110202.GQ4226@rama.de.gnumonks.org>
References: <200508161011.j7GABcK2028434@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="51uid+Ur/3ko9cBW"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200508161011.j7GABcK2028434@toshiba.co.jp>
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


--51uid+Ur/3ko9cBW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 16, 2005 at 07:11:37PM +0900, Yasuyuki KOZAKAI wrote:
> Hi, Harald,
>=20
> This patch is small cleanup to unregister ftp helper when error on
> initialization.

Thanks, I've applied it to my tree.  You forgot to remove the "__exit"
qualifier from the "fini()" function, it is now called from the __init
marked init() function.  I've fixed this up, too.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--51uid+Ur/3ko9cBW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDDvaqXaXGVTD0i/8RAqkeAJ9OWNxtmE5cMWR1eKoRRLs8VaxJvwCfc1ow
m32Zyaxe/CiCcaNMbuWb23c=
=eIRI
-----END PGP SIGNATURE-----

--51uid+Ur/3ko9cBW--

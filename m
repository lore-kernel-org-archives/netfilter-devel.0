From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] MARK target doesn't allow to set highest bit
Date: Sat, 2 Nov 2002 15:38:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021102153816.O8635@sunbeam.de.gnumonks.org>
References: <veu1j2de35.fsf@inigo.ingate.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dcv4+U1QHVytmYUX"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
Content-Disposition: inline
In-Reply-To: <veu1j2de35.fsf@inigo.ingate.se>; from marcus@ingate.com on Thu, Oct 31, 2002 at 12:47:58PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dcv4+U1QHVytmYUX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2002 at 12:47:58PM +0100, Marcus Sundberg wrote:
> Hi,
>=20
> libipt_MARK.c has been broken since iptables 1.2.7.
> This patch makes it work properly again:

Broken in which way?  Am I right you are talking about signed/unsigned numb=
ers
and not being able to specify the upper half of the mark range?

> //Marcus

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--dcv4+U1QHVytmYUX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9w+NXXaXGVTD0i/8RApw0AJ9eZzZ+Hla76kq6ZDXJsHxOBks8WQCgoUh/
HQAeaMtnC/wRp5xm0aY5xXI=
=JMxt
-----END PGP SIGNATURE-----

--dcv4+U1QHVytmYUX--

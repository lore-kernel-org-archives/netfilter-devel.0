From: Harald Welte <laforge@netfilter.org>
Subject: Re: ipt_connlimit.c module
Date: Mon, 14 Jul 2003 10:08:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030714080811.GG6538@naboo>
References: <4D618F6493CE064A844A5D496733D667031A4E@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMnpOGXCMazMAbfp"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Bene <martin.bene@icomedias.com>
Content-Disposition: inline
In-Reply-To: <4D618F6493CE064A844A5D496733D667031A4E@freedom.icomedias.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eMnpOGXCMazMAbfp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2003 at 02:33:04PM +0200, Martin Bene wrote:
> I've just tried to compile ipt_connlimit.c from current patch-o-matic
> snapshot (20030710) on 2.4.21 kernel;=20

thanks, I will add a patch to ip_conntrack_core.h to patch-o-matic.
It shouldn't be using NF_ACCEPT without including netfilter.h.


> Bye, Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eMnpOGXCMazMAbfp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/EmTqXaXGVTD0i/8RAhEKAJ9EtgdOszKKvV3S840YFIkkK29SEACfdkN0
2pDnZe5kuqMlaOm4C4abtPI=
=Ejmd
-----END PGP SIGNATURE-----

--eMnpOGXCMazMAbfp--

From: Harald Welte <laforge@netfilter.org>
Subject: Re: Need help on 2.6.11 and pom-ng HEAD
Date: Fri, 1 Apr 2005 09:06:25 +0200
Message-ID: <20050401070625.GU19835@sunbeam.de.gnumonks.org>
References: <20050331173635.01D4.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AX2clmtSw6ieHBMM"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
Content-Disposition: inline
In-Reply-To: <20050331173635.01D4.LARK@linux.net.cn>
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


--AX2clmtSw6ieHBMM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 31, 2005 at 05:50:24PM +0800, Wang Jian wrote:
> Beside ordinary conntrack helper, the following things are needed:
>=20
>  directx8-conntrack-nat
>  h323-conntrack-nat
>  ipp2p
>  mms-conntrack-nat
>  quake3-conntrack-nat
>  rtsp-conntrack
>  nfnetlink-ctnetlink-0.13

you will have a really long job.  Most of them are neither fully ported
nor tested.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--AX2clmtSw6ieHBMM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCTPLxXaXGVTD0i/8RAliLAKCYgQtY9VhhnBMS+ZvNMDMG/0r3sQCfS0WD
VM48S0G0PpMd8IOjWKPFuvw=
=ipOK
-----END PGP SIGNATURE-----

--AX2clmtSw6ieHBMM--

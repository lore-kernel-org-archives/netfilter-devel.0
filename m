From: Harald Welte <laforge@netfilter.org>
Subject: Re: How to take over TCP connection from userspace process?
Date: Tue, 21 Oct 2003 15:47:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031021134729.GB12049@sunbeam.de.gnumonks.org>
References: <006701c397a5$9c13fee0$d32f110a@yrhd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: yangrunhua <yangrunhua@njupt.edu.cn>
Content-Disposition: inline
In-Reply-To: <006701c397a5$9c13fee0$d32f110a@yrhd>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2003 at 03:33:22PM +0800, yangrunhua wrote:
> Hi all,
> 	With the help of netfilter/iptables, is there any way to high-speed forw=
arding between 2 already-connected TCP connections in the kernel?

I don't see how this could be related to netfilter/iptables at all.
The normal sendfile() systemcall may be helpful to you.

> 	Thanks,
> 				Runhua Yang

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/lTjxXaXGVTD0i/8RAgZhAJ0f/5pHzcDKuS79aQM6iHecWrA/DACff3Fr
8E9mWW2fM1wDzCdIrd1MlvY=
=VFP1
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--

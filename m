From: Harald Welte <laforge@netfilter.org>
Subject: Re: about conntrack_ftp and FTP_NAT
Date: Wed, 26 Mar 2003 15:27:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326142738.GO21953@sunbeam.de.gnumonks.org>
References: <004201c2e93b$1e2d6930$e47378ca@Veloo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iRjOs3ViPWHdlw/I"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Shuanghu Luo <shluo@yc.shu.edu.cn>
Content-Disposition: inline
In-Reply-To: <004201c2e93b$1e2d6930$e47378ca@Veloo>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--iRjOs3ViPWHdlw/I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2003 at 04:32:28PM +0800, Shuanghu Luo wrote:
> hi,everyone!
> My server's console often displays the infomation like  the following:
> conntrack_ftp:   Partial 227 1336485367+37
> FTP_NAT:         Partial packet   1632396361/17 in 1632396378/1632396400
> what's the meaning?=20

It means that the ftp conntrack helper has received a partial PORT/PASV
command in a packet (i.e. the PORT/PASV command is split over multiple
packets).  This is not supported.

> Thank you!
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--iRjOs3ViPWHdlw/I
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gbjaXaXGVTD0i/8RAqOdAKCykJjpDJCIj68k2D/3PiyHe0ieGwCfeQnd
KCHP9s7yg4JtT/TL6QyAJVk=
=cB9r
-----END PGP SIGNATURE-----

--iRjOs3ViPWHdlw/I--

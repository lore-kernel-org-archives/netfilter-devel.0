From: Harald Welte <laforge@netfilter.org>
Subject: Re: buffer overflow in ip_ct_{ftp,tftp,irc}
Date: Tue, 20 Sep 2005 16:15:20 +0200
Message-ID: <20050920141520.GG31236@sunbeam.de.gnumonks.org>
References: <432213E5.4000200@trash.net>
	<200509200711.j8K7Bw3x002184@toshiba.co.jp>
	<20050920093510.GB31236@sunbeam.de.gnumonks.org>
	<200509201248.j8KCmNi9009046@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tVmo9FyGdCe4F4YN"
Cc: netfilter-devel@lists.netfilter.org, sbellabes@mandriva.com,
	kaber@trash.net, pablo@netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200509201248.j8KCmNi9009046@toshiba.co.jp>
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


--tVmo9FyGdCe4F4YN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2005 at 09:48:21PM +0900, Yasuyuki KOZAKAI wrote:

> Really ? At least, the current moduleparam.h in David's git tree includes
> declarations for param_*_ushort(). And I succeeded to compile and use ftp
> module with the attached patch.

ok "ushort" will work, but not "u_int16_t".  I'll prepare a patch for
all helpers.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tVmo9FyGdCe4F4YN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDMBl4XaXGVTD0i/8RAl5yAJ9FCoroEv7SeOB7IYYiLbRePpJz2gCcD4BD
Weze/5i++1QufbOZt3eY8UA=
=zTHC
-----END PGP SIGNATURE-----

--tVmo9FyGdCe4F4YN--

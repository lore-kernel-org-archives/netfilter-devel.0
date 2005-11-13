From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/4] fix leak of fragment queue at unloading
	nf_conntrack_ipv6
Date: Sun, 13 Nov 2005 22:51:03 +0100
Message-ID: <20051113215103.GU17476@sunbeam.de.gnumonks.org>
References: <200511131238.jADCcbHR017662@toshiba.co.jp>
	<20051113125627.GM17476@sunbeam.de.gnumonks.org>
	<20051113130334.GN17476@sunbeam.de.gnumonks.org>
	<200511131515.jADFF49r001590@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xku3GkZTJumTa1rO"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200511131515.jADFF49r001590@toshiba.co.jp>
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


--xku3GkZTJumTa1rO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2005 at 12:15:04AM +0900, Yasuyuki KOZAKAI wrote:
> I totally agree. I attached new one.

applied, thanks.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xku3GkZTJumTa1rO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDd7VHXaXGVTD0i/8RAjIeAJ9rGlIW54Bzjw+mWwCIsK6CXmTNyQCfdO8F
EQRiU6q4S6dAmOvjlp2TV10=
=MCme
-----END PGP SIGNATURE-----

--xku3GkZTJumTa1rO--

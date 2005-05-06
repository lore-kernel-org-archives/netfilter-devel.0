From: Harald Welte <laforge@netfilter.org>
Subject: Re: changing packet length?
Date: Fri, 6 May 2005 13:14:10 +0200
Message-ID: <20050506111410.GG30482@sunbeam.de.gnumonks.org>
References: <20050503213406.GE13894@tigris.renesys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNY+9Zst+/98ADCY"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: BJ Premore <bj-netfilter@renesys.com>
Content-Disposition: inline
In-Reply-To: <20050503213406.GE13894@tigris.renesys.com>
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


--PNY+9Zst+/98ADCY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 03, 2005 at 05:34:06PM -0400, BJ Premore wrote:
> So my hopefully simple question is, can packet sizes be
> changed and then reinjected using ipq_set_verdict? =20

Of course. you just reinject the packet with a different data_len.


--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PNY+9Zst+/98ADCY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCe1GCXaXGVTD0i/8RAhpOAJ49/5gw4BJtKMD+D+Qn3Rb8hW0N5QCfbFgk
7zivVrCr1WurlozWby1rhio=
=22Fz
-----END PGP SIGNATURE-----

--PNY+9Zst+/98ADCY--

From: Harald Welte <laforge@netfilter.org>
Subject: Re: Target ipt_XOR
Date: Sat, 31 May 2003 19:06:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030531170640.GV29312@sunbeam.de.gnumonks.org>
References: <3CF3C89D.1080103@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="19HmC3QOnaNVzKTI"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tim Vandermeersch <tim.vandermeersch@pandora.be>
Content-Disposition: inline
In-Reply-To: <3CF3C89D.1080103@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--19HmC3QOnaNVzKTI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2002 at 08:12:45PM +0200, Tim Vandermeersch wrote:
> This patch adds a new target "XOR" wich can encrypt TCP and UDP traffic=
=20
> using a simple xor encryption. See netfilter-extensions.sgml.diff for usa=
ge.

thanks, patch applied to CVS.

> Regards,
> Tim
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--19HmC3QOnaNVzKTI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+2OEgXaXGVTD0i/8RApcmAJ9RLGUK45orEw4JCCK0bomh/lp6iwCeOw3E
maxr3jX3xDh447Fotq6pk64=
=hNxd
-----END PGP SIGNATURE-----

--19HmC3QOnaNVzKTI--

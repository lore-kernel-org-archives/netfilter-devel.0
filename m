From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix owner-socketlookup patch
Date: Thu, 17 Apr 2003 18:22:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030417162232.GE30453@sunbeam.de.gnumonks.org>
References: <3E9EB90A.4050701@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eNMatiwYGLtwo1cJ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E9EB90A.4050701@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eNMatiwYGLtwo1cJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2003 at 04:24:10PM +0200, Patrick McHardy wrote:
> Hi Harald,
> this patch fixes build of the ipt_owner.c as module with the=20
> owner-socketlookup patch.
> When neither of CONFIG_IPV6_MODULE/CONFIG_KHTTPD/CONFIG_KHTTPD_MODULE
> are defined tcp_timewait_cachep needs to be exported for tcp_tw_put().
>=20
> Please apply to CVS.

applied, thanks.

> Best regards,
> Patrick
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eNMatiwYGLtwo1cJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+ntTIXaXGVTD0i/8RArt8AJ4kysqoMXwiet8UR1jlWon6RIPstQCeLpBX
Huwh+bn8fXtwduBlHyJE1fI=
=5dSn
-----END PGP SIGNATURE-----

--eNMatiwYGLtwo1cJ--

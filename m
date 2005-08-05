From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Fix bad size of ctnl_exp_cb array
Date: Fri, 5 Aug 2005 14:24:33 +0200
Message-ID: <20050805122433.GD4245@rama.de.gnumonks.org>
References: <42F2B481.8020202@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42F2B481.8020202@eurodev.net>
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


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 05, 2005 at 02:36:17AM +0200, Pablo Neira wrote:
> This fixes the size of the ctnl_exp_cb array that is
> IPCTNL_MSG_EXP_MAX instead of IPCTNL_MSG_MAX. Simple typo.

thanks, applied.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC81qAXaXGVTD0i/8RAo8aAJ4xBjt1RvoRu2B8ISuE72dvAhKsRwCaAiY5
oSUyG9WdCf0FuLNly1nDQNk=
=S7wv
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--

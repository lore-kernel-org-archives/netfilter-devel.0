From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] ip_ct_refresh_optimization.patch
Date: 12 Sep 2002 15:05:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1031835954.28101.82.camel@tux>
References: <vebs73bnx1.fsf@inigo.ingate.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-yyV9HSaHk2EPMUEVCmQB"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <vebs73bnx1.fsf@inigo.ingate.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-yyV9HSaHk2EPMUEVCmQB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2002-09-12 at 10:41, Marcus Sundberg wrote:
> Hi,
>=20
> The ip_ct_refresh_optimization.patch in p-o-m is completely broken,
> as it doesn't handle when the timeout is decreased. This results
> in TCP-connections in CLOSE and TIME_WAIT states still having the
> 5 day timeout they had when they were in ESTABLISHED state.
>=20
> This patch always updates the timeout if the difference is >=3D HZ.
>=20
> diff -u -r1.1 ip_ct_refresh_optimization.patch
> --- patch-o-matic/optimizations/ip_ct_refresh_optimization.patch	11 Jun 2=
002 08:02:57 -0000	1.1
> +++ patch-o-matic/optimizations/ip_ct_refresh_optimization.patch	12 Sep 2=
002 08:11:52 -0000
> @@ -69,7 +69,7 @@
>  +		/* Don't update timer for each packet, only if it's been >HZ
>  +		 * ticks since last update.
>  +		 * Need del_timer for race avoidance (may already be dying). */
> -+		if (time_after(jiffies, ct->timeout.expires - extra_jiffies + HZ) && =
del_timer(&ct->timeout)) {
> ++		if (abs(jiffies + extra_jiffies - ct->timeout.expires) >=3D HZ && del=
_timer(&ct->timeout)) {
>   			ct->timeout.expires =3D jiffies + extra_jiffies;
>   			add_timer(&ct->timeout);
>   		}

Yes I know it's broken, I do have a newer version but I havn't committed
it to cvs. I think Patrick Shaaf's solution is a better one and we
should probably go with something like that.

you can find a few optimisation and other patches over at
http://www.netfilter.org/~gandalf/

timer-update2-inc.diff is almost like your patch. I'm using it right now
and it seems to be working fine.

--=20
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-yyV9HSaHk2EPMUEVCmQB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQA9gJEyWm2vlfa207ERAqWnAJwIi8EqZzT1Fcvwtqvcf/atu3B0mQCgnzXd
OcPMCH7/eClRsNwyDW7TksA=
=VHTC
-----END PGP SIGNATURE-----

--=-yyV9HSaHk2EPMUEVCmQB--

From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH]: fix all iptables problems with '!' (hopefully)
Date: Tue, 7 Jan 2003 21:16:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030107201643.GY9467@sunbeam.de.gnumonks.org>
References: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr> <20030106020219.GC423@comet.rv-int> <3E193B0E.9030602@trash.net> <36373.195.97.5.193.1041856153.squirrel@fs.tsaousis.gr> <3E19A1D8.7080605@trash.net> <20030107171526.GL1353@sunbeam.de.gnumonks.org> <3E1B222B.5030009@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B0ZU/rjo5v6h4DpE"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E1B222B.5030009@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--B0ZU/rjo5v6h4DpE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07, 2003 at 07:53:31PM +0100, Patrick McHardy wrote:

> Thats the reason why i was unsure weather to send the patch or not ;)

I see.=20

> What about if i convert all matches to only show "!" in boolean context=
=20
> in the helptexts and change check_inverse and what else might be
> neccessary to enforce this ?

I think this is a wise idea.

> What about backward-compatibility ?

This is usually not my idea of being user-friendly... but considering
how much trouble we've had with this over the last couple of months, I'm
willing to sacrifice a bit of backwards compatibility.

To everyone: Please feel free to protest.

> Regards,
> Patrick

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--B0ZU/rjo5v6h4DpE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GzWrXaXGVTD0i/8RAiE0AJ9p67FSJvCiU00K0+DhYXAlaT+4vQCeLe1e
kA5pu8gGmA8GoSMV9GKr82Q=
=U+xy
-----END PGP SIGNATURE-----

--B0ZU/rjo5v6h4DpE--

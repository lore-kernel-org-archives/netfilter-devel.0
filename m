From: Harald Welte <laforge@gnumonks.org>
Subject: Re: question about TTL patch status?
Date: Sat, 13 Dec 2003 01:51:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031213005114.GE14920@sunbeam.de.gnumonks.org>
References: <20031212191235.GL12890@outflux.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kees Cook <kees@outflux.net>
Content-Disposition: inline
In-Reply-To: <20031212191235.GL12890@outflux.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2003 at 11:12:35AM -0800, Kees Cook wrote:
> Is there a reason that your TTL patch is not part of the core netfilter=
=20
> code?  I'd really like to see it as part of the regular kernel=20
> distributions.  :)

Yes, this has been documented in the mailinglist archives.

Modifying the TTL value is a potentially very dangerous tool, which only
has a very limited set of valid uses.  For that reason, we don't want to
put it into the mainline kernel.

> Thanks for a great patch!

You're welcome.

> Kees Cook                                            @outflux.net

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2mKCXaXGVTD0i/8RAj3+AJ4wcAI+mFFSFs1pPewq25Kmar3gVwCfQy1V
mXDzGdtJKJI2xW4GnXC/9kg=
=cmeY
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--

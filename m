From: Harald Welte <laforge@netfilter.org>
Subject: Re: [FUN] New target: passive OS fingerprinting.
Date: Mon, 24 Nov 2003 11:18:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031124101806.GI4888@obroa-skai.de.gnumonks.org>
References: <20031124020436.334cf2c6.johnpol@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mFHiwr52TKrxpkjc"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Content-Disposition: inline
In-Reply-To: <20031124020436.334cf2c6.johnpol@2ka.mipt.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--mFHiwr52TKrxpkjc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2003 at 02:04:36AM +0300, Evgeniy Polyakov wrote:
> New target which trying to determine(by passive fingerprinting)=20
> remote OS by set of parameters from initial SYN packet which was sent to
> us.

why an additional target?  I don't think it's a good idea to copy+paste
all that code. =20

You could maybe add a '--log' option to the match or whatever... but I
really don't think it's a good idea to have the same code replicated as
match and as target.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mFHiwr52TKrxpkjc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/wdrdXaXGVTD0i/8RAlzKAJ4wy3CqM5QPsqyaoQGjXHjz4gbtngCgjdER
pTnRb4U9rf3P28j18eLhaS4=
=B8kX
-----END PGP SIGNATURE-----

--mFHiwr52TKrxpkjc--

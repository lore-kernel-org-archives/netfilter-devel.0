From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix save() output in libipt_string.c
Date: Mon, 30 Jan 2006 09:54:23 +0100
Message-ID: <20060130085423.GT4603@sunbeam.de.gnumonks.org>
References: <20060129210829.GA10213@minastirith.cipherdyne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tl2A+1bu5ZCdBkzL"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michael Rash <mbr@cipherdyne.org>
Content-Disposition: inline
In-Reply-To: <20060129210829.GA10213@minastirith.cipherdyne.org>
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


--Tl2A+1bu5ZCdBkzL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 29, 2006 at 04:08:29PM -0500, Michael Rash wrote:
> This patch fixes bug #436 where save() in libipt_string.c outputs
> "--to-offset" and "--from-offset" instead of "--to" and "--from"
> respectively (breaks iptables-restore whenever string matching rules are
> included).  Tested against iptables-1.3.4 and kernel 2.6.15.1.

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

--Tl2A+1bu5ZCdBkzL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD3dQ/XaXGVTD0i/8RApp8AKCwdGB2+K7mVwr1hwTejzUqS2zafgCfTPIZ
sstyMpQfJU88/8PdlI0rIWs=
=FJ6E
-----END PGP SIGNATURE-----

--Tl2A+1bu5ZCdBkzL--

From: Harald Welte <laforge@netfilter.org>
Subject: Re: Cannot delete hashlimit match entries
Date: Mon, 7 Feb 2005 19:41:28 +0100
Message-ID: <20050207184128.GL10011@obroa-skai.de.gnumonks.org>
References: <20050204232444.GB30789@linuxace.com>
	<42041440.1050405@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TC23+W66xmFESAX"
Cc: netfilter-devel@lists.netfilter.org
To: sjean@cookinglinux.org
Content-Disposition: inline
In-Reply-To: <42041440.1050405@cookinglinux.org>
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


--6TC23+W66xmFESAX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 04, 2005 at 07:33:04PM -0500, Samuel Jean wrote:
> Yes. The only way am aware of to fix it is sizing the matching part with=
=20
> offsetof().
> Fortunately, in this case, all modified member are at end so we can use=
=20
> this hack without
> breaking any compatibility.

Thanks!

Sending        extensions/libipt_hashlimit.c
Transmitting file data .
Committed revision 3654.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6TC23+W66xmFESAX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCB7ZYXaXGVTD0i/8RAnzGAJ9pqlh/ksiHrawPDG1bTD2LlpAv6QCfRjym
gzCtU9A7CgcWJN71HFSSIIw=
=4DoM
-----END PGP SIGNATURE-----

--6TC23+W66xmFESAX--

From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP connection tracking and Poptop on same box
Date: Mon, 22 Sep 2003 00:48:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921224843.GB30961@sunbeam.de.gnumonks.org>
References: <20030905115534.GD665@obroa-skai.de.gnumonks.org> <3F5D91DC.3030706@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <3F5D91DC.3030706@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again!

After some long debugging about gre keymap entries that hadn't been
automatically freed (and thus free()d at kernel unload time) I found a
bug:

On Tue, Sep 09, 2003 at 06:39:56PM +1000, Philip Craig wrote:

>  			/* remove only if occurred at same sequence number */
>  			if (other_exp !=3D exp && other_exp->seq =3D=3D exp->seq) {
>  				DEBUGP("unexpecting other direction\n");
> +				ip_ct_gre_keymap_destroy(exp);

This has to be other_exp instead of exp.  Now all four keymap entries
per connection are destroyed as expected.

I'll continue my tests tomorrow.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/birLXaXGVTD0i/8RAoaNAKCyxscgwCoAXoqcvLtaxbmm8kzI5wCgp73a
MM/SMGneoyx0lSb2Gi/Rgwo=
=qXiY
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--

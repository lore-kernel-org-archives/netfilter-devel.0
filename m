From: Harald Welte <laforge@netfilter.org>
Subject: Re: libiptc memory leak - PATCH
Date: Wed, 30 Apr 2003 17:47:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430154721.GD685@sunbeam.de.gnumonks.org>
References: <3EA46FDE.6040806@i.cz> <20030427125345.GD990@sunbeam.de.gnumonks.org> <3EACD4D1.90704@i.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?B?VG9t4T8=?= Lejdar <tomas.lejdar@i.cz>
Content-Disposition: inline
In-Reply-To: <3EACD4D1.90704@i.cz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2003 at 09:14:25AM +0200, Tom=E1? Lejdar wrote:
> Hi,
> I thing there is no problem, the memory is freed only when the
> function next_chain returns NULL and run through the chains is on the end.
> In the next call of first_chain() is memory alocated again in=20
> populate_cache().

no, it's fine.  It was a misunderstanding. I'll apply your patch now.
Sorry for the fuzz.

> T.v.L

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+r/AJXaXGVTD0i/8RAt8UAKCT9HkhaX8v2osSLrI4hO3skhs3kwCfewEu
DqqpyKXhbbpdxj1WgReEw4g=
=Bd8H
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--

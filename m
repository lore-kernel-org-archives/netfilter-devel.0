From: Harald Welte <laforge@netfilter.org>
Subject: Re: libiptc memory leak - PATCH
Date: Sun, 27 Apr 2003 14:53:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427125345.GD990@sunbeam.de.gnumonks.org>
References: <3EA46FDE.6040806@i.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nG7dHWd/DOCuxGWF"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?B?VG9t4T8=?= Lejdar <tomas.lejdar@i.cz>
Content-Disposition: inline
In-Reply-To: <3EA46FDE.6040806@i.cz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nG7dHWd/DOCuxGWF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2003 at 12:25:34AM +0200, Tom=E1? Lejdar wrote:
>         (*handle)->cache_chain_iteration++;
>=20
>         if ((*handle)->cache_chain_iteration - (*handle)->cache_chain_hea=
ds
> !           =3D=3D (*handle)->cache_num_chains){
> !                 free((*handle)->cache_chain_heads);
>                 return NULL;
> +       }
>=20
>         return (*handle)->cache_chain_iteration->name;
>   }

I cannot accept this patch It would basically mean that something like:

first_chain()
next_chain()
first_chain()

would no longer work.

we need an explicit free_handle that cleans up all allocated regions
instead.  Patches are welcome.

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

--nG7dHWd/DOCuxGWF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9LZXaXGVTD0i/8RAjlQAJ9hVdOQNl2qh3TBrTyNKa6Y/+xYxwCfV99k
Jf501YXg+nCFoCHIAMpwjpE=
=Uz4S
-----END PGP SIGNATURE-----

--nG7dHWd/DOCuxGWF--

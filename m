From: Harald Welte <laforge@gnumonks.org>
Subject: Re: For netfilter ipt_ops, init() and nf_register_hook()
Date: Wed, 30 Oct 2002 09:42:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030094213.M8635@sunbeam.de.gnumonks.org>
References: <F225AtxXuGSkXlVg2R20000850c@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nbmc0BhO2pdgImje"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Shen Qiyu" <shenqiyu@hotmail.com>
Content-Disposition: inline
In-Reply-To: <F225AtxXuGSkXlVg2R20000850c@hotmail.com>; from shenqiyu@hotmail.com on Wed, Oct 23, 2002 at 03:15:44PM +0800
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nbmc0BhO2pdgImje
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2002 at 03:15:44PM +0800, Shen Qiyu wrote:
>  list_add(&reg->list, i->prev);

> It seems that in list_add(&reg->list, i->prev), only a {NULL, NULL} list=
=20
> head is added, so how it run?

a {NULL, NULL} list head is added to i->prev, an already-existing list head.

> Regards.
> =20
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--nbmc0BhO2pdgImje
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v5tkXaXGVTD0i/8RAho0AJ9g+l7UddWHPN6VRk2adOKCsFVKCACfZGXh
Fvl0OPnAxxtOtEszMmtizTA=
=Ezub
-----END PGP SIGNATURE-----

--nbmc0BhO2pdgImje--

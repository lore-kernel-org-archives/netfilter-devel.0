From: Harald Welte <laforge@gnumonks.org>
Subject: Re: 2 questions about skb->data
Date: Wed, 2 Oct 2002 15:40:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021002154044.D13233@sunbeam.de.gnumonks.org>
References: <F106uCumiiq6KcvflGx00006117@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "hMax Roth" <mroth2002@hotmail.com>
Content-Disposition: inline
In-Reply-To: <F106uCumiiq6KcvflGx00006117@hotmail.com>; from mroth2002@hotmail.com on Wed, Sep 25, 2002 at 06:49:02PM +0000
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2002 at 06:49:02PM +0000, hMax Roth wrote:
>=20
>=20
> Hello,
>    Two quick questions:
>       1) Judging by the code it looks like all the skb's are
>       linearized prior to entering the hooks. Is this right?

yes, this is true as of now.  This will change in the future.

>       2) Am I free to manipulate the data in the skb? Judging
>       from various web resources, it looks as if the data can
>       either be private or shared.  how do I tell if I can
>       overwrite data in the skb->data pointer safely? Do I need
>       to make my own copy of the skb first?

you can use constructs like if (skb_is_shared(skb))

Don't remember if the name really was 'skb_is_shared' but there are
macros/functions for this kind of stuff.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long =
as
 I'm the dictator."  --  George W. Bush Dec 18, 2000

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9mvdbXaXGVTD0i/8RAoTeAJ9bNT4mLgv1CIwFeFTFYFuRQQudRQCfSkVC
VK4NNtsNrBVc5fJjaNoZSEI=
=88oW
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--

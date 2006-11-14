From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [CTNETLINK] Rework conntrack fields dumping logic on events
Date: Tue, 14 Nov 2006 21:50:08 +0100
Message-ID: <20061114205008.GA7114@zion.homelinux.com>
References: <4553D3D5.40408@netfilter.org>
	<Pine.LNX.4.64.0611102151300.26087@blackhole.kfki.hu>
	<4557B157.6010205@netfilter.org>
	<Pine.LNX.4.64.0611142055130.1650@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0611142055130.1650@blackhole.kfki.hu>
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


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Jozsef,

On Tue, Nov 14, 2006 at 09:01:32PM +0100, Jozsef Kadlecsik told us:
> diff -urN --exclude-from=3D/usr/src/diff.exclude linux-2.6.20-nat-core/in=
clude/net/netfilter/nf_conntrack_helper.h linux-2.6.20-netlink/include/net/=
netfilter/nf_conntrack_helper.h
> --- linux-2.6.20-nat-core/include/net/netfilter/nf_conntrack_helper.h	200=
6-11-06 14:08:15.000000000 +0100
> +++ linux-2.6.20-netlink/include/net/netfilter/nf_conntrack_helper.h	2006=
-11-14 17:02:40.000000000 +0100
> @@ -23,7 +23,9 @@
>  					 * expected connections */
>  	unsigned int timeout;		/* timeout for expecteds */
> =20
> -	/* Mask of things we will help (compared against server response) */
> +	/* Mask of things we will help (compared against server response):
> +	 * tuple.src.u must be set to zero for dynamic helpers, i.e. which
> +	 * are attached by an expectfn to the conntrack entry */=20
>  	struct nf_conntrack_tuple tuple;
>  	struct nf_conntrack_tuple mask;
>  =09
> diff -urN --exclude-from=3D/usr/src/diff.exclude linux-2.6.20-nat-core/ne=
t/netfilter/nf_conntrack_helper.c linux-2.6.20-netlink/net/netfilter/nf_con=
ntrack_helper.c
> --- linux-2.6.20-nat-core/net/netfilter/nf_conntrack_helper.c	2006-11-06 =
14:08:15.000000000 +0100
> +++ linux-2.6.20-netlink/net/netfilter/nf_conntrack_helper.c	2006-11-14 1=
6:44:45.000000000 +0100
> @@ -35,8 +35,13 @@
>  	struct nf_conntrack_helper *h;
> =20
>  	list_for_each_entry(h, &helpers, list) {
> -		if (nf_ct_tuple_mask_cmp(tuple, &h->tuple, &h->mask))
> -			return h;
> +		if (nf_ct_tuple_mask_cmp(tuple, &h->tuple, &h->mask)) {
> +			/* Ignore dynamic helpers: we should log it */
> +			if (h->tuple.src.u)
> +				return h;
> +			else
> +				return NULL

missing a ';'??


Kind regards,

Sven

> +		}
>  	}
>  	return NULL;
>  }
> diff -urN --exclude-from=3D/usr/src/diff.exclude linux-2.6.20-nat-core/ne=
t/netfilter/nf_conntrack_helper_h323.c linux-2.6.20-netlink/net/netfilter/n=
f_conntrack_helper_h323.c
> --- linux-2.6.20-nat-core/net/netfilter/nf_conntrack_helper_h323.c	2006-1=
1-06 14:39:04.000000000 +0100
> +++ linux-2.6.20-netlink/net/netfilter/nf_conntrack_helper_h323.c	2006-11=
-13 17:50:48.000000000 +0100
> @@ -1770,6 +1770,7 @@
>  /* Not __exit - called from init() */
>  static void fini(void)
>  {
> +	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
>  	nf_conntrack_helper_unregister(&nf_conntrack_helper_ras);
>  	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931);
>  	kfree(h323_buffer);
> @@ -1785,7 +1786,8 @@
>  	if (!h323_buffer)
>  		return -ENOMEM;
>  	if ((ret =3D nf_conntrack_helper_register(&nf_conntrack_helper_q931)) ||
> -	    (ret =3D nf_conntrack_helper_register(&nf_conntrack_helper_ras))) {
> +	    (ret =3D nf_conntrack_helper_register(&nf_conntrack_helper_ras)) ||
> +	    (ret =3D nf_conntrack_helper_register(&nf_conntrack_helper_h245))) {
>  		fini();
>  		return ret;
>  	}


--=20
Linux zion.homelinux.com 2.6.18-1.2849.fc6xen #1 SMP Fri Nov 10 13:56:52 ES=
T 2006 i686 athlon i386 GNU/Linux
 21:49:08 up 2 days,  1:03,  1 user,  load average: 0.00, 0.03, 0.06

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFWiwAo4FAdB2PneQRAg50AJ9LiGp6lNT9T/7Pm7PbUXoPEMQ2ogCfSQBu
2IStt0pGV95rZfWc8d2FFu8=
=Diln
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--

From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [PATCH 14/18] Netfilter: Conntrack Hash Allocation using
	__get_free_pages
Date: Sat, 8 Jan 2005 18:57:44 +0100
Message-ID: <20050108175744.GA20579@zion.homelinux.com>
References: <1104896182.20582.81.camel@localhost.localdomain>
	<1105133206.1087.46.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1105133206.1087.46.camel@tux.rsn.bth.se>
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


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Martin,

On Fri, Jan 07, 2005 at 10:26:46PM +0100, Martin Josefsson told us:
> +++ linux-2.6.10-bk050106/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-=
07 22:14:44.000000000 +0100
> @@ -1349,7 +1349,7 @@
=2E..
> +	if (ip_conntrack_hash) {
> +		/* Recalculate hashtable size based on order. */
> +		ip_conntrack_htable_size =3D ((1U << order) << PAGE_SHIFT)
> +						/ sizeof(struct list_head);
> +		if (ip_conntrack_max < ip_conntrack_htable_size)
> +			ip_conntrack_max =3D ip_conntrack_htable_size;
> +	} else {=20

shouldn't this be

+		if (ip_conntrack_max > ip_conntrack_htable_size)

because you only want ip_conntrack_max to decrease when htable_size has
become smaller than conntrack_max after the allocation??


Sven

>  		ip_conntrack_vmalloc =3D 1;
>  		printk(KERN_WARNING "ip_conntrack: falling back to vmalloc.\n");
>  		ip_conntrack_hash =3D vmalloc(sizeof(struct list_head)
>  					    * ip_conntrack_htable_size);
> -	}
> -	if (!ip_conntrack_hash) {
> -		printk(KERN_ERR "Unable to create ip_conntrack_hash\n");
> -		goto err_unreg_sockopt;
> +
> +		if (!ip_conntrack_hash) {
> +			printk(KERN_ERR "Unable to create ip_conntrack_hash\n");
> +			goto err_unreg_sockopt;
> +		}
>  	}
> =20
>  	ip_conntrack_cachep =3D kmem_cache_create("ip_conntrack",


--=20
Linux zion 2.6.10-bk7 #0 Fri Jan 7 19:08:39 CET 2005 i686 athlon i386 GNU/L=
inux
 18:52:47 up 23:30,  1 user,  load average: 0.00, 0.02, 0.08

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD4DBQFB4B8Yo4FAdB2PneQRAgBZAJjLkrN73w3/Q4yUWxluA2R3cgR7AJ0cMblx
bX6YeDReDfP1PMEhRLmHGA==
=43Cu
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--

From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] return value of conntrack protocol helper functions
	and a macro for stats
Date: Sat, 21 Aug 2004 00:15:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1093040122.20712.18.camel@localhost.localdomain>
References: <4112377A.8050106@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kfvibPwXI0Q2zLOHNfVf"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4112377A.8050106@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-kfvibPwXI0Q2zLOHNfVf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-08-05 at 15:34, Pablo Neira wrote:
> Hi,

Hi Pablo

I've finally had the opportunity to go through my netfilter-devel
backlog.

> This patch applies to last Harald's patch bombing. It's based on=20
> Martin's idea of removing negative values in conntrack protocol helper=20
> functions. Please see:
>=20
> http://lists.netfilter.org/pipermail/netfilter-devel/2004-June/015769.htm=
l
>=20
> Now functions packet and error return CONNTRACK_CONT to let the packet=20
> continue its travel through the conntrack system. It also add a macro to=20
> increase vars used for stats.

I like this patch, just a few comments below.

> @@ -303,12 +307,13 @@
>  	unsigned int insert_failed;
>  	unsigned int drop;
>  	unsigned int early_drop;
> -	unsigned int icmp_error;
> +	unsigned int error;
>  	unsigned int expect_new;
>  	unsigned int expect_create;
>  	unsigned int expect_delete;
>  };

First I wondered why you changed this.
=20
> +#define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).coun=
t++)

I like the macro, it's a lot cleaner.
=20
> @@ -786,41 +786,42 @@
>  	/* It may be an special packet, error, unclean...
>  	 * inverse of the return code tells to the netfilter
>  	 * core what to do with the packet. */

Remove part of the comment above?

> -	if (proto->error !=3D NULL=20
> -	    && (ret =3D proto->error(*pskb, &ctinfo, hooknum)) <=3D 0) {
> -		__get_cpu_var(ip_conntrack_stat).icmp_error++;
> -		return -ret;
> +	if (proto->error !=3D NULL) {
> +		ret =3D proto->error(*pskb, &ctinfo, hooknum);
> +		if (ret !=3D CONNTRACK_CONT) {
> +			CONNTRACK_STAT_INC(error);
> +			CONNTRACK_STAT_INC(invalid);
> +			return ret;
> +		}
>  	}

Now I see why the name was changed in the struct, it's not correct
anymore (was when I wrote it :)

This patch should be submitted before 2.6.9 is out.

I'll update the ctstat program to reflect this change. There's also some
more interesting events in the now submitted tcp-windowtracking patch
that we could use for statistics.

I've modified the ctstat program to be able to handle additional fields
in /proc/net/ip_conntrack_stat if it would be increased in the future in
order to report more stats.

I'll see if I can get ctstat distributed in the same channel as rtstat,
I thought it was distributed with iproute2 but maybe that's added in the
RH iproute2 package as I didn't see rtstat in the Debian iproute
package.
=20
--=20
/Martin

--=-kfvibPwXI0Q2zLOHNfVf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBJnf5Wm2vlfa207ERAnazAKC1DN+l+TJQv/P5IVTCAo413RsRWQCcCrFR
doc0D0mSDBPAuAP3UrAFF9o=
=ULp6
-----END PGP SIGNATURE-----

--=-kfvibPwXI0Q2zLOHNfVf--

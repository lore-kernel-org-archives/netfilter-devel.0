From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: Adjust the maximum timeout jiffies of set timeout
 extension
Date: Sat, 18 Oct 2014 10:36:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1410181033440.8597@blackhole.kfki.hu>
References: <20141017033544.GA26660@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391812-1244248229-1413621228=:8597"
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:54836 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaJRIgD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Oct 2014 04:36:03 -0400
In-Reply-To: <20141017033544.GA26660@nitrogen.neutroncom.local>
Content-ID: <alpine.DEB.2.10.1410181034010.8597@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391812-1244248229-1413621228=:8597
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.10.1410181034011.8597@blackhole.kfki.hu>

Hi,

On Fri, 17 Oct 2014, Neutron Soutmun wrote:

> Refer to: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D764328
>=20
> Marek Luk=E1cs has reported that the set with huge default timeout,
> 2419200 as an example, is replaced by 4294967 which is non-sense.

There has just been a thread about it on this mailing list. I better=20
create a workaround to remove the limitation at ipset level, to support=20
huge timeout values.

Best regards,
Jozsef

> The msecs_to_jiffies() in kernel/time/time.c has a condition that
>=20
> 500 unsigned long msecs_to_jiffies(const unsigned int m)
> 501 {
> 502         /*
> 503          * Negative value, means infinite timeout:
> 504          */
> 505         if ((int)m < 0)
> 506                 return MAX_JIFFY_OFFSET;
>=20
> Therefore, the maximum timeout jiffies should be less than or equal to
> ((UINT_MAX >> 1)) / MSEC_PER_SEC.
>=20
> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
> ---
>  include/linux/netfilter/ipset/ip_set_timeout.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/lin=
ux/netfilter/ipset/ip_set_timeout.h
> index 83c2f9e..b1798df 100644
> --- a/include/linux/netfilter/ipset/ip_set_timeout.h
> +++ b/include/linux/netfilter/ipset/ip_set_timeout.h
> @@ -23,6 +23,9 @@
>  /* Set is defined with timeout support: timeout value may be 0 */
>  #define IPSET_NO_TIMEOUT=09UINT_MAX
> =20
> +/* Set maximum jiffies offset, msecs_to_jiffies() condition */
> +#define IPSET_MAX_JIFFY_OFFSET  ((UINT_MAX >> 1))
> +
>  #define ip_set_adt_opt_timeout(opt, set)=09\
>  ((opt)->ext.timeout !=3D IPSET_NO_TIMEOUT ? (opt)->ext.timeout : (set)->=
timeout)
> =20
> @@ -32,8 +35,8 @@ ip_set_timeout_uget(struct nlattr *tb)
>  =09unsigned int timeout =3D ip_set_get_h32(tb);
> =20
>  =09/* Normalize to fit into jiffies */
> -=09if (timeout > UINT_MAX/MSEC_PER_SEC)
> -=09=09timeout =3D UINT_MAX/MSEC_PER_SEC;
> +=09if (msecs_to_jiffies(timeout * MSEC_PER_SEC) =3D=3D MAX_JIFFY_OFFSET)
> +=09=09timeout =3D IPSET_MAX_JIFFY_OFFSET / MSEC_PER_SEC;
> =20
>  =09/* Userspace supplied TIMEOUT parameter: adjust crazy size */
>  =09return timeout =3D=3D IPSET_NO_TIMEOUT ? IPSET_NO_TIMEOUT - 1 : timeo=
ut;
> --=20
> 2.1.1
>=20
>=20

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
--110391812-1244248229-1413621228=:8597--

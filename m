From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] netfilter: fix IPv6 NTP checksum calculation
Date: Sun, 27 Jan 2013 01:29:09 +0900
Message-ID: <51040455.9090003@linux-ipv6.org>
References: <06023CFA-4D28-43B3-8C7F-B8223F3390DD@dilly.me> <20130124224924.GH8541@breakpoint.cc> <AD70451A-D1CE-4B5A-AB9B-B30FDCD0FB7F@dilly.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Jean-Michel DILLY <jm@dilly.me>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:54702 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751338Ab3AZQ3L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jan 2013 11:29:11 -0500
In-Reply-To: <AD70451A-D1CE-4B5A-AB9B-B30FDCD0FB7F@dilly.me>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jean-Michel DILLY wrote:
> Hi,
>=20
> Here is the signed-off patch.
>=20
> Signed-off-by: Jean-Michel DILLY <jm@dilly.me>
> ---
> diff --git a/ip6t_NPT.c b/linux-3.8-rc4/net/ipv6/netfilter/ip6t_NPT.c
> index 787748b..29ef720 100644
> --- a/ip6t_NPT.c
> +++ b/linux-3.8-rc4/net/ipv6/netfilter/ip6t_NPT.c
> @@ -14,24 +14,44 @@
> #include <linux/netfilter_ipv6/ip6t_NPT.h>
> #include <linux/netfilter/x_tables.h>
>=20
> +static __sum16 csum16_add(__sum16 a, __sum16 b)
> +{
> +       __u16 result;
> +
> +       result =3D (__force __u16) a + (__force __u16) b;
> +       result +=3D result < (__force __u16)b;=20
> +              =20
> +
> +       return (__force __sum16) result;
> +}
> +
> +static __sum16 csum16_complement(__sum16 a)
> +{
> +       return (__force __sum16)(0xffff - (__force u16)a);
> +}
> +
> +static __sum16 csum16_sub(__sum16 a, __sum16 b)
> +{
> +       return csum16_add(a, csum16_complement(b));
> +}
>=20
> static int ip6t_npt_checkentry(const struct xt_tgchk_param *par)
> {
>        struct ip6t_npt_tginfo *npt =3D par->targinfo;
> -       __wsum src_sum =3D 0, dst_sum =3D 0;
> +       __sum16 src_sum =3D 0, dst_sum =3D 0;
>        unsigned int i;
>=20
>        if (npt->src_pfx_len > 64 || npt->dst_pfx_len > 64)
>                return -EINVAL;
>=20
>        for (i =3D 0; i < ARRAY_SIZE(npt->src_pfx.in6.s6_addr16); i++)=
 {
> -               src_sum =3D csum_add(src_sum,
> -                       (__force __wsum)npt->src_pfx.in6.s6_addr16[i]=
);
> -               dst_sum =3D csum_add(dst_sum,
> -                       (__force __wsum)npt->dst_pfx.in6.s6_addr16[i]=
);
> +               src_sum =3D csum16_add(src_sum,=20
> +                                       (__force __sum16)npt->src_pfx=
=2Ein6.s6_addr16[i]);
> +               dst_sum =3D csum16_add(dst_sum,=20
> +                                       (__force __sum16)npt->dst_pfx=
=2Ein6.s6_addr16[i]);
>        }
>=20
> -       npt->adjustment =3D (__force __sum16) csum_sub(src_sum, dst_s=
um);
> +       npt->adjustment =3D csum16_sub(src_sum, dst_sum);
>        return 0;
> }
>=20
> @@ -67,8 +87,8 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_=
tginfo *npt,
>                        return false;
>        }
>=20
> -       sum =3D (__force __sum16) csum_add((__force __wsum)addr->s6_a=
ddr16[idx],
> -                        npt->adjustment);
> +       sum =3D csum16_add((__force __sum16)addr->s6_addr16[idx],
> +                               npt->adjustment);
>        if (sum =3D=3D CSUM_MANGLED_0)
>                sum =3D 0;
>        *(__force __sum16 *)&addr->s6_addr16[idx] =3D sum;
>=20
> Le 24 janv. 2013 =C3=A0 23:49, Florian Westphal a =C3=A9crit :
>=20
>> Jean-Michel DILLY <jm@dilly.me> wrote:
>>> Hi all,
>>> This patch doesn't work as expected. I tried with few IP and each t=
ime 0x0100 were missing. csum_add seems buggy too.
>>> I have reimplemented csum16s functions with the Ulrich's fix. It se=
ems to work now.
>>> I'm a noob, so I guess someone will propose a better patch for this=
=2E
>>
>> We can't use csum_add after all, patch looks correct.
>>
>> Can you re-send with proper Signoff?
>>
>> [ carry detection breaks on overflow, e.g. a=3D=3D1 and b=3D0xffff y=
ields
>>  0 for csum_add (65536 < 1) and 1 for csum16_add (0 < 1) ]

Well... why do you fill npt->adjustment?
I think we can do checksumming in ip6t_npt_map_pfx()
with csum_partial(), csum_block_add()/csum_block_sub() and
csum_fold().

--yoshfuji


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Re: [PATCH] Add NFPROTO_ARP for mark
Date: Thu, 16 Apr 2015 13:06:03 +0200
Message-ID: <20150416110603.GA3451@salvia>
References: <1428374716-15108-1-git-send-email-zhangcy@cn.fujitsu.com>
 <1428374716-15108-2-git-send-email-zhangcy@cn.fujitsu.com>
 <20150408174911.GA4683@salvia>
 <A43879EB4A7F5F449E2CA8148EA79E5172E8F2@G08CNEXMBPEKD01.g08.fujitsu.local>
 <20150409104149.GA3568@salvia>
 <A43879EB4A7F5F449E2CA8148EA79E51758324@G08CNEXMBPEKD01.g08.fujitsu.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Zhang, Chunyu" <zhangcy@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38678 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbbDPLBv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Apr 2015 07:01:51 -0400
Content-Disposition: inline
In-Reply-To: <A43879EB4A7F5F449E2CA8148EA79E51758324@G08CNEXMBPEKD01.g08.fujitsu.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 16, 2015 at 05:39:31AM +0000, Zhang, Chunyu wrote:
>=20
> hi pablo
>=20
> >From: Pablo Neira Ayuso
> >Date: 2015-04-09
> >To: Zhang, Chunyu/=E7=AB=A0 =E6=98=A5=E5=AE=87
> >Subject: Re: Re: [PATCH] Add NFPROTO_ARP for mark
> >
> >On Thu, Apr 09, 2015 at 03:54:33AM +0000, Zhang, Chunyu wrote:
> >> >From: Pablo Neira Ayuso
> >> >Date: 2015-04-09
> >> >To: Zhang, Chunyu/=E7=AB=A0 =E6=98=A5=E5=AE=87
> >> >Subject: Re: [PATCH] Add NFPROTO_ARP for mark
> >[...]
> >> >> @@ -41,13 +42,23 @@ mark_mt(const struct sk_buff *skb, struct x=
t_action_param *par)
> >> >>       return ((skb->mark & info->mask) =3D=3D info->mark) ^ inf=
o->invert;
> >> >>  }
> >> >>
> >> >> -static struct xt_target mark_tg_reg __read_mostly =3D {
> >> >> -     .name           =3D "MARK",
> >> >> -     .revision       =3D 2,
> >> >> -     .family         =3D NFPROTO_UNSPEC,
> >> >> -     .target         =3D mark_tg,
> >> >> -     .targetsize     =3D sizeof(struct xt_mark_tginfo2),
> >> >> -     .me             =3D THIS_MODULE,
> >> >> +static struct xt_target mark_tg_reg[] __read_mostly =3D {
> >> >> +     {
> >> >> +             .name           =3D "MARK",
> >> >> +             .revision       =3D 2,
> >> >> +             .family         =3D NFPROTO_UNSPEC,
> >> >> +             .target         =3D mark_tg,
> >> >> +             .targetsize     =3D sizeof(struct xt_mark_tginfo2=
),
> >> >> +             .me             =3D THIS_MODULE,
> >> >> +     },
> >> >> +     {
> >> >> +             .name           =3D "MARK",
> >> >> +             .revision       =3D 2,
> >> >> +             .family         =3D NFPROTO_ARP,
> >> >> +             .target         =3D mark_tg,
> >> >> +             .targetsize     =3D sizeof(struct xt_mark_tginfo2=
),
> >> >> +             .me             =3D THIS_MODULE,
> >> >> +     }
> >> >>  };
> >> >
> >> >You don't need this.
> >> >
> >> >The problem is here that your patch:
> >> >
> >> >http://patchwork.ozlabs.org/patch/455966/
> >> >
> >> >is missing this chunk:
> >> >
> >> >diff --git a/libarptc/libarptc_incl.c b/libarptc/libarptc_incl.c
> >> >index a034930..87404ce 100644
> >> >--- a/libarptc/libarptc_incl.c
> >> >+++ b/libarptc/libarptc_incl.c
> >> >@@ -872,7 +872,7 @@ map_target(const TC_HANDLE_T handle,
> >> >        /* memset to all 0 for your memcmp convenience. */
> >> >        memset(t->u.user.name + strlen(t->u.user.name),
> >> >               0,
> >> >-              FUNCTION_MAXNAMELEN - strlen(t->u.user.name));
> >> >+              FUNCTION_MAXNAMELEN - 1 - strlen(t->u.user.name));
> >> >        return 1;
> >> > }
>=20
> 1.=20
> maybe should change like this=EF=BC=9F
>=20
> diff --git a/libarptc/libarptc_incl.c b/libarptc/libarptc_incl.c
> index a034930..4049cbd 100644
> --- a/libarptc/libarptc_incl.c
> +++ b/libarptc/libarptc_incl.c
> @@ -872,7 +872,7 @@ map_target(const TC_HANDLE_T handle,
>         /* memset to all 0 for your memcmp convenience. */
>         memset(t->u.user.name + strlen(t->u.user.name),
>                0,
> -              FUNCTION_MAXNAMELEN - strlen(t->u.user.name));
> +              XT_EXTENSION_MAXNAMELEN - strlen(t->u.user.name));

No, you can't do this.

After getting arptables userspace in sync with kernel headers, you can
see that:

#define ARPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN

and:

libarptc/libarptc.c:#define FUNCTION_MAXNAMELEN ARPT_FUNCTION_MAXNAMELE=
N

You have to do it the way I suggested.

Another motivation to make it the way I indicated is that this will be
in sync with iptables/ip6tables.

Anyway, I have just pushed this branch:

http://git.netfilter.org/arptables/log/?h=3Dnext

to try to close this discussion.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

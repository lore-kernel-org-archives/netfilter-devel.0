From: =?UTF-8?Q?Roberto_Garc=C3=ADa?= <rodanber@gmail.com>
Subject: Re: [PATCH] iptables: extensions: libxt_ecn: Add translation to nft
Date: Thu, 30 Jun 2016 00:15:14 +0200
Message-ID: <CA+5ZkkO9WjFGG-humemFbKr29-Ln1fm2nv__UUM+7EYhp=RWug@mail.gmail.com>
References: <1467226089-6852-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	=?UTF-8?Q?Roberto_Garc=C3=ADa?= <rodanber@gmail.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33332 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbcF2Wbx convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jun 2016 18:31:53 -0400
Received: by mail-lf0-f65.google.com with SMTP id l188so6525215lfe.0
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2016 15:31:08 -0700 (PDT)
In-Reply-To: <1467226089-6852-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reviewed-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

2016-06-29 20:48 GMT+02:00 <rodanber@gmail.com>:
>
> From: Roberto Garc=C3=ADa <rodanber@gmail.com>
>
> Add translation of the ecn match to nftables.
>
> Examples:
>   # iptables-translate -A INPUT -m ecn --ecn-ip-ect 0
>   nft add rule ip filter INPUT ip ecn not-ect counter
>
>   # iptables-translate -A INPUT -m ecn --ecn-ip-ect 1
>   nft add rule ip filter INPUT ip ecn ect1 counter
>
>   # iptables-translate -A INPUT -m ecn --ecn-ip-ect 2
>   nft add rule ip filter INPUT ip ecn ect0 counter
>
>   # iptables-translate -A INPUT -m ecn --ecn-ip-ect 3
>   nft add rule ip filter INPUT ip ecn ce counter
>
>   # iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 0
>   nft add rule ip filter INPUT ip ecn !=3D not-ect counter
>
>   # iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 1
>   nft add rule ip filter INPUT ip ecn !=3D ect1 counter
>
>   # iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 2
>   nft add rule ip filter INPUT ip ecn !=3D ect0 counter
>
>   # iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 3
>   nft add rule ip filter INPUT ip ecn !=3D ce counter
>
> Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
> ---
>  extensions/libxt_ecn.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/extensions/libxt_ecn.c b/extensions/libxt_ecn.c
> index 286782a..2856a31 100644
> --- a/extensions/libxt_ecn.c
> +++ b/extensions/libxt_ecn.c
> @@ -118,6 +118,36 @@ static void ecn_save(const void *ip, const struc=
t xt_entry_match *match)
>         }
>  }
>
> +static int ecn_xlate(const void *ip, const struct xt_entry_match *ma=
tch,
> +                    struct xt_xlate *xl, int numeric)
> +{
> +       const struct xt_ecn_info *einfo =3D
> +               (const struct xt_ecn_info *)match->data;
> +
> +       if (!(einfo->operation & XT_ECN_OP_MATCH_IP))
> +               return 0;
> +
> +       xt_xlate_add(xl, "ip ecn ");
> +       if (einfo->invert)
> +               xt_xlate_add(xl,"!=3D ");
> +
> +       switch (einfo->ip_ect) {
> +       case 0:
> +               xt_xlate_add(xl, "not-ect ");
> +               break;
> +       case 1:
> +               xt_xlate_add(xl, "ect1 ");
> +               break;
> +       case 2:
> +               xt_xlate_add(xl, "ect0 ");
> +               break;
> +       case 3:
> +               xt_xlate_add(xl, "ce ");
> +               break;
> +       }
> +       return 1;
> +}
> +
>  static struct xtables_match ecn_mt_reg =3D {
>         .name          =3D "ecn",
>         .version       =3D XTABLES_VERSION,
> @@ -130,6 +160,7 @@ static struct xtables_match ecn_mt_reg =3D {
>         .x6_parse      =3D ecn_parse,
>         .x6_fcheck     =3D ecn_check,
>         .x6_options    =3D ecn_opts,
> +       .xlate         =3D ecn_xlate,
>  };
>
>  void _init(void)
> --
> 2.8.0
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

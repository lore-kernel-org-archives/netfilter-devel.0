From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH iptables 2/3] xtables-compat: check if nft ruleset is compatible
Date: Sun, 21 Aug 2016 22:25:58 +0200
Message-ID: <CAOkSjBgx15vOVp6c-71L1bg+Aw300FagHecpXEtTWDEROJftRw@mail.gmail.com>
References: <20160821181027.14622-1-pablombg@gmail.com> <20160821181027.14622-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32967 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752420AbcHUU0U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Aug 2016 16:26:20 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so10726905wme.0
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Aug 2016 13:26:19 -0700 (PDT)
In-Reply-To: <20160821181027.14622-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 August 2016 at 20:10, Pablo M. Bermudo Garay <pablombg@gmail.com> wro=
te:
> This patch adds a verification of the compatibility between the nft
> ruleset and iptables. If the nft ruleset is not compatible with
> iptables, the execution stops and an error message is displayed to the
> user.
>
> This checking is triggered by xtables-compat -L and xtables-compat-save
> commands.
>
> Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
> ---
>  iptables/nft.c          | 166 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  iptables/nft.h          |   2 +
>  iptables/xtables-save.c |   5 ++
>  iptables/xtables.c      |   5 ++
>  4 files changed, 178 insertions(+)
>
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 247a60a..7389689 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -2698,3 +2698,169 @@ uint32_t nft_invflags2cmp(uint32_t invflags, uint=
32_t flag)
>
>         return NFT_CMP_EQ;
>  }
> +
> +static int nft_is_rule_compatible(struct nftnl_rule *rule)
> +{
> +       struct nftnl_expr_iter *iter;
> +       struct nftnl_expr *expr;
> +
> +       iter =3D nftnl_expr_iter_create(rule);
> +       if (iter =3D=3D NULL)
> +               return -1;
> +
> +       expr =3D nftnl_expr_iter_next(iter);
> +       while (expr !=3D NULL) {
> +               const char *name =3D nftnl_expr_get_str(expr, NFTNL_EXPR_=
NAME);
> +
> +               if (strcmp(name, "counter")   &&
> +                   strcmp(name, "match")     &&
> +                   strcmp(name, "target")    &&
> +                   strcmp(name, "payload")   &&
> +                   strcmp(name, "meta")      &&
> +                   strcmp(name, "bitwise")   &&
> +                   strcmp(name, "cmp")       &&
> +                   strcmp(name, "immediate") &&
> +                   strcmp(name, "match")     &&
> +                   strcmp(name, "target")) {
> +                       nftnl_expr_iter_destroy(iter);
> +                       return 1;
> +               }
> +
> +               expr =3D nftnl_expr_iter_next(iter);
> +       }
> +
> +       nftnl_expr_iter_destroy(iter);
> +       return 0;
> +}
> +

I don't fully understand this logic. It seems there are expression
names which are repeated. Is that intended?

--=20
Arturo Borrero Gonz=C3=A1lez

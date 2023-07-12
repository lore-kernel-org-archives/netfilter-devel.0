Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50E1EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jul 2023 11:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjGLLFn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jul 2023 07:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjGLLFZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2023 07:05:25 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7DE1727
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2023 04:05:23 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3fc04692e20so53040645e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2023 04:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1689159922; x=1691751922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJgwDNf3xfn2S1DQWoE5QoRzVhopIk4lPQ0gMvcYZcY=;
        b=G1Fu9qLVIiijjm3w8z0lO4KDC/WaBSJjagKHn5KRToTDiAS5xH8/xV09TwDy6Bvadx
         RemLpWFU0ugpWFZrZMQtp9QsaInTZjbt96SPbToKqf2FMURISALFotmuIoizemuzGYpj
         Mof5Fxu/ya0Uf7LQVfo68gAqPfNcDSNjPkoDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689159922; x=1691751922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XJgwDNf3xfn2S1DQWoE5QoRzVhopIk4lPQ0gMvcYZcY=;
        b=HHwVqMNU+hC4ZhvMQKaK7Nu/OwVeWjKZ4UVF4lAF50EZfyh9/4J38wISFxmH+IlRSJ
         iwXu3qM9nBdrKQfp5D3gkay31FO9WXKWpLV8eY+RAlXxVIe7N06OdwZZuHK/PMEBWbEH
         3PylegzhVxczXYQbXo8jM0oV9/RIskxfGcA+DiRha4/34mcyFpc0Lrd+gTLznlHVNRJy
         w9MQWY97WbFItzm6eOJq8WRatxeJAYeZuiTpSQsMj/vkD7mhpH5Mv6Y76qSt/Gm6NcK2
         qHiSHOa5jpC9HWro9vFiMKrz1nnsGFx4D2fKDlQL5xrXAOHJdFlRcME1pI7Z3EI1em6G
         Wk4Q==
X-Gm-Message-State: ABy/qLYxQww13XtBcghITuC7O9JKLOc+rniJ66PYfapT5qvoX34tUGRm
        7E+FC4hrX3qI7Irs9deN/JrWAkwWlHWuuMDReg6Tlw==
X-Google-Smtp-Source: APBJJlG5u+iVFEW7chBIwQPf4dki1kTrvMHScrUPnn8NcwxlWj9V3pR0UDpZ7oVS4GlhYUwQ2pQIuCh1eGyUyIi9hoQ=
X-Received: by 2002:a5d:56cd:0:b0:314:3983:1465 with SMTP id
 m13-20020a5d56cd000000b0031439831465mr19103653wrw.31.1689159921580; Wed, 12
 Jul 2023 04:05:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230712095912.140792-1-pablo@netfilter.org>
In-Reply-To: <20230712095912.140792-1-pablo@netfilter.org>
From:   Igor Raits <igor@gooddata.com>
Date:   Wed, 12 Jul 2023 13:05:10 +0200
Message-ID: <CA+9S74i+UOzqjbTK7LBpspYUnQ3xFz__Q2gedA0tO1S7rg5FCw@mail.gmail.com>
Subject: Re: [PATCH iptables] nft-bridge: pass context structure to ops->add()
 to improve anonymous set support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Thanks for the patch!

On Wed, Jul 12, 2023 at 11:59=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter=
.org> wrote:
>
> Add context structure to improve bridge among support which creates an
> anonymous set. This context structure specifies the command and it
> allows to optionally store a anonymous set.
>
> Use this context to generate native bytecode only if this is an
> add/insert/replace command.
>
> This fixes a dangling anonymous set that is created on rule removal.
>
> Fixes: 26753888720d ("nft: bridge: Rudimental among extension support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reported-and-tested-by: Igor Raits <igor@gooddata.com>

> ---
> This test passes tests/py and tests/shell.
>
>  iptables/nft-arp.c    |  4 ++--
>  iptables/nft-bridge.c |  9 ++++----
>  iptables/nft-cmd.c    |  6 ++++-
>  iptables/nft-ipv4.c   |  6 ++---
>  iptables/nft-ipv6.c   |  6 ++---
>  iptables/nft-shared.h |  5 ++--
>  iptables/nft.c        | 54 ++++++++++++++++++++++++++++---------------
>  iptables/nft.h        |  9 +++++---
>  8 files changed, 62 insertions(+), 37 deletions(-)
>
> diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
> index 265de5f88cea..9868966a0368 100644
> --- a/iptables/nft-arp.c
> +++ b/iptables/nft-arp.c
> @@ -40,8 +40,8 @@ static bool need_devaddr(struct arpt_devaddr_info *info=
)
>         return false;
>  }
>
> -static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
> -                      struct iptables_command_state *cs)
> +static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
> +                      struct nftnl_rule *r, struct iptables_command_stat=
e *cs)
>  {
>         struct arpt_entry *fw =3D &cs->arp;
>         uint32_t op;
> diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
> index 6e50950774e6..391a8ab723c1 100644
> --- a/iptables/nft-bridge.c
> +++ b/iptables/nft-bridge.c
> @@ -138,7 +138,8 @@ static int _add_action(struct nftnl_rule *r, struct i=
ptables_command_state *cs)
>
>  static int
>  nft_bridge_add_match(struct nft_handle *h, const struct ebt_entry *fw,
> -                    struct nftnl_rule *r, struct xt_entry_match *m)
> +                    struct nft_rule_ctx *ctx, struct nftnl_rule *r,
> +                    struct xt_entry_match *m)
>  {
>         if (!strcmp(m->u.user.name, "802_3") && !(fw->bitmask & EBT_802_3=
))
>                 xtables_error(PARAMETER_PROBLEM,
> @@ -152,10 +153,10 @@ nft_bridge_add_match(struct nft_handle *h, const st=
ruct ebt_entry *fw,
>                 xtables_error(PARAMETER_PROBLEM,
>                               "For IPv6 filtering the protocol must be sp=
ecified as IPv6.");
>
> -       return add_match(h, r, m);
> +       return add_match(h, ctx, r, m);
>  }
>
> -static int nft_bridge_add(struct nft_handle *h,
> +static int nft_bridge_add(struct nft_handle *h, struct nft_rule_ctx *ctx=
,
>                           struct nftnl_rule *r,
>                           struct iptables_command_state *cs)
>  {
> @@ -217,7 +218,7 @@ static int nft_bridge_add(struct nft_handle *h,
>
>         for (iter =3D cs->match_list; iter; iter =3D iter->next) {
>                 if (iter->ismatch) {
> -                       if (nft_bridge_add_match(h, fw, r, iter->u.match-=
>m))
> +                       if (nft_bridge_add_match(h, fw, ctx, r, iter->u.m=
atch->m))
>                                 break;
>                 } else {
>                         if (add_target(r, iter->u.watcher->t))
> diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
> index 7b2fc3a59578..8a824586ad8c 100644
> --- a/iptables/nft-cmd.c
> +++ b/iptables/nft-cmd.c
> @@ -14,12 +14,16 @@
>  #include <xtables.h>
>  #include "nft.h"
>  #include "nft-cmd.h"
> +#include <libnftnl/set.h>
>
>  struct nft_cmd *nft_cmd_new(struct nft_handle *h, int command,
>                             const char *table, const char *chain,
>                             struct iptables_command_state *state,
>                             int rulenum, bool verbose)
>  {
> +       struct nft_rule_ctx ctx =3D {
> +               .command =3D command,
> +       };
>         struct nftnl_rule *rule;
>         struct nft_cmd *cmd;
>
> @@ -33,7 +37,7 @@ struct nft_cmd *nft_cmd_new(struct nft_handle *h, int c=
ommand,
>         cmd->verbose =3D verbose;
>
>         if (state) {
> -               rule =3D nft_rule_new(h, chain, table, state);
> +               rule =3D nft_rule_new(h, &ctx, chain, table, state);
>                 if (!rule) {
>                         nft_cmd_free(cmd);
>                         return NULL;
> diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
> index 2a5d25d8694e..2f10220edd50 100644
> --- a/iptables/nft-ipv4.c
> +++ b/iptables/nft-ipv4.c
> @@ -26,8 +26,8 @@
>  #include "nft.h"
>  #include "nft-shared.h"
>
> -static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r,
> -                       struct iptables_command_state *cs)
> +static int nft_ipv4_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
> +                       struct nftnl_rule *r, struct iptables_command_sta=
te *cs)
>  {
>         struct xtables_rule_match *matchp;
>         uint32_t op;
> @@ -84,7 +84,7 @@ static int nft_ipv4_add(struct nft_handle *h, struct nf=
tnl_rule *r,
>         add_compat(r, cs->fw.ip.proto, cs->fw.ip.invflags & XT_INV_PROTO)=
;
>
>         for (matchp =3D cs->matches; matchp; matchp =3D matchp->next) {
> -               ret =3D add_match(h, r, matchp->match->m);
> +               ret =3D add_match(h, ctx, r, matchp->match->m);
>                 if (ret < 0)
>                         return ret;
>         }
> diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
> index 658a4f201895..d53f87c1d26e 100644
> --- a/iptables/nft-ipv6.c
> +++ b/iptables/nft-ipv6.c
> @@ -25,8 +25,8 @@
>  #include "nft.h"
>  #include "nft-shared.h"
>
> -static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r,
> -                       struct iptables_command_state *cs)
> +static int nft_ipv6_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
> +                       struct nftnl_rule *r, struct iptables_command_sta=
te *cs)
>  {
>         struct xtables_rule_match *matchp;
>         uint32_t op;
> @@ -70,7 +70,7 @@ static int nft_ipv6_add(struct nft_handle *h, struct nf=
tnl_rule *r,
>         add_compat(r, cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags & XT_INV_=
PROTO);
>
>         for (matchp =3D cs->matches; matchp; matchp =3D matchp->next) {
> -               ret =3D add_match(h, r, matchp->match->m);
> +               ret =3D add_match(h, ctx, r, matchp->match->m);
>                 if (ret < 0)
>                         return ret;
>         }
> diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
> index a06b263d77c1..4f47058d2ec5 100644
> --- a/iptables/nft-shared.h
> +++ b/iptables/nft-shared.h
> @@ -35,13 +35,14 @@
>                         | FMT_NUMERIC | FMT_NOTABLE)
>  #define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
>
> +struct nft_rule_ctx;
>  struct xtables_args;
>  struct nft_handle;
>  struct xt_xlate;
>
>  struct nft_family_ops {
> -       int (*add)(struct nft_handle *h, struct nftnl_rule *r,
> -                  struct iptables_command_state *cs);
> +       int (*add)(struct nft_handle *h, struct nft_rule_ctx *ctx,
> +                  struct nftnl_rule *r, struct iptables_command_state *c=
s);
>         bool (*is_same)(const struct iptables_command_state *cs_a,
>                         const struct iptables_command_state *cs_b);
>         void (*print_payload)(struct nftnl_expr *e,
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 1cb104e75ccc..59e3fa7079c4 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -1154,7 +1154,8 @@ gen_lookup(uint32_t sreg, const char *set_name, uin=
t32_t set_id, uint32_t flags)
>  #define NFT_DATATYPE_ETHERADDR 9
>
>  static int __add_nft_among(struct nft_handle *h, const char *table,
> -                          struct nftnl_rule *r, struct nft_among_pair *p=
airs,
> +                          struct nft_rule_ctx *ctx, struct nftnl_rule *r=
,
> +                          struct nft_among_pair *pairs,
>                            int cnt, bool dst, bool inv, bool ip)
>  {
>         uint32_t set_id, type =3D NFT_DATATYPE_ETHERADDR, len =3D ETH_ALE=
N;
> @@ -1235,7 +1236,7 @@ static int __add_nft_among(struct nft_handle *h, co=
nst char *table,
>         return 0;
>  }
>
> -static int add_nft_among(struct nft_handle *h,
> +static int add_nft_among(struct nft_handle *h, struct nft_rule_ctx *ctx,
>                          struct nftnl_rule *r, struct xt_entry_match *m)
>  {
>         struct nft_among_data *data =3D (struct nft_among_data *)m->data;
> @@ -1251,10 +1252,10 @@ static int add_nft_among(struct nft_handle *h,
>         }
>
>         if (data->src.cnt)
> -               __add_nft_among(h, table, r, data->pairs, data->src.cnt,
> +               __add_nft_among(h, table, ctx, r, data->pairs, data->src.=
cnt,
>                                 false, data->src.inv, data->src.ip);
>         if (data->dst.cnt)
> -               __add_nft_among(h, table, r, data->pairs + data->src.cnt,
> +               __add_nft_among(h, table, ctx, r, data->pairs + data->src=
.cnt,
>                                 data->dst.cnt, true, data->dst.inv,
>                                 data->dst.ip);
>         return 0;
> @@ -1462,22 +1463,30 @@ static int add_nft_mark(struct nft_handle *h, str=
uct nftnl_rule *r,
>         return 0;
>  }
>
> -int add_match(struct nft_handle *h,
> +int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
>               struct nftnl_rule *r, struct xt_entry_match *m)
>  {
>         struct nftnl_expr *expr;
>         int ret;
>
> -       if (!strcmp(m->u.user.name, "limit"))
> -               return add_nft_limit(r, m);
> -       else if (!strcmp(m->u.user.name, "among"))
> -               return add_nft_among(h, r, m);
> -       else if (!strcmp(m->u.user.name, "udp"))
> -               return add_nft_udp(h, r, m);
> -       else if (!strcmp(m->u.user.name, "tcp"))
> -               return add_nft_tcp(h, r, m);
> -       else if (!strcmp(m->u.user.name, "mark"))
> -               return add_nft_mark(h, r, m);
> +       switch (ctx->command) {
> +       case NFT_COMPAT_RULE_APPEND:
> +       case NFT_COMPAT_RULE_INSERT:
> +       case NFT_COMPAT_RULE_REPLACE:
> +               if (!strcmp(m->u.user.name, "limit"))
> +                       return add_nft_limit(r, m);
> +               else if (!strcmp(m->u.user.name, "among"))
> +                       return add_nft_among(h, ctx, r, m);
> +               else if (!strcmp(m->u.user.name, "udp"))
> +                       return add_nft_udp(h, r, m);
> +               else if (!strcmp(m->u.user.name, "tcp"))
> +                       return add_nft_tcp(h, r, m);
> +               else if (!strcmp(m->u.user.name, "mark"))
> +                       return add_nft_mark(h, r, m);
> +               break;
> +       default:
> +               break;
> +       }
>
>         expr =3D nftnl_expr_alloc("match");
>         if (expr =3D=3D NULL)
> @@ -1705,7 +1714,8 @@ void add_compat(struct nftnl_rule *r, uint32_t prot=
o, bool inv)
>  }
>
>  struct nftnl_rule *
> -nft_rule_new(struct nft_handle *h, const char *chain, const char *table,
> +nft_rule_new(struct nft_handle *h, struct nft_rule_ctx *ctx,
> +            const char *chain, const char *table,
>              struct iptables_command_state *cs)
>  {
>         struct nftnl_rule *r;
> @@ -1718,7 +1728,7 @@ nft_rule_new(struct nft_handle *h, const char *chai=
n, const char *table,
>         nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
>         nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
>
> -       if (h->ops->add(h, r, cs) < 0)
> +       if (h->ops->add(h, ctx, r, cs) < 0)
>                 goto err;
>
>         return r;
> @@ -2878,6 +2888,9 @@ int nft_rule_zero_counters(struct nft_handle *h, co=
nst char *chain,
>  {
>         struct iptables_command_state cs =3D {};
>         struct nftnl_rule *r, *new_rule;
> +       struct nft_rule_ctx ctx =3D {
> +               .command =3D NFT_COMPAT_RULE_ZERO,
> +       };
>         struct nft_chain *c;
>         int ret =3D 0;
>
> @@ -2896,7 +2909,7 @@ int nft_rule_zero_counters(struct nft_handle *h, co=
nst char *chain,
>
>         h->ops->rule_to_cs(h, r, &cs);
>         cs.counters.pcnt =3D cs.counters.bcnt =3D 0;
> -       new_rule =3D nft_rule_new(h, chain, table, &cs);
> +       new_rule =3D nft_rule_new(h, &ctx, chain, table, &cs);
>         h->ops->clear_cs(&cs);
>
>         if (!new_rule)
> @@ -3274,6 +3287,9 @@ static int ebt_add_policy_rule(struct nftnl_chain *=
c, void *data)
>                 .eb.bitmask =3D EBT_NOPROTO,
>         };
>         struct nftnl_udata_buf *udata;
> +       struct nft_rule_ctx ctx =3D {
> +               .command        =3D NFT_COMPAT_RULE_APPEND,
> +       };
>         struct nft_handle *h =3D data;
>         struct nftnl_rule *r;
>         const char *pname;
> @@ -3301,7 +3317,7 @@ static int ebt_add_policy_rule(struct nftnl_chain *=
c, void *data)
>
>         command_jump(&cs, pname);
>
> -       r =3D nft_rule_new(h, nftnl_chain_get_str(c, NFTNL_CHAIN_NAME),
> +       r =3D nft_rule_new(h, &ctx, nftnl_chain_get_str(c, NFTNL_CHAIN_NA=
ME),
>                          nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE), &cs);
>         ebt_cs_clean(&cs);
>
> diff --git a/iptables/nft.h b/iptables/nft.h
> index 1d18982dc8cf..5acbbf82e2c2 100644
> --- a/iptables/nft.h
> +++ b/iptables/nft.h
> @@ -168,9 +168,11 @@ struct nftnl_set *nft_set_batch_lookup_byid(struct n=
ft_handle *h,
>  /*
>   * Operations with rule-set.
>   */
> -struct nftnl_rule;
> +struct nft_rule_ctx {
> +       int                     command;
> +};
>
> -struct nftnl_rule *nft_rule_new(struct nft_handle *h, const char *chain,=
 const char *table, struct iptables_command_state *cs);
> +struct nftnl_rule *nft_rule_new(struct nft_handle *h, struct nft_rule_ct=
x *rule, const char *chain, const char *table, struct iptables_command_stat=
e *cs);
>  int nft_rule_append(struct nft_handle *h, const char *chain, const char =
*table, struct nftnl_rule *r, struct nftnl_rule *ref, bool verbose);
>  int nft_rule_insert(struct nft_handle *h, const char *chain, const char =
*table, struct nftnl_rule *r, int rulenum, bool verbose);
>  int nft_rule_check(struct nft_handle *h, const char *chain, const char *=
table, struct nftnl_rule *r, bool verbose);
> @@ -188,7 +190,8 @@ int nft_rule_zero_counters(struct nft_handle *h, cons=
t char *chain, const char *
>   */
>  int add_counters(struct nftnl_rule *r, uint64_t packets, uint64_t bytes)=
;
>  int add_verdict(struct nftnl_rule *r, int verdict);
> -int add_match(struct nft_handle *h, struct nftnl_rule *r, struct xt_entr=
y_match *m);
> +int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
> +             struct nftnl_rule *r, struct xt_entry_match *m);
>  int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
>  int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
>  int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, =
bool goto_set);
> --
> 2.30.2
>


--=20

Igor Raits | Sr. Principal SW Engineer

igor@gooddata.com

+420 775 117 817


Moravske namesti 1007/14

602 00 Brno-Veveri, Czech Republic

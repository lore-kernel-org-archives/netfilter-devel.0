Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C3322154B
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Dec 2025 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767016301; cv=none; b=oa4E6CFBzvg00/u0Lzlv9AupuPZyT5CanaWbWb/EXPK46fwU4J6KqsKUEF2w7B8zv4IaCs1RBwVNvtyyh+6x7n05oAbEhsFH+5jC2NZ2lEkYO6X8B7FgJ1BMRdt4Lhx1X5sV4j28l7aJPLAGw/O2U7QY53L2FoKAKPqdE4LEQTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767016301; c=relaxed/simple;
	bh=ueZyvfB4L0Pl0h8TA2fw4fP51LZw5+nOLIZpNR1HYZs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hrQdRJm7ZckycZOD+Gus5JBB4civdPrm+TEGmD5pWDZR7J/3ntg8PAKMomSS+28yvESMkGepBHQeSyg+kL8EL3ErelzxvyKxe99vCTVjFj68Ryrfq9UFBYpTr7gYJ4RD4X1N9Tp7qEubjca3aEdw9juxh08TfmIC1kXNbpQbMCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PwhyjQ1t; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PexCffdK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PwhyjQ1t";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PexCffdK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767016297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZKWdV+tpa9/mmyA1l9ldTm5ReWQS6CD64zxqBwoR4q8=;
	b=PwhyjQ1tCjGLmG89+7qZ9ZoaAdTaD6555K37XrLrbmMn+c6REjy7AGv5lb6bU73z73A29h
	cC4TbCPISsMFKUsKPxE9Asmvd/evB8KF3t/B60JYQLvScDE6bmxd6FGAXHodrb75P9xh21
	ojMYh7KX1DjWW9AMqOJG+Ks1mRnnMa0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-OOOq62ZXPGK2lZgkPXgJLg-1; Mon, 29 Dec 2025 08:51:34 -0500
X-MC-Unique: OOOq62ZXPGK2lZgkPXgJLg-1
X-Mimecast-MFC-AGG-ID: OOOq62ZXPGK2lZgkPXgJLg_1767016293
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c314af2d4so8802181a91.3
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Dec 2025 05:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767016293; x=1767621093; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKWdV+tpa9/mmyA1l9ldTm5ReWQS6CD64zxqBwoR4q8=;
        b=PexCffdKUkeI8ivIUmAqhKb3MWVBNYvHMLIEhx8B6+6+P5vvDrwxXgV+f41xctRPvP
         Iq+SCb2AOP+qILSQjjGDWRexavOdbvJp2776Ij6gQI9gZQqxlMD0RudMJ8w7Be9syy70
         eosoB2z3lo0JDn7nTihuJ6Ktn4S1Ws22lkT1j/fkBtejbcWl2gd6Y/2bib7s82QsG/gP
         NzaSwj2QWxDxHSJFsKmFXI+jq5KTlvhZp7DVijjQku4LpTEnFLW8cMq/AXrv9Tg4nYbk
         Y1HM1uBNi47ktROjzCd+7BDejiARPEOcn42LGdTjqYhLMluHSeocN73ernqYngztswut
         bt+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767016293; x=1767621093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZKWdV+tpa9/mmyA1l9ldTm5ReWQS6CD64zxqBwoR4q8=;
        b=RBdA47Qgv9smVEcMgbGcaz9fXMBO+9RCL+ZZfYKYAKDndd49NY04enT9xb1cmNqK52
         /9YOUTYEF6rZtXytmm9sIArOb340yxDXAxJs+Zb0MxmZ1rImJ+7gpHkhyL6b2OPy3JTT
         1hcS3nH0drpyIYQz4yMn62ehauZG3Mx7lmFusnyMyzHsa5i7cM0Pf7Sk7lrHSdCmuwmA
         3q/EBJdcqfINqjmNFJdYSWnX6+4/cdmNfdf7ZinOh7LrwFL0UWrIepdoZJfOzeZYIjZu
         8jfhB5ObKMiba6agXPpZO5anVOUfZqBteTa22BWSAlHUOKURbHyc1DddlZXchx4ZMOaT
         DntQ==
X-Gm-Message-State: AOJu0YznuQ7TKZkocTIUVMJo0w5lF8GnIlxvhleyNwd5N3ojeSfJ2H7m
	AXvEGL8vVJya2/N+6/X/OmriD8lo48K9guhNo1dgZx7kBEulw1JjEmvD+7d5d++2Ge3ha/VuHX8
	HcrBz8eAfRAlhO3BwSMGCX44Xo9h3F729ns7WgAB6ADbattVg7i0D3Q7C2PS//phRfWjjM/EnNb
	OJ9iX4O7NnUiJ7MhdbqZJfbXEbbAiCxUz9oXAPpJAdiwtG
X-Gm-Gg: AY/fxX7H6tRJ/nVw+Su08rKjK+PsTZIFbCziL5CrYiSwoYsBM6qILIVWnMT0Pi/bYpK
	xNC1zMj6U2WkJQ6anP13sNH95/mCfCkK+AXOzW+wVLW8YIBApqbX56lir2O0gHZ0QGxuB7XKXsy
	rLS7GabkjHT18kOoGZ845Q7/aVf7rLvZDx/BFCGMXyR0x+9Vmn+pFL5cNRIzxrprt83RE=
X-Received: by 2002:a17:90b:4b09:b0:341:c964:125b with SMTP id 98e67ed59e1d1-34e921f0d80mr23233993a91.31.1767016292979;
        Mon, 29 Dec 2025 05:51:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF2ZHGqBq6/N22uL1AffO7vBNHJp7JXBbzpkGm0RDAVJd85thjlCBcCFis0lg99/1NWbo2kY2/SRIjYlB5Afb8=
X-Received: by 2002:a17:90b:4b09:b0:341:c964:125b with SMTP id
 98e67ed59e1d1-34e921f0d80mr23233977a91.31.1767016292475; Mon, 29 Dec 2025
 05:51:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821091302.9032-1-fmancera@suse.de> <20250821091302.9032-3-fmancera@suse.de>
In-Reply-To: <20250821091302.9032-3-fmancera@suse.de>
From: Yi Chen <yiche@redhat.com>
Date: Mon, 29 Dec 2025 21:51:05 +0800
X-Gm-Features: AQt7F2pHY6F45J1ZK8C-5abGzHw-3x3bE6wBJCkV0QU9ko5CrzGzr9jsT90Ej3Q
Message-ID: <CAJsUoE2uoZJH2VA6E+J+SK=G1W06JE2+0v-NmgGyGWBNRKFgng@mail.gmail.com>
Subject: Re: [PATCH 3/7 nft v3] src: add tunnel statement and expression support
To: Fernando Fernandez Mancera <fmancera@suse.de>, pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, Phil Sutter <phil@nwl.cc>, 
	Eric Garver <egarver@redhat.com>
Content-Type: multipart/mixed; boundary="0000000000006d36460647178abb"

--0000000000006d36460647178abb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Pablo and Fernando,
I have started working on a test script (attached) to exercise this
feature, using a geneve tunnel with an egress hook.
Please let me know if egress is the correct hook to use in this context.

However, the behavior is not what I expected: the tunnel template does
not appear to be attached, and even ARP packets are not being
encapsulated.
I would appreciate any guidance on what I might be missing, or
suggestions on how this test could be improved.
Thank you for your time and help.


On Thu, Aug 21, 2025 at 5:18=E2=80=AFPM Fernando Fernandez Mancera
<fmancera@suse.de> wrote:
>
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> This patch allows you to attach tunnel metadata through the tunnel
> statement.
>
> The following example shows how to redirect traffic to the erspan0
> tunnel device which will take the tunnel configuration that is
> specified by the ruleset.
>
>      table netdev x {
>             tunnel y {
>                     id 10
>                     ip saddr 192.168.2.10
>                     ip daddr 192.168.2.11
>                     sport 10
>                     dport 20
>                     ttl 10
>                     erspan {
>                             version 1
>                             index 2
>                     }
>             }
>
>             chain x {
>                     type filter hook ingress device veth0 priority 0;
>
>                     ip daddr 10.141.10.123 tunnel name y fwd to erspan0
>             }
>      }
>
> This patch also allows to match on tunnel metadata via tunnel expression.
>
> Joint work with Fernando.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
> v3: rebased
> ---
>  Makefile.am               |  2 +
>  include/expression.h      |  6 +++
>  include/tunnel.h          | 33 ++++++++++++++++
>  src/evaluate.c            |  8 ++++
>  src/expression.c          |  1 +
>  src/netlink_delinearize.c | 17 ++++++++
>  src/netlink_linearize.c   | 14 +++++++
>  src/parser_bison.y        | 33 +++++++++++++---
>  src/scanner.l             |  3 +-
>  src/statement.c           |  1 +
>  src/tunnel.c              | 81 +++++++++++++++++++++++++++++++++++++++
>  11 files changed, 193 insertions(+), 6 deletions(-)
>  create mode 100644 include/tunnel.h
>  create mode 100644 src/tunnel.c
>
> diff --git a/Makefile.am b/Makefile.am
> index 4909abfe..152a80d6 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -100,6 +100,7 @@ noinst_HEADERS =3D \
>         include/statement.h \
>         include/tcpopt.h \
>         include/trace.h \
> +       include/tunnel.h \
>         include/utils.h \
>         include/xfrm.h \
>         include/xt.h \
> @@ -243,6 +244,7 @@ src_libnftables_la_SOURCES =3D \
>         src/socket.c \
>         src/statement.c \
>         src/tcpopt.c \
> +       src/tunnel.c \
>         src/utils.c \
>         src/xfrm.c \
>         $(NULL)
> diff --git a/include/expression.h b/include/expression.h
> index e483b7e7..7185ee66 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -77,6 +77,7 @@ enum expr_types {
>         EXPR_NUMGEN,
>         EXPR_HASH,
>         EXPR_RT,
> +       EXPR_TUNNEL,
>         EXPR_FIB,
>         EXPR_XFRM,
>         EXPR_SET_ELEM_CATCHALL,
> @@ -229,6 +230,7 @@ enum expr_flags {
>  #include <hash.h>
>  #include <ct.h>
>  #include <socket.h>
> +#include <tunnel.h>
>  #include <osf.h>
>  #include <xfrm.h>
>
> @@ -368,6 +370,10 @@ struct expr {
>                         enum nft_socket_keys    key;
>                         uint32_t                level;
>                 } socket;
> +               struct {
> +                       /* EXPR_TUNNEL */
> +                       enum nft_tunnel_keys    key;
> +               } tunnel;
>                 struct {
>                         /* EXPR_RT */
>                         enum nft_rt_keys        key;
> diff --git a/include/tunnel.h b/include/tunnel.h
> new file mode 100644
> index 00000000..9e6bd97a
> --- /dev/null
> +++ b/include/tunnel.h
> @@ -0,0 +1,33 @@
> +#ifndef NFTABLES_TUNNEL_H
> +#define NFTABLES_TUNNEL_H
> +
> +/**
> + * struct tunnel_template - template for tunnel expressions
> + *
> + * @token:     parser token for the expression
> + * @dtype:     data type of the expression
> + * @len:       length of the expression
> + * @byteorder: byteorder
> + */
> +struct tunnel_template {
> +       const char              *token;
> +       const struct datatype   *dtype;
> +       enum byteorder          byteorder;
> +       unsigned int            len;
> +};
> +
> +extern const struct tunnel_template tunnel_templates[];
> +
> +#define TUNNEL_TEMPLATE(__token, __dtype, __len, __byteorder) {        \
> +       .token          =3D (__token),                            \
> +       .dtype          =3D (__dtype),                            \
> +       .len            =3D (__len),                              \
> +       .byteorder      =3D (__byteorder),                        \
> +}
> +
> +extern struct expr *tunnel_expr_alloc(const struct location *loc,
> +                                     enum nft_tunnel_keys key);
> +
> +extern const struct expr_ops tunnel_expr_ops;
> +
> +#endif /* NFTABLES_TUNNEL_H */
> diff --git a/src/evaluate.c b/src/evaluate.c
> index da8794dd..6bf14b0c 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1737,6 +1737,7 @@ static int expr_evaluate_concat(struct eval_ctx *ct=
x, struct expr **expr)
>                 case EXPR_SOCKET:
>                 case EXPR_OSF:
>                 case EXPR_XFRM:
> +               case EXPR_TUNNEL:
>                         break;
>                 case EXPR_RANGE:
>                 case EXPR_PREFIX:
> @@ -3053,6 +3054,11 @@ static int expr_evaluate_osf(struct eval_ctx *ctx,=
 struct expr **expr)
>         return expr_evaluate_primary(ctx, expr);
>  }
>
> +static int expr_evaluate_tunnel(struct eval_ctx *ctx, struct expr **expr=
p)
> +{
> +       return expr_evaluate_primary(ctx, exprp);
> +}
> +
>  static int expr_evaluate_variable(struct eval_ctx *ctx, struct expr **ex=
prp)
>  {
>         struct symbol *sym =3D (*exprp)->sym;
> @@ -3170,6 +3176,8 @@ static int expr_evaluate(struct eval_ctx *ctx, stru=
ct expr **expr)
>                 return expr_evaluate_meta(ctx, expr);
>         case EXPR_SOCKET:
>                 return expr_evaluate_socket(ctx, expr);
> +       case EXPR_TUNNEL:
> +               return expr_evaluate_tunnel(ctx, expr);
>         case EXPR_OSF:
>                 return expr_evaluate_osf(ctx, expr);
>         case EXPR_FIB:
> diff --git a/src/expression.c b/src/expression.c
> index 8cb63979..e3c27a13 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -1762,6 +1762,7 @@ static const struct expr_ops *__expr_ops_by_type(en=
um expr_types etype)
>         case EXPR_NUMGEN: return &numgen_expr_ops;
>         case EXPR_HASH: return &hash_expr_ops;
>         case EXPR_RT: return &rt_expr_ops;
> +       case EXPR_TUNNEL: return &tunnel_expr_ops;
>         case EXPR_FIB: return &fib_expr_ops;
>         case EXPR_XFRM: return &xfrm_expr_ops;
>         case EXPR_SET_ELEM_CATCHALL: return &set_elem_catchall_expr_ops;
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index b97962a3..5627826d 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -940,6 +940,21 @@ static void netlink_parse_osf(struct netlink_parse_c=
tx *ctx,
>         netlink_set_register(ctx, dreg, expr);
>  }
>
> +static void netlink_parse_tunnel(struct netlink_parse_ctx *ctx,
> +                                const struct location *loc,
> +                                const struct nftnl_expr *nle)
> +{
> +       enum nft_registers dreg;
> +       struct expr * expr;
> +       uint32_t key;
> +
> +       key =3D nftnl_expr_get_u32(nle, NFTNL_EXPR_TUNNEL_KEY);
> +       expr =3D tunnel_expr_alloc(loc, key);
> +
> +       dreg =3D netlink_parse_register(nle, NFTNL_EXPR_TUNNEL_DREG);
> +       netlink_set_register(ctx, dreg, expr);
> +}
> +
>  static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
>                                     const struct location *loc,
>                                     const struct nftnl_expr *nle)
> @@ -1922,6 +1937,7 @@ static const struct expr_handler netlink_parsers[] =
=3D {
>         { .name =3D "exthdr",     .parse =3D netlink_parse_exthdr },
>         { .name =3D "meta",       .parse =3D netlink_parse_meta },
>         { .name =3D "socket",     .parse =3D netlink_parse_socket },
> +       { .name =3D "tunnel",     .parse =3D netlink_parse_tunnel },
>         { .name =3D "osf",        .parse =3D netlink_parse_osf },
>         { .name =3D "rt",         .parse =3D netlink_parse_rt },
>         { .name =3D "ct",         .parse =3D netlink_parse_ct },
> @@ -3023,6 +3039,7 @@ static void expr_postprocess(struct rule_pp_ctx *ct=
x, struct expr **exprp)
>         case EXPR_NUMGEN:
>         case EXPR_FIB:
>         case EXPR_SOCKET:
> +       case EXPR_TUNNEL:
>         case EXPR_OSF:
>         case EXPR_XFRM:
>                 break;
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index 8ac33d34..d01cadf8 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -334,6 +334,18 @@ static void netlink_gen_osf(struct netlink_linearize=
_ctx *ctx,
>         nft_rule_add_expr(ctx, nle, &expr->location);
>  }
>
> +static void netlink_gen_tunnel(struct netlink_linearize_ctx *ctx,
> +                              const struct expr *expr,
> +                              enum nft_registers dreg)
> +{
> +       struct nftnl_expr *nle;
> +
> +       nle =3D alloc_nft_expr("tunnel");
> +       netlink_put_register(nle, NFTNL_EXPR_TUNNEL_DREG, dreg);
> +       nftnl_expr_set_u32(nle, NFTNL_EXPR_TUNNEL_KEY, expr->tunnel.key);
> +       nftnl_rule_add_expr(ctx->nlr, nle);
> +}
> +
>  static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
>                             const struct expr *expr,
>                             enum nft_registers dreg)
> @@ -932,6 +944,8 @@ static void netlink_gen_expr(struct netlink_linearize=
_ctx *ctx,
>                 return netlink_gen_fib(ctx, expr, dreg);
>         case EXPR_SOCKET:
>                 return netlink_gen_socket(ctx, expr, dreg);
> +       case EXPR_TUNNEL:
> +               return netlink_gen_tunnel(ctx, expr, dreg);
>         case EXPR_OSF:
>                 return netlink_gen_osf(ctx, expr, dreg);
>         case EXPR_XFRM:
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 557977e2..08d75dbb 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -321,6 +321,8 @@ int nft_lex(void *, void *, void *);
>  %token RULESET                 "ruleset"
>  %token TRACE                   "trace"
>
> +%token PATH                    "path"
> +
>  %token INET                    "inet"
>  %token NETDEV                  "netdev"
>
> @@ -779,8 +781,8 @@ int nft_lex(void *, void *, void *);
>  %destructor { stmt_free($$); } counter_stmt counter_stmt_alloc stateful_=
stmt last_stmt
>  %type <stmt>                   limit_stmt_alloc quota_stmt_alloc last_st=
mt_alloc ct_limit_stmt_alloc
>  %destructor { stmt_free($$); } limit_stmt_alloc quota_stmt_alloc last_st=
mt_alloc ct_limit_stmt_alloc
> -%type <stmt>                   objref_stmt objref_stmt_counter objref_st=
mt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
> -%destructor { stmt_free($$); } objref_stmt objref_stmt_counter objref_st=
mt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
> +%type <stmt>                   objref_stmt objref_stmt_counter objref_st=
mt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy objref_stmt_=
tunnel
> +%destructor { stmt_free($$); } objref_stmt objref_stmt_counter objref_st=
mt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy objref_stmt_=
tunnel
>
>  %type <stmt>                   payload_stmt
>  %destructor { stmt_free($$); } payload_stmt
> @@ -940,9 +942,9 @@ int nft_lex(void *, void *, void *);
>  %destructor { expr_free($$); } mh_hdr_expr
>  %type <val>                    mh_hdr_field
>
> -%type <expr>                   meta_expr
> -%destructor { expr_free($$); } meta_expr
> -%type <val>                    meta_key        meta_key_qualified      m=
eta_key_unqualified    numgen_type
> +%type <expr>                   meta_expr       tunnel_expr
> +%destructor { expr_free($$); } meta_expr       tunnel_expr
> +%type <val>                    meta_key        meta_key_qualified      m=
eta_key_unqualified    numgen_type     tunnel_key
>
>  %type <expr>                   socket_expr
>  %destructor { expr_free($$); } socket_expr
> @@ -3206,6 +3208,14 @@ objref_stmt_synproxy     :       SYNPROXY        N=
AME    stmt_expr close_scope_synproxy
>                         }
>                         ;
>
> +objref_stmt_tunnel     :       TUNNEL  NAME    stmt_expr       close_sco=
pe_tunnel
> +                       {
> +                               $$ =3D objref_stmt_alloc(&@$);
> +                               $$->objref.type =3D NFT_OBJECT_TUNNEL;
> +                               $$->objref.expr =3D $3;
> +                       }
> +                       ;
> +
>  objref_stmt_ct         :       CT      TIMEOUT         SET     stmt_expr=
       close_scope_ct
>                         {
>                                 $$ =3D objref_stmt_alloc(&@$);
> @@ -3226,6 +3236,7 @@ objref_stmt               :       objref_stmt_count=
er
>                         |       objref_stmt_quota
>                         |       objref_stmt_synproxy
>                         |       objref_stmt_ct
> +                       |       objref_stmt_tunnel
>                         ;
>
>  stateful_stmt          :       counter_stmt    close_scope_counter
> @@ -3904,6 +3915,7 @@ primary_stmt_expr :       symbol_expr              =
       { $$ =3D $1; }
>                         |       boolean_expr                    { $$ =3D =
$1; }
>                         |       meta_expr                       { $$ =3D =
$1; }
>                         |       rt_expr                         { $$ =3D =
$1; }
> +                       |       tunnel_expr                     { $$ =3D =
$1; }
>                         |       ct_expr                         { $$ =3D =
$1; }
>                         |       numgen_expr                     { $$ =3D =
$1; }
>                         |       hash_expr                       { $$ =3D =
$1; }
> @@ -4381,6 +4393,7 @@ selector_expr             :       payload_expr     =
               { $$ =3D $1; }
>                         |       exthdr_expr                     { $$ =3D =
$1; }
>                         |       exthdr_exists_expr              { $$ =3D =
$1; }
>                         |       meta_expr                       { $$ =3D =
$1; }
> +                       |       tunnel_expr                     { $$ =3D =
$1; }
>                         |       socket_expr                     { $$ =3D =
$1; }
>                         |       rt_expr                         { $$ =3D =
$1; }
>                         |       ct_expr                         { $$ =3D =
$1; }
> @@ -5493,6 +5506,16 @@ socket_key               :       TRANSPARENT     {=
 $$ =3D NFT_SOCKET_TRANSPARENT; }
>                         |       WILDCARD        { $$ =3D NFT_SOCKET_WILDC=
ARD; }
>                         ;
>
> +tunnel_key             :       PATH            { $$ =3D NFT_TUNNEL_PATH;=
 }
> +                       |       ID              { $$ =3D NFT_TUNNEL_ID; }
> +                       ;
> +
> +tunnel_expr            :       TUNNEL  tunnel_key
> +                       {
> +                               $$ =3D tunnel_expr_alloc(&@$, $2);
> +                       }
> +                       ;
> +
>  offset_opt             :       /* empty */     { $$ =3D 0; }
>                         |       OFFSET  NUM     { $$ =3D $2; }
>                         ;
> diff --git a/src/scanner.l b/src/scanner.l
> index def0ac0e..9695d710 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -410,7 +410,7 @@ addrstring  ({macaddr}|{ip4addr}|{ip6addr})
>  }
>
>  "counter"              { scanner_push_start_cond(yyscanner, SCANSTATE_CO=
UNTER); return COUNTER; }
> -<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPRO=
XY,SCANSTATE_EXPR_OSF>"name"                   { return NAME; }
> +<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPRO=
XY,SCANSTATE_EXPR_OSF,SCANSTATE_TUNNEL>"name"                  { return NAM=
E; }
>  <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"              {=
 return PACKETS; }
>  <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"bytes" =
       { return BYTES; }
>
> @@ -826,6 +826,7 @@ addrstring  ({macaddr}|{ip4addr}|{ip6addr})
>         "erspan"                { return ERSPAN; }
>         "egress"                { return EGRESS; }
>         "ingress"               { return INGRESS; }
> +       "path"                  { return PATH; }
>  }
>
>  "notrack"              { return NOTRACK; }
> diff --git a/src/statement.c b/src/statement.c
> index 2bfed4ac..20241f68 100644
> --- a/src/statement.c
> +++ b/src/statement.c
> @@ -290,6 +290,7 @@ static const char *objref_type[NFT_OBJECT_MAX + 1] =
=3D {
>         [NFT_OBJECT_QUOTA]      =3D "quota",
>         [NFT_OBJECT_CT_HELPER]  =3D "ct helper",
>         [NFT_OBJECT_LIMIT]      =3D "limit",
> +       [NFT_OBJECT_TUNNEL]     =3D "tunnel",
>         [NFT_OBJECT_CT_TIMEOUT] =3D "ct timeout",
>         [NFT_OBJECT_SECMARK]    =3D "secmark",
>         [NFT_OBJECT_SYNPROXY]   =3D "synproxy",
> diff --git a/src/tunnel.c b/src/tunnel.c
> new file mode 100644
> index 00000000..cd92d039
> --- /dev/null
> +++ b/src/tunnel.c
> @@ -0,0 +1,81 @@
> +/*
> + * Copyright (c) 2018 Pablo Neira Ayuso <pablo@netfilter.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <errno.h>
> +#include <limits.h>
> +#include <stddef.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <stdbool.h>
> +#include <stdint.h>
> +#include <string.h>
> +#include <net/if.h>
> +#include <net/if_arp.h>
> +#include <pwd.h>
> +#include <grp.h>
> +#include <arpa/inet.h>
> +#include <linux/netfilter.h>
> +#include <linux/pkt_sched.h>
> +#include <linux/if_packet.h>
> +
> +#include <nftables.h>
> +#include <expression.h>
> +#include <datatype.h>
> +#include <tunnel.h>
> +#include <gmputil.h>
> +#include <utils.h>
> +#include <erec.h>
> +
> +const struct tunnel_template tunnel_templates[] =3D {
> +       [NFT_TUNNEL_PATH]       =3D META_TEMPLATE("path", &boolean_type,
> +                                               BITS_PER_BYTE, BYTEORDER_=
HOST_ENDIAN),
> +       [NFT_TUNNEL_ID]         =3D META_TEMPLATE("id",  &integer_type,
> +                                               4 * 8, BYTEORDER_HOST_END=
IAN),
> +};
> +
> +static void tunnel_expr_print(const struct expr *expr, struct output_ctx=
 *octx)
> +{
> +       uint32_t key =3D expr->tunnel.key;
> +       const char *token =3D "unknown";
> +
> +       if (key < array_size(tunnel_templates))
> +               token =3D tunnel_templates[key].token;
> +
> +       nft_print(octx, "tunnel %s", token);
> +}
> +
> +static bool tunnel_expr_cmp(const struct expr *e1, const struct expr *e2=
)
> +{
> +       return e1->tunnel.key =3D=3D e2->tunnel.key;
> +}
> +
> +static void tunnel_expr_clone(struct expr *new, const struct expr *expr)
> +{
> +       new->tunnel.key =3D expr->tunnel.key;
> +}
> +
> +const struct expr_ops tunnel_expr_ops =3D {
> +       .type           =3D EXPR_TUNNEL,
> +       .name           =3D "tunnel",
> +       .print          =3D tunnel_expr_print,
> +       .cmp            =3D tunnel_expr_cmp,
> +       .clone          =3D tunnel_expr_clone,
> +};
> +
> +struct expr *tunnel_expr_alloc(const struct location *loc,
> +                              enum nft_tunnel_keys key)
> +{
> +       const struct tunnel_template *tmpl =3D &tunnel_templates[key];
> +       struct expr *expr;
> +
> +       expr =3D expr_alloc(loc, EXPR_TUNNEL, tmpl->dtype, tmpl->byteorde=
r,
> +                         tmpl->len);
> +       expr->tunnel.key =3D key;
> +
> +       return expr;
> +}
> --
> 2.50.1
>
>

--0000000000006d36460647178abb
Content-Type: application/octet-stream; name=tunnel_object
Content-Disposition: attachment; filename=tunnel_object
Content-Transfer-Encoding: base64
Content-ID: <f_mjr7tjrz0>
X-Attachment-Id: f_mjr7tjrz0

IyEvYmluL2Jhc2gKCiMgTkZUX1RFU1RfUkVRVUlSRVMoTkZUX1RFU1RfSEFWRV90Y3BkdW1wKQoK
Iy4gJE5GVF9URVNUX0xJQlJBUllfRklMRQouIC4uLy4uL2hlbHBlcnMvbGliLnNoCgpjbGVhbnVw
KCkKewoJZm9yIGkgaW4gJEMgJFMgJFIgJEI7ZG8KCQlraWxsICQoaXAgbmV0bnMgcGlkICRpKSAy
Pi9kZXYvbnVsbAoJCWlwIG5ldG5zIGRlbCAkaQoJZG9uZQoJcm0gLXJmICRXT1JLRElSCglzeXNj
dGwgLXcgbmV0Lm5ldGZpbHRlci5uZl9sb2dfYWxsX25ldG5zPTAKfQp0cmFwIGNsZWFudXAgRVhJ
VAoKcm5kPSQobWt0ZW1wIC11IFhYWFhYWFhYKQpDPSJjbGllbnQtJHJuZCIKUz0ic2VydmVyLSRy
bmQiClI9InJvdXRlLSRybmQiCkI9ImJyaWRnZS0kcm5kIgpXT1JLRElSPSIvdG1wL3JvdXRlLXR5
cGUtY2hhaW4tJHJuZCIKCnVtYXNrIDAyMgpta2RpciAtcCAiJFdPUktESVIiCmFzc2VydF9wYXNz
ICJta2RpciAkV09SS0RJUiIKCnN5c2N0bCAtdyBuZXQubmV0ZmlsdGVyLm5mX2xvZ19hbGxfbmV0
bnM9MQoKIyAgY2xpZW50IC0tLSBicmlkZ2UgLS0tIHJvdXRlIC0tLSBicmlkZ2UgLS0tIHNlcnZl
cgojIDEwLjE2Ny42OC4xLzI0ICAgICAgIDEwLjE2Ny42OS4yNTQvMjQgICAgICAxMC4xNjcuNjku
MS8yNAoKaXAgbmV0bnMgYWRkICRDCmlwIG5ldG5zIGFkZCAkUwppcCBuZXRucyBhZGQgJFIKaXAg
bmV0bnMgYWRkICRCCgppcCAtbiAkUyBsaW5rIHNldCBsbyB1cAppcCAtbiAkQyBsaW5rIHNldCBs
byB1cAppcCAtbiAkUiBsaW5rIHNldCBsbyB1cAppcCAtbiAkQiBsaW5rIHNldCBsbyB1cAoKaXAg
bGluayBhZGQgYnJjIG5ldG5zICRCIHVwIHR5cGUgYnJpZGdlCmlwIGxpbmsgYWRkIGJycyBuZXRu
cyAkQiB1cCB0eXBlIGJyaWRnZQoKaXAgbGluayBhZGQgc19yIG5ldG5zICRTIHVwIHR5cGUgdmV0
aCBwZWVyIG5hbWUgYnJzX3MgbmV0bnMgJEIKaXAgbGluayBhZGQgY19yIG5ldG5zICRDIHVwIHR5
cGUgdmV0aCBwZWVyIG5hbWUgYnJjX2MgbmV0bnMgJEIKaXAgbGluayBhZGQgcl9zIG5ldG5zICRS
IHVwIHR5cGUgdmV0aCBwZWVyIG5hbWUgYnJzX3IgbmV0bnMgJEIKaXAgbGluayBhZGQgcl9jIG5l
dG5zICRSIHVwIHR5cGUgdmV0aCBwZWVyIG5hbWUgYnJjX3IgbmV0bnMgJEIKaXAgLW4gJEIgbGlu
ayBzZXQgYnJzX3IgbWFzdGVyIGJycyB1cAppcCAtbiAkQiBsaW5rIHNldCBicmNfciBtYXN0ZXIg
YnJjIHVwCmlwIC1uICRCIGxpbmsgc2V0IGJyc19zIG1hc3RlciBicnMgdXAKaXAgLW4gJEIgbGlu
ayBzZXQgYnJjX2MgbWFzdGVyIGJyYyB1cAoKaXBfcz0xMC4xNjcuNjkuMQppcF9jPTEwLjE2Ny42
OC4xCmlwX3JzPTEwLjE2Ny42OS4yNTQKaXBfcmM9MTAuMTY3LjY4LjI1NAoKaXAgbmV0bnMgZXhl
YyAkUyBpcCBhZGRyIGFkZCAke2lwX3N9LzI0IGRldiBzX3IKaXAgbmV0bnMgZXhlYyAkQyBpcCAt
NCBhZGRyIGFkZCAke2lwX2N9LzI0IGRldiBjX3IKaXAgbmV0bnMgZXhlYyAkUiBpcCAtNCBhZGRy
IGFkZCAke2lwX3JzfS8yNCBkZXYgcl9zCmlwIG5ldG5zIGV4ZWMgJFIgaXAgLTQgYWRkciBhZGQg
JHtpcF9yY30vMjQgZGV2IHJfYwppcCBuZXRucyBleGVjICRSIHN5c2N0bCAtdyBuZXQuaXB2NC5p
cF9mb3J3YXJkPTEKaXAgbmV0bnMgZXhlYyAkQyBpcCByb3V0ZSBhZGQgJHtpcF9ycyUyNTR9MC8y
NCB2aWEgJHtpcF9yY30gZGV2IGNfcgppcCBuZXRucyBleGVjICRTIGlwIHJvdXRlIGFkZCAke2lw
X3JjJTI1NH0wLzI0IHZpYSAke2lwX3JzfSBkZXYgc19yCgppcCBuZXRucyBleGVjICRDIHBpbmcg
MTAuMTY3LjY5LjEgLWMxCgojaXAgLW4gJFMgbGluayBhZGQgZ2VuZXZlMSB0eXBlIGdlbmV2ZSBp
ZCAxMCByZW1vdGUgMTAuMTY3LjY4LjEgZHN0cG9ydCA2MDgxCiNpcCAtbiAkQyBsaW5rIGFkZCBn
ZW5ldmUxIHR5cGUgZ2VuZXZlIGlkIDEwIHJlbW90ZSAxMC4xNjcuNjkuMSBkc3Rwb3J0IDYwODEK
I2lwIC1uICRTIGxpbmsgc2V0IGdlbmV2ZTEgdXAKI2lwIC1uICRTIGFkZHIgYWRkIDEuMS4xLjEv
MjQgZGV2IGdlbmV2ZTEKI2lwIC1uICRDIGxpbmsgc2V0IGdlbmV2ZTEgdXAKI2lwIC1uICRDIGFk
ZHIgYWRkIDEuMS4xLjIvMjQgZGV2IGdlbmV2ZTEKI2lwIG5ldG5zIGV4ZWMgJEMgcGluZyAxLjEu
MS4xIC1jMSB8fCBleGl0IDEKCmlwIC1uICRTIGxpbmsgYWRkIGdlbmV2ZTEgdHlwZSBnZW5ldmUg
ZXh0ZXJuYWwKaXAgLW4gJEMgbGluayBhZGQgZ2VuZXZlMSB0eXBlIGdlbmV2ZSBleHRlcm5hbApp
cCAtbiAkUyBsaW5rIHNldCBnZW5ldmUxIHVwCmlwIC1uICRTIGFkZHIgYWRkIDEuMS4xLjEvMjQg
ZGV2IGdlbmV2ZTEKaXAgLW4gJEMgbGluayBzZXQgZ2VuZXZlMSB1cAppcCAtbiAkQyBhZGRyIGFk
ZCAxLjEuMS4yLzI0IGRldiBnZW5ldmUxCgpTZXJ2ZXJSdWxlc2V0PSIKdGFibGUgbmV0ZGV2IHR1
bm5lbF90ZXN0IHsKCXR1bm5lbCBnZW5ldmUtdDEgewoJCWlkIDEwCgkJaXAgc2FkZHIgJHtpcF9z
fQoJCWlwIGRhZGRyICR7aXBfY30KCQlkcG9ydCA2MDgxCgkJdHRsIDg4CgkJdG9zIDAKCQlnZW5l
dmUgewoJCQljbGFzcyAweDEgICAgb3B0LXR5cGUgMHgxIGRhdGEgXCIweDEyMzQ1Njc4XCIKCQkJ
Y2xhc3MgMHgxMDEwIG9wdC10eXBlIDB4MiBkYXRhIFwiMHg4NzY1NDMyMVwiCgkJCWNsYXNzIDB4
MjAyMCBvcHQtdHlwZSAweDMgZGF0YSBcIjB4ODc2NTQzMjFhYmNkZWZmZVwiCgkJfQoJCgl9Cglj
aGFpbiBlZ3Jlc3MgewoJCXR5cGUgZmlsdGVyIGhvb2sgZWdyZXNzIGRldmljZSBzX3IgcHJpb3Jp
dHkgMDsgcG9saWN5IGFjY2VwdDsJCgkJY291bnRlciB0dW5uZWwgbmFtZSBnZW5ldmUtdDEgZndk
IHRvIGdlbmV2ZTEKCX0KfQoiCkNsaWVudFJ1bGVzZXQ9Igp0YWJsZSBuZXRkZXYgdHVubmVsX3Rl
c3QgewoJdHVubmVsIGdlbmV2ZS10MSB7CgkJaWQgMTAKCQlpcCBzYWRkciAke2lwX2N9CgkJaXAg
ZGFkZHIgJHtpcF9zfQoJCWRwb3J0IDYwODEKCQl0dGwgODgKCQl0b3MgMAoJCWdlbmV2ZSB7CgkJ
CWNsYXNzIDB4MSAgICBvcHQtdHlwZSAweDEgZGF0YSBcIjB4MTIzNDU2NzhcIgoJCQljbGFzcyAw
eDEwMTAgb3B0LXR5cGUgMHgyIGRhdGEgXCIweDg3NjU0MzIxXCIKCQkJY2xhc3MgMHgyMDIwIG9w
dC10eXBlIDB4MyBkYXRhIFwiMHg4NzY1NDMyMWFiY2RlZmZlXCIKCQl9CgkKCX0KCWNoYWluIGVn
cmVzcyB7CgkJdHlwZSBmaWx0ZXIgaG9vayBlZ3Jlc3MgZGV2aWNlIGNfciBwcmlvcml0eSAwOyBw
b2xpY3kgYWNjZXB0OwkKCQljb3VudGVyIHR1bm5lbCBuYW1lIGdlbmV2ZS10MSBmd2QgdG8gZ2Vu
ZXZlMQoJfQp9CiIKCmlwIG5ldG5zIGV4ZWMgJFMgbmZ0IC1mIC0gPDw8IiR7U2VydmVyUnVsZXNl
dH0iCmlwIG5ldG5zIGV4ZWMgJEMgbmZ0IC1mIC0gPDw8IiR7Q2xpZW50UnVsZXNldH0iCmlwIG5l
dG5zIGV4ZWMgJEMgdGNwZHVtcCAtLWltbWVkaWF0ZS1tb2RlIC1ubmkgY19yIC13IGdlbmV2ZS5w
Y2FwICYgIHBpZD0kIQojaXAgbmV0bnMgZXhlYyAkQyBhcnBpbmcgMS4xLjEuMSAKaXAgbmV0bnMg
ZXhlYyAkQyBwaW5nIDEuMS4xLjEgCmtpbGwgJHBpZDsgc2xlZXAgMC4yCnRjcGR1bXAgLW5uciBn
ZW5ldmUucGNhcCBnZW5ldmUKCmlwIG5ldG5zIGV4ZWMgJEMgaXAgLWQgbGluayBzaG93IGdlbmV2
ZTEKaXAgbmV0bnMgZXhlYyAkQyBuZnQgbGlzdCBydWxlc2V0Cg==
--0000000000006d36460647178abb--


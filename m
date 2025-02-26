Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED36C26773B
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2025 06:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740551856; cv=none; b=g7+bM1D0em9aGBtJInwj/A0EXa7YS0O+Nbt3Pf91j+PNDi1WJoPc8/4RUZBPU9WvHkxnLvMipHASdef9dma6Z0WynAe33O53YV7BWFZidDFKdJlfl5HEoTgw6RgkIlPHQHbghJxlhSNVb2+0v6Kwx+9e6d8NdFO8+C2FU1az6qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740551856; c=relaxed/simple;
	bh=lkTuLuczT0O92/0WTk3hbfX/h7x3DBVglemZBS1HxoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XCFBNAXeqJnctVJiHdI+2LzgQ4hiw0Q+9glPmvrvnfO6rCWfBjiR+CSJX8B83IEG2rp0qPWWVuJ7cZ9C88jG+Cuij3ZvB4nfyI9RiMCJDfVev7VkY1SR03nrgtADNvo0s1ddfqJ3QaeGXvU2hsfd8JrJUQuGTiGnUfIh8tLlEV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LDQD2JPW; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LDQD2JPW"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43948f77f1aso39488825e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 22:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740551853; x=1741156653; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TyNNbIK61cHYBw3j7+C3OAVBe4vRKwxQKHunqu8wKfY=;
        b=LDQD2JPWGC7NjRQDO9y1WPhrmZtTxjjMdx28xnz2orpuRfT6ROAz19DBRaGti7mH0r
         0ObU7q35PHBb5VO69hpnkzM7NOBhZ1NAZ+UT0CD1ogFdSufBmRZreOcuLGVAt6da3oeH
         5PKzomZLC7/3XvB1B5mvlp/W/u40pUUaXzYsEyXCBCdxa6QaSPyysA/WmbDAb8Fbh6lA
         3wvzUX9fH4Au/GWzQAZdx9MOMifkEkc/x4XOGgjO0bn2p6xS4Ux1Hqzse4dGh+5Rc0R/
         TdIiC2f6EzcIb62cpMunQDy8vLhkGTufr90JIVgiIvjj7Xfw0JUFJ9Y9XkbtBKSPb1Co
         c+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740551853; x=1741156653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TyNNbIK61cHYBw3j7+C3OAVBe4vRKwxQKHunqu8wKfY=;
        b=GvNJaZqHBZ64+qvh8ioMwYG9Hqga7AU8yaVMWh0LuHJOpWuXjg2YelC0/2E6MqK/Ui
         zNpe8mphQycdSSD4Z8iXcP/4n2XCbYgMLhxNTrYToG0NE0RdAAiyBgIlg4O9S7N3lCOf
         8DA+wBf+jGWkeEzmJ/H+9tO2xidTBstUfZCEeKBUdPo2Vxuf+miveQFmV0jXWIWcn0MI
         E0QW6B/UJk3Q3hJF2mQmhvExbZ4DZW+iOq9tTptQuJ/6tNwgZSJiHoiIf4BxQD3PjizL
         i6VXAuNoGqEhxHzy6XaPQwjzGrCFI9wMDHwq8ZrNtxHCFKBDKwat3L8Nmqm4z2JTmXu6
         KBLw==
X-Gm-Message-State: AOJu0YwfarAxKP0ybMJrzB92tCz4UBf55A5Rop31rXI1kNtSZKalIViS
	9++DJJXWRvrqQa9yboWwHfiDCpAMrrv4ifgcJwHkgtfMlSwFddwEs8d7BGNewQdoWU6dZRuqWwN
	1xoUF90/wxDBntUCOCRWNZeoFOjKin4DpSWQ=
X-Gm-Gg: ASbGncuqMM9oSYXM55kaLyWy0PUBvOijYiFF+O7IrERqvH/b9ClfxbXOqggFghFl+hX
	M/aWxrkhsbnS2h090QgcIxuSZmT9E8v1lmqElVPzEmNw+SbwGZPtqaujrkIIFmkoL2Yi/GtjCY4
	dh5RfthQ==
X-Google-Smtp-Source: AGHT+IGpf2tGMqzvllEIm90ExVT252WBp8CyKHG2ZFoVRZeJVbs7oE+3OtSyWPawRBqNOOl+BiO/Yk2CWlxZYCnKCzM=
X-Received: by 2002:a05:600c:4fcc:b0:439:9ac3:a8b3 with SMTP id
 5b1f17b1804b1-43ab0f426d2mr53073555e9.18.1740551852998; Tue, 25 Feb 2025
 22:37:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250225100319.18978-1-shaw.leon@gmail.com> <Z74pePZKnP1QcJBm@strlen.de>
In-Reply-To: <Z74pePZKnP1QcJBm@strlen.de>
From: Xiao Liang <shaw.leon@gmail.com>
Date: Wed, 26 Feb 2025 14:36:56 +0800
X-Gm-Features: AQ5f1JolQxOZt8yndI_TplOSKqUuVPvTwlQXl3Oxf87yU0CKlzAcVdUJ4vQneLg
Message-ID: <CABAhCORJmkJ=W17LM8m+Qtif2LuQmb-Jm2jAQqOg_xtwtgk3mw@mail.gmail.com>
Subject: Re: [RFC PATCH nft] payload: Don't kill dependency for proto_th
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2025 at 4:38=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Xiao Liang <shaw.leon@gmail.com> wrote:
> > Since proto_th carries no information about the proto number, we need t=
o
> > preserve the L4 protocol expression.
> >
> > For example, if "meta l4proto 91 @th,0,16 0" is simplified to
> > "th sport 0", the information of protocol number is lost. This patch
> > changes it to "meta l4proto 91 th sport 0".
> >
> > Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
> > ---
> >
> > Technically, if port is not defined for the L4 protocol, it's better to
> > keep "@th,0,16" as raw payload expressions rather than "th sport". But
> > it's not easy to figure out the context.
>
> Yes, this is also because we don't store dependencies like
> 'meta l4proto { tcp, udp }', so we don't have access to this info when
> we see the @th,0,16 load.
>
> What do you make of this (it will display @th syntax for your test case)?

Looks good. I think this can cover most of the use cases. We don't
usually mix protocols when matching L4 header fields other than ports.
Thanks!

>
> diff --git a/src/payload.c b/src/payload.c
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -851,6 +851,58 @@ static bool payload_may_dependency_kill_ll(struct pa=
yload_dep_ctx *ctx, struct e
>         return true;
>  }
>
> +static bool l4proto_has_ports(struct payload_dep_ctx *ctx, struct expr *=
expr)
> +{
> +       uint8_t v;
> +
> +       assert(expr->etype =3D=3D EXPR_VALUE);
> +
> +       if (expr->len !=3D 8)
> +               return false;
> +
> +       v =3D mpz_get_uint8(expr->value);
> +
> +       switch (v) {
> +       case IPPROTO_UDPLITE:
> +       case IPPROTO_UDP:
> +       case IPPROTO_TCP:
> +       case IPPROTO_DCCP:
> +       case IPPROTO_SCTP:
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +static bool payload_may_dependency_kill_th(struct payload_dep_ctx *ctx, =
struct expr *expr)
> +{
> +       struct expr *dep =3D payload_dependency_get(ctx, expr->payload.ba=
se);
> +       enum proto_bases b;
> +
> +       switch (dep->left->etype) {
> +       case EXPR_PAYLOAD:
> +               b =3D dep->left->payload.base;
> +               break;
> +       case EXPR_META:
> +               b =3D dep->left->meta.base;
> +               break;
> +       default:
> +               return false;
> +       }
> +
> +       if (b !=3D PROTO_BASE_NETWORK_HDR)
> +               return false;
> +
> +       switch (dep->right->etype) {
> +       case EXPR_VALUE:
> +               return l4proto_has_ports(ctx, dep->right);
> +       default:
> +               break;
> +       }
> +
> +       return false;
> +}
> +
>  static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
>                                         unsigned int family, struct expr =
*expr)
>  {
> @@ -893,6 +945,15 @@ static bool payload_may_dependency_kill(struct paylo=
ad_dep_ctx *ctx,
>         if (expr->payload.base !=3D PROTO_BASE_TRANSPORT_HDR)
>                 return true;
>
> +       if (expr->payload.desc =3D=3D &proto_th) {
> +               if (payload_may_dependency_kill_th(ctx, expr))
> +                       return true;
> +
> +               /* prefer @th syntax, we don't have a 'source/destination=
 port' protocol */
> +               expr->payload.desc =3D &proto_unknown;
> +               return false;
> +       }
> +
>         if (dep->left->etype !=3D EXPR_PAYLOAD ||
>             dep->left->payload.base !=3D PROTO_BASE_TRANSPORT_HDR)
>                 return true;
>
>
> It would make sense to NOT set &proto_th from payload_init_raw(), but
> that would place significant burden on netlink_delinearize to
> pretty-print the typical use case for this, i.e.
>
> 'meta l4proto { tcp, udp } th dport 53 accept'
>

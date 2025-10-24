Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EB52DD5EF
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 12:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761309250; cv=none; b=FdGF5PDVcBBY4ZjoLX3P6z6Na8Yc5RJLfl5IpLpIOu3Bp3AAZr7BOoUJzPOGQNSLw2o6Zo0aXfTMr2fsmn0WBGn4c8BkHXj9wa1NYvEhk+ajF/KHa9hc5wU8Jso3MF/wUaykXz3IN260aG7UawFJ3lz8j4tNhdXp0shIlGXqEus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761309250; c=relaxed/simple;
	bh=Fl6+g5HE7tA1OWtEYqMAO0086s4V8ObeEQbX3BxYvU0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PybDMJcd2N+aRGVHu7ZpElcu1fq9e95N5N9HVk3pHvx1tKEU/xCmXlDHBXdv3bNnuiCicZrwha+0u+WhNa1GucYHyizEA3RfqDRGUOyY0kGVEz+/Q8cz9JzCDFBB1IfhByeiOCBjqQIuJ3AibY1HpDxWcsMVmZ2fcigEhTEuv4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mI/WsFNy; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mI/WsFNy"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42701b29a7eso1075928f8f.0
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 05:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761309246; x=1761914046; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdghwH5uAcedHHnQs+2RqJgItj83yqKgWfnnr8RKQ0g=;
        b=mI/WsFNyDIi1YpKkRBkI6y1DQYKy0C3MtL+3gU9Yz8JIecVXyHU4b74TIEwd6ddlJJ
         N6XtOEwdRC+OXj3ZCgbvgPM3Q/Ok5Fu263FsF87/6DCwlvZamc7VLEo2i7io/5NuTt29
         ZUOaUu+LcqScNkmKdWSqLrLmDIp74spfxiD2vIyGWR3wb7ph8Vn89uYR6Dq/EKQBvkUL
         XwdLwRVARgdzdH6d7nQbPd7l2TzlCg7UNbjo8qTbYnCekK8UB9x9GLEh1OWFugqNYqud
         PVhCpdu88JJPwRF4s+qgl1gyNygl9sVvEuOejAJGTwCHJBqzlbThX0Mq9vfp7ieSVgaE
         ZtnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761309246; x=1761914046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pdghwH5uAcedHHnQs+2RqJgItj83yqKgWfnnr8RKQ0g=;
        b=IVWoa2FcBX266mf5iJwpi+uD3OeEkUxq4jtR+oyEnqQGLPpbqZyyn5NKyVoa5mk7O7
         jKaIwheHcTmjxJw8lLu9CtfUVQo9fDUbS8lR2fJVGxXo5jvU/D79yijCSG5ECE1FaeVK
         eF0aNbSyu4P4Y774gTcHXHEBAbRKBBUP9BlaJ/6Xio/YFhY81oRa77VHwHk1uKA1Nruc
         8kt7iRbOxpPKhQR1fSlgf3DWInRMAIQt/r2x6f3WoQaNESJktOoVZYs6U2f5pNfZzjA4
         j5O+T3N28ZNNPojc0+dG9QcQUOO1MMGG86SzGB07hYJJ40FcjV8YsYH/t0Q/R9ci006S
         t5eA==
X-Gm-Message-State: AOJu0Yx3Rpzt1RCigVBdXxlr3qr3oN8bxZvqgN86r7gOZVkqs5pa29II
	yI8WXi8IDD/HwFC6UGWfg56YuR2EW8IjO9C3EaKYEwJGBoJ/vL4X8oB0TOPBhIn4NfZ8HMooDOb
	+R88s0ayct7B0UEQk+tehQkGBQzS+O2E/6IhFhsgjhYrOEIq4xVIEEFCV5QA=
X-Gm-Gg: ASbGncufp6OLmU3G3+xkRMvFTEIh1bmg4N5MyBQWmGlNkNROhHW0It7MQhdB8WAY8u7
	Ghb1lCMI5kODW2b6RZ2yJqEqU2ugQwv8tbqTLYhFd94gAhiEtyid4tQ+Gvb9CLUc2mVMeD/2I5w
	5qHAfnstS2o2ceNh9QXVzVA5xhor6R46E02cPQmWEaTtH/AD3vAwpi4rJK/WZhGmMsvFLzwfKZd
	UXrHBlFL5G2V4IxOhuigy1qosXSuWFPdYpL5FcLuD//nSQWWqNHKBY+9dLv8wuXR8/DHQ==
X-Google-Smtp-Source: AGHT+IEnd8X2Bx7q+DGvdfKQjUMA3w56PfIPUveA1uGdAn3fedRH7BLUXHl+t1yfKmbtBThs3i8vj2cRNSkHd7l2VME=
X-Received: by 2002:a05:6000:4313:b0:401:2cbf:ccad with SMTP id
 ffacd0b85a97d-4298f582465mr2488844f8f.17.1761309245806; Fri, 24 Oct 2025
 05:34:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251023120922.2847-1-fw@strlen.de>
In-Reply-To: <20251023120922.2847-1-fw@strlen.de>
From: Antonio Ojea <aojea@google.com>
Date: Fri, 24 Oct 2025 14:33:53 +0200
X-Gm-Features: AWmQ_bneM87YLf8qhghVurIjPkoQsOaStx0cVxCkBz7DOY_h8tesAoR01r5F-xE
Message-ID: <CAAdXToT6ZfaP3oxuYdVK9PWwWwuyHeaRuJdOX9sXoVenhtnAmg@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_ct: enable labels for get case too
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 2:09=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> conntrack labels can only be set when the conntrack has been created
> with the "ctlabel" extension.
>
> For older iptables (connlabel match), adding an "-m connlabel" rule
> turns on the ctlabel extension allocation for all future conntrack
> entries.
>
> For nftables, its only enabled for 'ct label set foo', but not for
> 'ct label foo' (i.e. check).
> But users could have a ruleset that only checks for presence, and rely
> on userspace to set a label bit via ctnetlink infrastructure.
>
> This doesn't work without adding a dummy 'ct label set' rule.
> We could also enable extension infra for the first (failing) ctnetlink
> request, but unlike ruleset we would not be able to disable the
> extension again.
>
> Therefore turn on ctlabel extension allocation if an nftables ruleset
> checks for a connlabel too.
>
> Fixes: 1ad8f48df6f6 ("netfilter: nftables: add connlabel set support")
> Reported-by: Antonio Ojea <aojea@google.com>
> Closes: https://lore.kernel.org/netfilter-devel/aPi_VdZpVjWujZ29@strlen.d=
e/
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_ct.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index d526e69a2a2b..a418eb3d612b 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -379,6 +379,14 @@ static bool nft_ct_tmpl_alloc_pcpu(void)
>  }
>  #endif
>
> +static void __nft_ct_get_destroy(const struct nft_ctx *ctx, struct nft_c=
t *priv)
> +{
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +       if (priv->key =3D=3D NFT_CT_LABELS)
> +               nf_connlabels_put(ctx->net);
> +#endif
> +}
> +
>  static int nft_ct_get_init(const struct nft_ctx *ctx,
>                            const struct nft_expr *expr,
>                            const struct nlattr * const tb[])
> @@ -413,6 +421,10 @@ static int nft_ct_get_init(const struct nft_ctx *ctx=
,
>                 if (tb[NFTA_CT_DIRECTION] !=3D NULL)
>                         return -EINVAL;
>                 len =3D NF_CT_LABELS_MAX_SIZE;
> +
> +               err =3D nf_connlabels_get(ctx->net, (len * BITS_PER_BYTE)=
 - 1);
> +               if (err)
> +                       return err;
>                 break;
>  #endif
>         case NFT_CT_HELPER:
> @@ -494,7 +506,8 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
>                 case IP_CT_DIR_REPLY:
>                         break;
>                 default:
> -                       return -EINVAL;
> +                       err =3D -EINVAL;
> +                       goto err;
>                 }
>         }
>
> @@ -502,11 +515,11 @@ static int nft_ct_get_init(const struct nft_ctx *ct=
x,
>         err =3D nft_parse_register_store(ctx, tb[NFTA_CT_DREG], &priv->dr=
eg, NULL,
>                                        NFT_DATA_VALUE, len);
>         if (err < 0)
> -               return err;
> +               goto err;
>
>         err =3D nf_ct_netns_get(ctx->net, ctx->family);
>         if (err < 0)
> -               return err;
> +               goto err;
>
>         if (priv->key =3D=3D NFT_CT_BYTES ||
>             priv->key =3D=3D NFT_CT_PKTS  ||
> @@ -514,6 +527,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
>                 nf_ct_set_acct(ctx->net, true);
>
>         return 0;
> +err:
> +       __nft_ct_get_destroy(ctx, priv);
> +       return err;
>  }
>
>  static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_c=
t *priv)
> @@ -626,6 +642,9 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
>  static void nft_ct_get_destroy(const struct nft_ctx *ctx,
>                                const struct nft_expr *expr)
>  {
> +       struct nft_ct *priv =3D nft_expr_priv(expr);
> +
> +       __nft_ct_get_destroy(ctx, priv);
>         nf_ct_netns_put(ctx->net, ctx->family);
>  }
>
> --
> 2.51.0
>

Hi Florian, I'm trying to add a kselftest but it seems the conntrack
tool fails to add the label if the /etc/xtables/connlabel.conf file
does not exist. This is the behavior I'm observing:
- conntrack -U:
  - fails if the file does not exist
  - works if the file exists, but if the entry does not exist in the
file the tool throws an error but the label is added
- conntrack -L -o label
  - does not output the label if the file does not exist or is empty.
  - if the file exists and the ct entry label exists in the file, then
it's correctly displayed in conntrack -L
  - if the file exists but  the label is not present in the file, the
output has a labels statement but is empty

Can you give me advice on how to proceed?

bind(3, {sa_family=3DAF_NETLINK, nl_pid=3D0, nl_groups=3D00000000}, 12) =3D=
 0
getsockname(3, {sa_family=3DAF_NETLINK, nl_pid=3D16788,
nl_groups=3D00000000}, [12]) =3D 0
openat(AT_FDCWD, "/etc/xtables/connlabel.conf", O_RDONLY|O_CLOEXEC) =3D
-1 ENOENT (No such file or directory)
dup(2)                                  =3D 4
fcntl(4, F_GETFL)                       =3D 0x8002 (flags O_RDWR|O_LARGEFIL=
E)
newfstatat(4, "", {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(0x88, 0x1),
...}, AT_EMPTY_PATH) =3D 0
write(4, "nfct_labelmap_new: No such file "..., 45nfct_labelmap_new:
No such file or directory
) =3D 45

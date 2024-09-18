Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4391F16B
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726667245; cv=none; b=RsnJwm3jQBOsASMAHN+LuLav1vFZJVcU9lBR2YKL7TzDAsbXhFKbKKQyg6sXmR2VRScpmmjiFJevDZRjfUANwUM96J+UQRjr84v40G9Bo3Pnxrx+WW6ba74j6Fj4cjtI5yS8lV2aP5pYltxY8oTnFjfiwRcLW2YEjyUyMsgJbf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726667245; c=relaxed/simple;
	bh=wBJiiBDkYN7RR/ucEUBlCbA5XUXx5DgJPkxq5pbg8ZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e3zUXF3o7iGaz5XcIPj9e1H59mvPdYc1ZNPlDSphCqpeXQpRoD0Z/1luJvpoVrasPX9XnwdGm4nUnW6lDF926Km7A7kl3yvhFWO8XTfxSei0Lf1H+FmLziW4Wvi009FoDKxlzRkUZCQJiFL5BYER5VhZE+EGa/myYj1TKsYebM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xLLduLoN; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xLLduLoN"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-374c180d123so3375652f8f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 06:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726667242; x=1727272042; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8d+xc2SanYd80RBFAUMl73cHT9gh8TB6ELWZ+yhcah8=;
        b=xLLduLoN4XrwzMXlt0JVs70P1E4ODmcOdzEatU0fIWb6Mlv0GvcnIveZ3wLQqfzYQ4
         z0OUMSVXe4+8MFsnETBwJ5QzrmVDT5m1SXtdnYw6ftR5vYf9VXl9zosfIO2UytApOnc/
         pTULtAXAbS4UJXfFTwIPBpVsSnOBTRsKOpBy8Xx+EwU70U20YTAqBVx44Hs1GWLIhZAA
         qTqLr1KTZTGrO+0pyS7T9oHa+zJ8r74qqFP0Vg2GVAddJum0Nxzu17XCtjBSG/UUl4Tu
         lbg8dOoKkyMGNsvbNgfR6blWlhOdjBi4ybM84qVXhUI3DitnHqwnC00043ov3m8QJSKx
         YRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726667242; x=1727272042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8d+xc2SanYd80RBFAUMl73cHT9gh8TB6ELWZ+yhcah8=;
        b=Bgjj+fC+5TtNb4dHfQJQ1uXhJmVNoogn9RSgejXJefNsmXFSqBGQlTyyKpovRy5GiS
         LipmRdfIcwAwqJe2GUMvQNXs/bGLbpu8XJwHkKAxnA9eR3OETdaXvF4mGfdVxxStFb8c
         BvdW1E4mZTeSsr7yi9u0l+jQLifUXITOYnzGmM8FQ9Nes9+GiAbkiOoAlpOii9f895sH
         K6qAvhZ9kKDxIGiLBnUJpkeI8J0kj3oXF+i7OauAlCmZ+3m0tv0P1qhFcCQcsIgyT8S8
         ZkvLsUqo+0s7Jaas8b4xZKepCkFT8uKjTa0vqk5vzXlEB28Gckse5+lmXuFurZ0hxIMq
         q2ag==
X-Gm-Message-State: AOJu0YzNzcvKwzMz8s0MuSsQ6kvsHqhLz+RMGZcs7rPPWtq5IHvZfx7L
	GocOeseccb1h5jPUceJjGDve+EwM+AOdCxV4UlLW7rfZ8Ky4bD1m08Yh5OvxkvgUTSPdilMT5YB
	S0O8EsE1OvA6QK5DlSPfl+BGp/mVG84F5ol+v1nhbrI1shj1sViEy
X-Google-Smtp-Source: AGHT+IHznWrOZtMgPYvn1+cKCg6+EJD5Mwb6oAIuYY1O9290jO4sDBLLP+4y2LodF9sKbZGMStIwJvD6YNYJn5bbjDs=
X-Received: by 2002:a5d:66c4:0:b0:371:8845:a3af with SMTP id
 ffacd0b85a97d-378d623b7d4mr11081857f8f.39.1726667241552; Wed, 18 Sep 2024
 06:47:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240918131342.9588-1-fw@strlen.de>
In-Reply-To: <20240918131342.9588-1-fw@strlen.de>
From: Antonio Ojea <aojea@google.com>
Date: Wed, 18 Sep 2024 14:47:07 +0100
Message-ID: <CAAdXToS9z6uZjGu0ZbyLaORxqnhJ5CY5ZKr_a=0NTctB0a9KxQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: remove old clash
 resolution logic
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2024 at 2:35=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> For historical reasons there are two clash resolution spots in
> netfilter, one in nfnetlink_queue and one in conntrack core.
>
> nfnetlink_queue one was added first: If a colliding entry is found, NAT
> NAT transformation is reversed by calling nat engine again with altered
> tuple.
>
> See commit 368982cd7d1b ("netfilter: nfnetlink_queue: resolve clash for
> unconfirmed conntracks") for details.
>
> One problem is that nf_reroute() won't take an action if the queueing
> doesn't occur in the OUTPUT hook, i.e. when queueing in forward or
> postrouting, packet will be sent via the wrong path.
>
> Another problem is that the scenario addressed (2nd UDP packet sent with
> identical addresses while first packet is still being processed) can also
> occur without any nfqueue involvement due to threaded resolvers doing
> A and AAAA requests back-to-back.
>
> This lead us to add clash resolution logic to the conntrack core, see
> commit 6a757c07e51f ("netfilter: conntrack: allow insertion of clashing
> entries").  Instead of fixing the nfqueue based logic, lets remove it
> and let conntrack core handle this instead.
>
> Retain the ->update hook for sake of nfqueue based conntrack helpers.
> We could axe this hook completely but we'd have to split confirm and
> helper logic again, see commit ee04805ff54a ("netfilter: conntrack: make
> conntrack userspace helpers work again").
>
> This SHOULD NOT be backported to kernels earlier than v5.6; they lack
> adequate clash resolution handling.
>
> Patch was originally written by Pablo Neira Ayuso.
>
> Reported-by: Antonio Ojea <aojea@google.com>
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=3D1766
> Signed-off-by: Florian Westphal <fw@strlen.de>

Tested-by: Antonio Ojea <aojea@google.com>

> ---
>  include/linux/netfilter.h         |  4 --
>  net/netfilter/nf_conntrack_core.c | 85 -------------------------------
>  net/netfilter/nf_nat_core.c       |  1 -
>  3 files changed, 90 deletions(-)
>
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index 2683b2b77612..2b8aac2c70ad 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -376,15 +376,11 @@ int nf_route(struct net *net, struct dst_entry **ds=
t, struct flowi *fl,
>  struct nf_conn;
>  enum nf_nat_manip_type;
>  struct nlattr;
> -enum ip_conntrack_dir;
>
>  struct nf_nat_hook {
>         int (*parse_nat_setup)(struct nf_conn *ct, enum nf_nat_manip_type=
 manip,
>                                const struct nlattr *attr);
>         void (*decode_session)(struct sk_buff *skb, struct flowi *fl);
> -       unsigned int (*manip_pkt)(struct sk_buff *skb, struct nf_conn *ct=
,
> -                                 enum nf_nat_manip_type mtype,
> -                                 enum ip_conntrack_dir dir);
>         void (*remove_nat_bysrc)(struct nf_conn *ct);
>  };
>
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntra=
ck_core.c
> index d3cb53b008f5..b254f24a6b0e 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -2151,80 +2151,6 @@ static void nf_conntrack_attach(struct sk_buff *ns=
kb, const struct sk_buff *skb)
>         nf_conntrack_get(skb_nfct(nskb));
>  }
>
> -static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
> -                                struct nf_conn *ct,
> -                                enum ip_conntrack_info ctinfo)
> -{
> -       const struct nf_nat_hook *nat_hook;
> -       struct nf_conntrack_tuple_hash *h;
> -       struct nf_conntrack_tuple tuple;
> -       unsigned int status;
> -       int dataoff;
> -       u16 l3num;
> -       u8 l4num;
> -
> -       l3num =3D nf_ct_l3num(ct);
> -
> -       dataoff =3D get_l4proto(skb, skb_network_offset(skb), l3num, &l4n=
um);
> -       if (dataoff <=3D 0)
> -               return NF_DROP;
> -
> -       if (!nf_ct_get_tuple(skb, skb_network_offset(skb), dataoff, l3num=
,
> -                            l4num, net, &tuple))
> -               return NF_DROP;
> -
> -       if (ct->status & IPS_SRC_NAT) {
> -               memcpy(tuple.src.u3.all,
> -                      ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.all=
,
> -                      sizeof(tuple.src.u3.all));
> -               tuple.src.u.all =3D
> -                       ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all=
;
> -       }
> -
> -       if (ct->status & IPS_DST_NAT) {
> -               memcpy(tuple.dst.u3.all,
> -                      ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.all=
,
> -                      sizeof(tuple.dst.u3.all));
> -               tuple.dst.u.all =3D
> -                       ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.all=
;
> -       }
> -
> -       h =3D nf_conntrack_find_get(net, nf_ct_zone(ct), &tuple);
> -       if (!h)
> -               return NF_ACCEPT;
> -
> -       /* Store status bits of the conntrack that is clashing to re-do N=
AT
> -        * mangling according to what it has been done already to this pa=
cket.
> -        */
> -       status =3D ct->status;
> -
> -       nf_ct_put(ct);
> -       ct =3D nf_ct_tuplehash_to_ctrack(h);
> -       nf_ct_set(skb, ct, ctinfo);
> -
> -       nat_hook =3D rcu_dereference(nf_nat_hook);
> -       if (!nat_hook)
> -               return NF_ACCEPT;
> -
> -       if (status & IPS_SRC_NAT) {
> -               unsigned int verdict =3D nat_hook->manip_pkt(skb, ct,
> -                                                          NF_NAT_MANIP_S=
RC,
> -                                                          IP_CT_DIR_ORIG=
INAL);
> -               if (verdict !=3D NF_ACCEPT)
> -                       return verdict;
> -       }
> -
> -       if (status & IPS_DST_NAT) {
> -               unsigned int verdict =3D nat_hook->manip_pkt(skb, ct,
> -                                                          NF_NAT_MANIP_D=
ST,
> -                                                          IP_CT_DIR_ORIG=
INAL);
> -               if (verdict !=3D NF_ACCEPT)
> -                       return verdict;
> -       }
> -
> -       return NF_ACCEPT;
> -}
> -
>  /* This packet is coming from userspace via nf_queue, complete the packe=
t
>   * processing after the helper invocation in nf_confirm().
>   */
> @@ -2288,17 +2214,6 @@ static int nf_conntrack_update(struct net *net, st=
ruct sk_buff *skb)
>         if (!ct)
>                 return NF_ACCEPT;
>
> -       if (!nf_ct_is_confirmed(ct)) {
> -               int ret =3D __nf_conntrack_update(net, skb, ct, ctinfo);
> -
> -               if (ret !=3D NF_ACCEPT)
> -                       return ret;
> -
> -               ct =3D nf_ct_get(skb, &ctinfo);
> -               if (!ct)
> -                       return NF_ACCEPT;
> -       }
> -
>         return nf_confirm_cthelper(skb, ct, ctinfo);
>  }
>
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 6d8da6dddf99..ffea651afa9c 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -1208,7 +1208,6 @@ static const struct nf_nat_hook nat_hook =3D {
>  #ifdef CONFIG_XFRM
>         .decode_session         =3D __nf_nat_decode_session,
>  #endif
> -       .manip_pkt              =3D nf_nat_manip_pkt,
>         .remove_nat_bysrc       =3D nf_nat_cleanup_conntrack,
>  };
>
> --
> 2.44.2
>

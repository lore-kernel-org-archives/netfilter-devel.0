Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA87E1632E6
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Nov 2024 10:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730629610; cv=none; b=RxA0vAHFXWrmugqatHRYUvpImIItn63OfyJ3CCZsdEiEAJuYotk4am7h02HEmgjLREtlAy9WePusKeKts/Vq0usBtzRpKJLXPe3n9x0Ioe42jte9uj97NZGz7IPfWNkEtrpzPr2vaE4e7vrRTAk7QA4xfjzOle0B0PKnZOiSUbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730629610; c=relaxed/simple;
	bh=QUmUiueTyLgkWorH9TuvJu3oFeZGfHnq+OYy46EADT4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aOx56Ji0ChQ66qyp6m68n1+MAJJVPhRd6/PPC+s/NaIRQK/t2uWg8EoG1dzFOs0K9hAsvOiC9DjcuZUB+zqdqnDvGpy/+Iv1EittBVoZyV/rdXsGnpcsvEj8VM9JizoNvbFBWCitvCO/Hj0TDUztUJ8YQ8F3KrbapS0sfRTpsg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GpeO05u7; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GpeO05u7"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e30eca40c44so2771543276.2
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Nov 2024 02:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730629608; x=1731234408; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EasSarsLrqHBu3iO5TQx8bLTVVIDAwHfCyzDu3AhM0s=;
        b=GpeO05u7SSSTsM0f6oCFWxsBUHjzJSRaDy+d6Zib24ad7vai5flUlJbEHJjC3u1KVw
         3qEsskXz4Fnv2/Vxh2e5InH227ab2nQMoH/BT1AgjZBmIObf0KSA5WZGO5783ajD5h5m
         whA28cP3clj677eAV0UKN8gNr7m+lSyKVt6xzZw2QR92IjlVYnRMDJaHInN2XXj8rHs+
         mPzDYFjXq7B8UHkM7unM406J/s2JQC4CKC4C/xVgv1fDj92xg/mpnq91Tp0K5Ykg8hbB
         TBER7gvIroPE0w4VfNGgpKhM8U0RQb3wgo7jYihb471+X3ha2WiM+MAoT1Yl8/Xrdpjv
         aVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730629608; x=1731234408;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EasSarsLrqHBu3iO5TQx8bLTVVIDAwHfCyzDu3AhM0s=;
        b=exs/Xt5eSiclZNucS2O9X809d9o0OeSDqoLSwb1/1m+wgP96wvs69cuMZ+DzByrS0P
         iSuu9AwSKa9nxsE8VvfxExg9Na43pBRR3RshfmNEHLzRK4k2/UZRSsSuVqqvaVKWCmJT
         PrMTE0NP5rwyIXnJsMbJxZcFQxHA6ZNLDf/XbQqGK5IaEXZdyEAJoPFzoNzrXjL5Nuqs
         3NPOybbxW2eLRK2JUK4xDNl3YLEqhzAgO8Z6EP7ASHsmljuhQ6ROQFcAEYofc3Di5Vfs
         6Tca6AZKdw/ATDBfWg5pkH9RqJzxKZjiH+zXldP38JAkBta5V9Xhy3/orGzHHx0I4mXY
         o0mg==
X-Gm-Message-State: AOJu0YyzCfKACqu7+vhKcCJLdJ3U6fjST4uiZKjmRdxpQbGH9qfqREv0
	2Rnw0BFYIT9+WgOmf7AduVuwN38wWyKNgDWnpgEHcrKimy7/ROr6g58qJUehamFeXyf1d3WOacj
	uJWKgZ52226Ghyw0bzQjjlPzhgMC2ZxSf
X-Google-Smtp-Source: AGHT+IFCtEAA8jDf4CIyKLFa5P2I9nWmPSLGaxM01gvUdEcqofTGvaTEs6FRsnIlQqBhvpAahWbeke1mKJXiA4aSSJU=
X-Received: by 2002:a05:6902:c08:b0:e28:f3e7:d92b with SMTP id
 3f1490d57ef6-e3087b66629mr26279436276.24.1730629607506; Sun, 03 Nov 2024
 02:26:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030131232.15524-1-fw@strlen.de>
In-Reply-To: <20241030131232.15524-1-fw@strlen.de>
From: Nadia Pinaeva <n.m.pinaeva@gmail.com>
Date: Sun, 3 Nov 2024 11:26:36 +0100
Message-ID: <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I would like to provide some more context from the user point of view.
I am working on a tool that allows collecting network performance
metrics by using conntrack events.
Start time of a conntrack entry is used to evaluate seen_reply
latency, therefore the sooner it is timestamped, the better the
precision is.
In particular, when using this tool to compare the performance of the
same feature implemented using iptables/nftables/OVS it is crucial
to have the entry timestamped earlier to see any difference.

I am not sure if current timestamping logic is used for anything, but
changing it would definitely help with my use case.
I am happy to provide more details, if you have any questions.

Nadia Pinaeva


On Wed, 30 Oct 2024 at 14:18, Florian Westphal <fw@strlen.de> wrote:
>
> Sample start time at allocation time, not when the conntrack entry is
> inserted into the hashtable.
>
> In most cases this makes very little difference, but there are cases where
> there is significant delay beteen allocation and confirmation, e.g. when
> packets get queued to userspace to when there are many (iptables) rules
> that need to be evaluated.
>
> Sampling as early as possible exposes this extra delay to userspace.
> Before this, conntrack start time is the time when we insert into the
> table, at that time all of prerouting/input (or forward/postrouting)
> processing has already happened.
>
> v2: if skb has a suitable timestamp set, use that.  This makes flow start
> time to be either initial receive time of skb or the conntrack allocation.
>
> Reported-by: Nadia Pinaeva <n.m.pinaeva@gmail.com>
> Fixes: a992ca2a0498 ("netfilter: nf_conntrack_tstamp: add flow-based timestamp extension")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netfilter/nf_conntrack_timestamp.h | 12 ++++++------
>  net/netfilter/nf_conntrack_core.c              | 18 +++---------------
>  net/netfilter/nf_conntrack_netlink.c           |  6 +-----
>  3 files changed, 10 insertions(+), 26 deletions(-)
>
> diff --git a/include/net/netfilter/nf_conntrack_timestamp.h b/include/net/netfilter/nf_conntrack_timestamp.h
> index 57138d974a9f..5b6273058384 100644
> --- a/include/net/netfilter/nf_conntrack_timestamp.h
> +++ b/include/net/netfilter/nf_conntrack_timestamp.h
> @@ -23,18 +23,18 @@ struct nf_conn_tstamp *nf_conn_tstamp_find(const struct nf_conn *ct)
>  #endif
>  }
>
> -static inline
> -struct nf_conn_tstamp *nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
> +static inline void nf_ct_tstamp_ext_add(struct nf_conn *ct, u64 tstamp_ns, gfp_t gfp)
>  {
>  #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
>         struct net *net = nf_ct_net(ct);
> +       struct nf_conn_tstamp *tstamp;
>
>         if (!net->ct.sysctl_tstamp)
> -               return NULL;
> +               return;
>
> -       return nf_ct_ext_add(ct, NF_CT_EXT_TSTAMP, gfp);
> -#else
> -       return NULL;
> +       tstamp = nf_ct_ext_add(ct, NF_CT_EXT_TSTAMP, gfp);
> +       if (tstamp)
> +               tstamp->start = tstamp_ns ? tstamp_ns : ktime_get_real_ns();
>  #endif
>  };
>
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 9db3e2b0b1c3..33bc99356453 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -976,18 +976,6 @@ static void nf_ct_acct_merge(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
>         }
>  }
>
> -static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
> -{
> -       struct nf_conn_tstamp *tstamp;
> -
> -       refcount_inc(&ct->ct_general.use);
> -
> -       /* set conntrack timestamp, if enabled. */
> -       tstamp = nf_conn_tstamp_find(ct);
> -       if (tstamp)
> -               tstamp->start = ktime_get_real_ns();
> -}
> -
>  /**
>   * nf_ct_match_reverse - check if ct1 and ct2 refer to identical flow
>   * @ct1: conntrack in hash table to check against
> @@ -1111,7 +1099,7 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
>          */
>         loser_ct->status |= IPS_FIXED_TIMEOUT | IPS_NAT_CLASH;
>
> -       __nf_conntrack_insert_prepare(loser_ct);
> +       refcount_inc(&loser_ct->ct_general.use);
>
>         /* fake add for ORIGINAL dir: we want lookups to only find the entry
>          * already in the table.  This also hides the clashing entry from
> @@ -1295,7 +1283,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
>            weird delay cases. */
>         ct->timeout += nfct_time_stamp;
>
> -       __nf_conntrack_insert_prepare(ct);
> +       refcount_inc(&ct->ct_general.use);
>
>         /* Since the lookup is lockless, hash insertion must be done after
>          * starting the timer and setting the CONFIRMED bit. The RCU barriers
> @@ -1782,7 +1770,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
>                                       GFP_ATOMIC);
>
>         nf_ct_acct_ext_add(ct, GFP_ATOMIC);
> -       nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
> +       nf_ct_tstamp_ext_add(ct, ktime_to_ns(skb_tstamp(skb)), GFP_ATOMIC);
>         nf_ct_labels_ext_add(ct);
>
>  #ifdef CONFIG_NF_CONNTRACK_EVENTS
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 6a1239433830..1761cd3a84e2 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2239,7 +2239,6 @@ ctnetlink_create_conntrack(struct net *net,
>         struct nf_conn *ct;
>         int err = -EINVAL;
>         struct nf_conntrack_helper *helper;
> -       struct nf_conn_tstamp *tstamp;
>         u64 timeout;
>
>         ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
> @@ -2303,7 +2302,7 @@ ctnetlink_create_conntrack(struct net *net,
>                 goto err2;
>
>         nf_ct_acct_ext_add(ct, GFP_ATOMIC);
> -       nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
> +       nf_ct_tstamp_ext_add(ct, 0, GFP_ATOMIC);
>         nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
>         nf_ct_labels_ext_add(ct);
>         nfct_seqadj_ext_add(ct);
> @@ -2365,9 +2364,6 @@ ctnetlink_create_conntrack(struct net *net,
>                 __set_bit(IPS_EXPECTED_BIT, &ct->status);
>                 ct->master = master_ct;
>         }
> -       tstamp = nf_conn_tstamp_find(ct);
> -       if (tstamp)
> -               tstamp->start = ktime_get_real_ns();
>
>         err = nf_conntrack_hash_check_insert(ct);
>         if (err < 0)
> --
> 2.45.2
>

Received: from mail-244118.protonmail.ch (mail-244118.protonmail.ch [109.224.244.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECCD242D91;
	Sun, 11 Jan 2026 20:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768162974; cv=none; b=nGBzFaaHvSvmrXNUoGALUvzuxXC/NINRER4V55f67abHOhMAADl/+lskEHrJfw7zOwv1SPD9DANesQ9iX77qTDqy5YMl+uGU8oz84AnSGsKXhpZ+5kSVvqH3GTdkbWNraNEVx9l6u+MOqnfHMV78ul0XRFrSGpeh2cA66uQpyxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768162974; c=relaxed/simple;
	bh=zc+Gan3xUNjosOjBTVwEr2rfxtANQ6ND2NtnpcdrF58=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QM6ISvZn2gWxBus2dUrzv3p+Ba1Mu1+zz5RwLu49tjDYHcupOQ9YYlFKuU5t/naDbNUbWYFOiL4a5OLdCetYA8VkxJNg/oBcx5hG4vT3n3pBU91SpG96JVCCyaXPCTz5vNo2IQXkb4uVq98WqIctJk0hCYT5ixfH62S3GEEvQvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=willsroot.io; spf=pass smtp.mailfrom=willsroot.io; dkim=pass (2048-bit key) header.d=willsroot.io header.i=@willsroot.io header.b=AOQ6kf6N; arc=none smtp.client-ip=109.224.244.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=willsroot.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=willsroot.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=willsroot.io header.i=@willsroot.io header.b="AOQ6kf6N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=willsroot.io;
	s=protonmail2; t=1768162962; x=1768422162;
	bh=zc+Gan3xUNjosOjBTVwEr2rfxtANQ6ND2NtnpcdrF58=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=AOQ6kf6N1Rdb7BqlZ1eSgQLG4eGorT7WgEeErtnJ5nl9Cqo+qsrBBpsaurThFu46i
	 hTcMQfqZn8lCAfO++uBlnsGej5wI1FHLrdFOEagrB+GxJtRDpTdgDOQ+wy2jKd0LGA
	 IUDKqEyUKQcLUiTmXoSkU5AJ57wVN8ikadzdJ3ncIL6QNm7lyd1V/c6MxUP8Z0qBmY
	 joG/dObOUyYEPflq8tFFfSczwA/7bN9ak9LPFh9pVJfXywQP7n4H0z4kp21g6C7G8i
	 RTusBXCni0OMDwolZ46GMZkXN3xNp1AYwkZWmmjvdfZpB3o/9oFJeWuksbEUl3yZLU
	 j2WdumB5TkogA==
Date: Sun, 11 Jan 2026 20:22:41 +0000
To: Jamal Hadi Salim <jhs@mojatatu.com>
From: William Liu <will@willsroot.io>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch, netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us, victor@mojatatu.com, dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me, Savino Dicanosa <savy@syst3mfailure.io>
Subject: Re: [PATCH net 5/6] net/sched: fix packet loop on netem when duplicate is on
Message-ID: <xJqddWWQEUAQtUVQo1auHMfOxgaRO1ix2L7j9yR9iGPNdbNFlMNjeojDvutQ40tKfzCH9ZkI1Uaeq7e4EhIDLVRz3TisS8fo0rsNcQKS7mg=@willsroot.io>
In-Reply-To: <20260111163947.811248-6-jhs@mojatatu.com>
References: <20260111163947.811248-1-jhs@mojatatu.com> <20260111163947.811248-6-jhs@mojatatu.com>
Feedback-ID: 42723359:user:proton
X-Pm-Message-ID: 1a98bbd1f5ea486db80ae00fb4d0311f9ef4859d
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sunday, January 11th, 2026 at 4:40 PM, Jamal Hadi Salim <jhs@mojatatu.co=
m> wrote:

>
>
> As stated by William [1]:
>
> "netem_enqueue's duplication prevention logic breaks when a netem
> resides in a qdisc tree with other netems - this can lead to a
> soft lockup and OOM loop in netem_dequeue, as seen in [2].
> Ensure that a duplicating netem cannot exist in a tree with other
> netems."
>
> In this patch, we use the first approach suggested in [1] (the skb
> ttl field) to detect and stop a possible netem duplicate infinite loop.
>
> [1] https://lore.kernel.org/netdev/20250708164141.875402-1-will@willsroot=
.io/
> [2] https://lore.kernel.org/netdev/8DuRWwfqjoRDLDmBMlIfbrsZg9Gx50DHJc1ilx=
sEBNe2D6NMoigR_eIRIG0LOjMc3r10nUUZtArXx4oZBIdUfZQrwjcQhdinnMis_0G7VEk=3D@wi=
llsroot.io/
>
> Fixes: 0afb51e72855 ("[PKT_SCHED]: netem: reinsert for duplication")
> Reported-by: William Liu will@willsroot.io
>
> Reported-by: Savino Dicanosa savy@syst3mfailure.io
>
> Closes: https://lore.kernel.org/netdev/8DuRWwfqjoRDLDmBMlIfbrsZg9Gx50DHJc=
1ilxsEBNe2D6NMoigR_eIRIG0LOjMc3r10nUUZtArXx4oZBIdUfZQrwjcQhdinnMis_0G7VEk=
=3D@willsroot.io/
> Co-developed-by: Victor Nogueira victor@mojatatu.com
>
> Signed-off-by: Victor Nogueira victor@mojatatu.com
>
> Signed-off-by: Jamal Hadi Salim jhs@mojatatu.com
>
> ---
> net/sched/sch_netem.c | 7 +++----
> 1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
> index a9ea40c13527..4a65fb841a98 100644
> --- a/net/sched/sch_netem.c
> +++ b/net/sched/sch_netem.c
> @@ -461,7 +461,8 @@ static int netem_enqueue(struct sk_buff *skb, struct =
Qdisc *sch,
> skb->prev =3D NULL;
>
>
> /* Random duplication */
> - if (q->duplicate && q->duplicate >=3D get_crandom(&q->dup_cor, &q->prng=
))
>
> + if (q->duplicate && !skb->ttl &&
>
> + q->duplicate >=3D get_crandom(&q->dup_cor, &q->prng))
>
> ++count;
>
> /* Drop packet? */
> @@ -539,11 +540,9 @@ static int netem_enqueue(struct sk_buff *skb, struct=
 Qdisc *sch,
> */
> if (skb2) {
> struct Qdisc rootq =3D qdisc_root_bh(sch);
> - u32 dupsave =3D q->duplicate; / prevent duplicating a dup... */
>
>
> - q->duplicate =3D 0;
>
> + skb2->ttl++; /* prevent duplicating a dup... */
>
> rootq->enqueue(skb2, rootq, to_free);
>
> - q->duplicate =3D dupsave;
>
> skb2 =3D NULL;
> }
>
> --
> 2.34.1

Reviewed-by: William Liu <will@willsroot.io>

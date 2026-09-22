Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C384C3A9015
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 21:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790112994; cv=pass; b=sxPQrnHBeoxlInEsUBOYzKx29mS4Ul2+SEHfrdHYPm5Ct/ykvi3p2UEWmwj9nC0yfxsJ83BqgfSyX0VI5TlV4b6NJ9ZVA4Qc9pUQiHQ1wnLCGeQS+KYp3Ohu18jWYzZx0/UxRqQqbwe0CTx5A8aYp/p3wotxpZgSZWLJ0yKJVOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790112994; c=relaxed/simple;
	bh=aZGKfL3QuDsd4IV/LQDvu27JhAeZANTouNPDY3sRBkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F/cqum8sw5i1nnSS57tgA7S00m66p3GXEUnA8jzcOvcL0WW5aiLChA4ZKcZ/XHm2nBUwqj5HKWpZ25DQmnDHm3VPxcRkcf7foisr65JW/oOBDRo8FbqVV8tRfiO0iZfQ4RAFcV7d50VNakndK64LlH3nlXQpGFU3i29udTw3btI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=DnqNkRhM; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="DnqNkRhM"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469b355ffso198686b3a.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 14:36:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790112977; cv=none;
        d=google.com; s=arc-20260327;
        b=WObWO3EVg/Unt6Jm5Wdqmysj7rUigep0mu06m50jc+WEGbeI8USJue8mxgjCMpyIQb
         KTFOweJLxwgyb/oPMTsYsSPKsJj70U1zWhR8wEt/FQYbIY25bQL8IU2MCjjrG2I5+u2o
         D9g8zxxM4zsI1tfr/hF+GTEa4vqGEa8vYkSpsPIGbFSPCs71qGDVldZHEK1JN/lBH/It
         ODLnLA5zMNVghUsjiBmAjA8mZ4/pq3yIrSyuvfRX4Qpb37py3Pr9NdZLWXUGOkLdzheA
         jD8aHcYTXH3BGDQBPYR6iS9nN23Fb1jhg8dZ3UaZ075MB3vMHae9Epxj+z19bV3IdIpv
         Cp/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wfpSlvWpUl0lvkt+6Kff0Lj6e10Ks5VeX4xVd+zNn48=;
        fh=T887+hf6L0+rsTxy4OcB/UArDOC+lAbH0GH6yoUhOiY=;
        b=ZG9zneaefxeM7328jScjk/uHNGu8TUVDUPy5fNoev2jA3UDi8AWjILOMayOM5Lt5i+
         byRakdypaw20T2YnoKIdGloZn8iolwTkRNxwG57y19FKQLykaeBedtfwVXsGmhgfzDlB
         fCCkKXr3xY1DKNeSKNdpwZ7m7gJJ1z+eBbombRlmXWtBvWJVcRv5jDwAl9Tg+7DAMnnG
         7Ir11fed1jOY8uAqKrvAwO7kdO+FSJlhi4rbrJYVHJf5Pr6en+bG23FDMoR7+uyWCeql
         aWRc3uIRmr5YkAI8hLcbCZ+0DRHvMpMIP+GbcHlFMuI87NvEYRWRs26agPHRRxE+d3qe
         INtA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1790112977; x=1790717777; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wfpSlvWpUl0lvkt+6Kff0Lj6e10Ks5VeX4xVd+zNn48=;
        b=DnqNkRhMANDAbz8S5xGFlfWPA4TC6HEBdoloJTzkhG4LfCrEPYGEKtpT/8TOc+jc+K
         kZvWarBK8zOodWUKLeMNCiGOEM0hQh2wzWAUI2U9ZL78Shhz7CSiDe/oWd5nFcvAnZ9L
         CIafMBSlVa1Q0EWrcXq706DUipXzYhPHoezVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790112977; x=1790717777;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wfpSlvWpUl0lvkt+6Kff0Lj6e10Ks5VeX4xVd+zNn48=;
        b=fkdEwf3jAhdyXv2g82cGvmOHaCcz9ikrW1N20lfFPSYWYC0cXXZywopUJi6cVlIg9g
         xt8DAnXrg9JbR89LAD//7RZDeEFW59hXeFhSs62tdhK2nMuM/33RUdHMpsqJXMCdg4vi
         z87ngEBlfVUQwAktRlm1tujosB8AA+bWBQ+yLBf1377D1Tt02hyi1bv07ZZonW1M7qdy
         tBPSbUTlDB0YpgnyBkCun70qaL9sqsVoj0b1fnn/Edy2FgIvd4m0074vmeWrTny5xMQG
         jSOpO1ZycwYPUK1lfIhXr11Z5sU5uOp/sFr3FM3vyIdxQ2VUT90zMRd6ZFNzVLd4ztnf
         N24A==
X-Forwarded-Encrypted: i=1; AKwUvBy+dr2JuzyJUUkFufOjVODrCEh4+Ysjrs3ySww3kAgyL9xuHTO0iSnRMV/YND1DoK21jaxZWgVVId5dSZsuzB8=@vger.kernel.org
X-Gm-Message-State: AFuF++m/1CZTgLUZgHvC+lzIu0xmYt5q7Ns5r3OXFN1BQcgTU+AXZTM+
	t8Z5ym19FChDHCf7hkCH0K1WSdmqs3vGbvbth8dXORJfulATfPSHt+x8e1b0FS4aZMZD8PGQe78
	7LkwoN6fHHjK5sndcGRbuVw6XmqlUBvpwaCQYNxYQ
X-Gm-Gg: AYBFou1E1r/AoQZ9izVSigD86KD7mTzn+yoxmxbD0vc9rfugVAY/QSc+bYVK65oGcC6
	xhSiSgscwLw71duB46/Gkuw1q1P7T4s2D8SdGXsFVGsQNwOJjc8WJZ5qbOZvNwFU8OYDBxV7z/i
	ZuKH6fcfwmvAi2eWQsKjfZV7doJdTo5vH/v2NM/JWvjf7bhYLmiumhR8bloOgOKBD99p853jWp5
	8ZJTxbpXlRE3OzbC/NIol9LtLrDzlD+sbDryNrsPM3ELudNiVzpluKEQGEI49pncuMNVWAUwGuP
	mUv3OuxzWVMnwCqMNLowPU+Ebosh/deoCb1veAqiyM9Hr6olJKlta9ZeECq5iDKRwR5YAB5HAmb
	UUA8OQGSdNCBfSJ8wmsQtp0J7F/IeWSht/g==
X-Received: by 2002:a05:6a00:4099:b0:86d:3958:6b13 with SMTP id
 d2e1a72fcca58-87d1b0c0ee7mr833702b3a.19.1790112977303; Tue, 22 Sep 2026
 14:36:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921145655.3167436-1-i.maximets@ovn.org> <20260921145655.3167436-7-i.maximets@ovn.org>
In-Reply-To: <20260921145655.3167436-7-i.maximets@ovn.org>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 22 Sep 2026 17:36:05 -0400
X-Gm-Features: AcwNN1WkTM90t4zAGVak1fLnVY1e6J2lGuTsKVieqJYWq0WRhgHFKVnTUE18TSw
Message-ID: <CAM0EoMmF8KE2m0B8rON8iOcaQAHWMSS6G=CkOdwh9snaTzvNpw@mail.gmail.com>
Subject: Re: [PATCH net 6/6] net/sched: act_ct: fix helper UAF due to
 extensions realloc
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Aaron Conole <aconole@redhat.com>, 
	Eelco Chaudron <echaudro@redhat.com>, Jiri Pirko <jiri@resnulli.us>, Xin Long <lucien.xin@gmail.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, linux-kernel@vger.kernel.org, dev@openvswitch.org, 
	stable@vger.kernel.org, Axel Mierczuk <axel.mierczuk@1password.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 10:57=E2=80=AFAM Ilya Maximets <i.maximets@ovn.org>=
 wrote:
>
> While calling the helpers, a raw pointer to the extensions area is
> wired into expectations list:
>
>   -> nf_ct_helper()
>    -> helper->help()
>     -> nf_ct_expect_related_report()
>      -> nf_ct_expect_insert()
>       -> hlist_add_head_rcu(&exp->lnode, &master_help->expectations)
>
> In case the connection is not confirmed yet, more extensions can be
> added afterwards with *_ext_add() calls reallocating the extension
> space and leaving the now invalid pointer in the expectations list
> that is later accessed while removing the expectation.
>
> Make sure that helpers are called at the end after all the other
> extensions are already added.
>
> Note that the helper rejection now leaves the mark and labels set,
> but that's not different from how the NAT was handled before or how
> the mark and the labels were handled on confirmation failure.  And
> there are no atomicity guarantees provided by the API anyway.
>
> Fixes: a21b06e73191 ("net: sched: add helper support in act_ct")
> Cc: stable@vger.kernel.org
> Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  net/sched/act_ct.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index f62051ec9d57d..411e3dd92d072 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -1102,19 +1102,25 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *=
skb, const struct tc_action *a,
>                 }
>         }
>
> -       if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {
> -               err =3D nf_ct_helper(skb, ct, ctinfo, family);
> -               if (err !=3D NF_ACCEPT)
> -                       goto nf_error;
> -       }
> -
>         if (commit) {
>                 tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
>                 tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
>
>                 if (!nf_ct_is_confirmed(ct))
>                         nf_conn_act_ct_ext_add(skb, ct, ctinfo);
> +       }
>
> +       /* Run helpers for the connection if nf_conntrack_in() was execut=
ed
> +        * or if we're about to commit.  This has to be done after all th=
e
> +        * extensions are already added.
> +        */
> +       if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {
> +               err =3D nf_ct_helper(skb, ct, ctinfo, family);
> +               if (err !=3D NF_ACCEPT)
> +                       goto nf_error;
> +       }
> +
> +       if (commit) {
>                 /* This will take care of sending queued events
>                  * even if the connection is already confirmed.
>                  */
> --
> 2.55.0
>

Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB364BEE5E
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790109853; cv=pass; b=fSa8jOaegGZeH6UvPTDLl91N0lTij61SvnmJhSd/fu2/dCVMDum47Bsgj+QnHAA6lwdPmN9LntKyd8NE38mRxOBPIFnRmcgA91XHsujcxIF8ChTZc+7tUna0JVExI5lwYZrkIbramAKAdcJTSf3ChlN0YrLqLKPeZ8B+ErSEMgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790109853; c=relaxed/simple;
	bh=P+lcMuK5hQh5O0IlQrlqy9m+daoCKm3PxvImyC7y6p0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LlX9ixo5GgFLyXHgm/TuRwzTCvEjs4pkPObPuRDC8VyXGqAOzKPN2Hz23eIODyyBYMM5vT+MpiRLCt9IW9TsFnH+SUOlMTnppLBGxlNxMoRs+PycSyVeRzR+Ehdm2H552Ggc9VQm3/754o8U7FZEI73MILYOn0i/y27+DuDVDsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kN3AtHDp; arc=pass smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kN3AtHDp"
Received: by mail-pz2-f42.google.com with SMTP id d2e1a72fcca58-86efece610cso218382b3a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 13:44:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790109842; cv=none;
        d=google.com; s=arc-20260327;
        b=Qy5Sw6hAjmpxMPDrsy13MlLZmxY30T8h3q2iB1htvguptH8tsaGbr+ReDH8caiNjH8
         o7zlbhSgwze04TnKe+K7e7jqh3SHgKfp6nviZxuZytY7KLjvxQZ5pu+ZnljxJZqg2pLI
         SNbIbOjQSRgmeSaL+VNzWef/8sZqar0jIN9SjajOfLhAzOLUAiXlNTQD6J182Et8YW1f
         Pepw+6M836Uzq4a0e1eykiMeGLGNUB29f3+Dw34KP9d+XA772BgFCkvaoj4kBrhWu2rW
         20TtbwPkdAD3DL6Czkxk/XYedHn8Yi7/qt73kQ4/RTWPJ4mzcyt5comI8fwu9ECH2+vg
         U8wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9uOUnWBMatAL9szZ+HFkI4Lili+9ziWjf14eBlgXmc4=;
        fh=ifAvvxE0F6ojpA3DBtr3l8pMVItwcGV6iOe6U15Rmk8=;
        b=qB58EOx0d/dS4dkFHbpB6qSB04IOXHKiy5kq5iP02PoiRzFbuZV4ad5d1ExHls5OVR
         7JfQ1gir6rPAqeNw+RcS9wfA9izE1nQKofSDeNVwV99HBraC7OS7Sz3C1+vDD7gUcUcI
         pD3iSkfR4XVqjN1p1MGfGsgs8N8rygHhci7KQj7rWX1Vnb4Vx9gvFCPTkE7+vp8AUt7E
         mstsNcERM+RTWn2jomh9sKf+3ejDPddLPkWQTYSNyGYbPiI7tJU3a0z4pJJXed+ez2es
         pB6jKaAZ6puYgPDvvwUpw6tH5+B8/qAxkMfP03c/jyTkx4V3lINtdCjCSgw3JUcc+QQK
         YKsw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790109842; x=1790714642; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9uOUnWBMatAL9szZ+HFkI4Lili+9ziWjf14eBlgXmc4=;
        b=kN3AtHDpVGwD+cwN/jEw0l059yxgDsYK/hwZ+xBcqWCvp/+PVZH8oiBYiOH9R+Xiwm
         shE9VjxZEllX95TKkzPfgAtVsJBVqe7g3antDH+WhsalUsopqvTIgrmPo9AUKi2SucYn
         6N2sHsFmhe290cp9GtygvUG9DOuBrqFgQhA5sP7g2edfEq3Rdj1BVm6Wgs96JRev4T69
         Sygz6yfy3MEAfBVxoXEyg/q9UQJoA9xuBnjY9qash4Hqznh6YpPTlYT9BTM0OHSVK9g3
         6T0nWp9czZq35/P26b0M2egkhf+RYRKxXOZLqWxvU9NXhnZplRaoEryIMmuFugH6laF0
         1UeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790109842; x=1790714642;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9uOUnWBMatAL9szZ+HFkI4Lili+9ziWjf14eBlgXmc4=;
        b=fqUswaeYVEyVsMBYUuKJcNJTMIQAhwQZGxa+YxOjVrKHlrmD4Ko2SVGVAff2edE7kn
         gABS4qUJc1dM6dvk+4be35EmRblfP8aYNwobbBPKv7V6St5hKbIHtNloymjL3VfnUizS
         cqKc1wtUph2DB053ugQ9zpRpBC2QDuuYlI03J+v78izzNrSnvnFJqIYyKur3A5enjHN6
         xuY1QpuhJL9wJ373RIUXXGUDl00EfY6/nkHNb7xy8pJuNqLLDQ67KhT+ekHIPs7nJlwX
         594PmCA3qpB6FwkVOjZAUShMRuQsi4Accv1yZoyuUhyDlxOXhynKIyfH4fjW5WHKkoyt
         Z+ow==
X-Forwarded-Encrypted: i=1; AKwUvByPKMGOvY6wsSVFPPTbFlS66wVWWylGud4AEsvYx1N7V3pz1oiq+6ltIMJzNWEOD2p+iwwtBieZ+qXWvSoI5mg=@vger.kernel.org
X-Gm-Message-State: AFuF++mUkGpdpuZJ/rYI9tEk1IsVggU3OluapgOPpKHIGBLOFL8nTF5s
	vIB5I4Acl8PfReaLYgmFlxvTlixIdroBSuUihKgZ4SLj7pdPjvQ0TGIKsMwznVuxDZL7QxPRDGN
	k0/g+c2GCpqCCExjtxex4ahquah38uoE=
X-Gm-Gg: AYBFou1ZOE6tyaCTKiZp6PEXkiVbVmFT9p0tPrYT4sbWRwpooKfXKQj97B9IW8Z+9J4
	qQqTzVfajRDcis4KxZZBipqk7ZjiDlcf251tXFkZIagkcGKjY4Ynf6OLocbemdLOiQmoExg6z5c
	o13dXvAdFU0hSGSf6LRkH7ctKAYXlA1+/8RtWd6j9Q2990AekhPDYyqAu7sHkOEp1TaKooVzzyH
	EXoauYkMsD/v3QCjy7SXnsRj1XP4iD/mYh4uq4+m8GU9JImjmDaqwaUBw2K3Cy8Egk8xLdE1ZzH
	T/i7Pgd7pDws/0OmoMybjMKE945VfZ7QCbnkja1XxiH0VHqbZAi9QbFLtzkuOCJCOtJzLLEq9UM
	/cLASizjA6TgZzf/fAjLWpwux+JJSMedSyBxzuIl4ziRIajbkLj7QYAU5vc0UhjIk
X-Received: by 2002:a05:6a20:7293:b0:3dd:85aa:4527 with SMTP id
 adf61e73a8af0-3ddf82adf58mr565061637.34.1790109842514; Tue, 22 Sep 2026
 13:44:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921145655.3167436-1-i.maximets@ovn.org> <20260921145655.3167436-7-i.maximets@ovn.org>
In-Reply-To: <20260921145655.3167436-7-i.maximets@ovn.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 22 Sep 2026 16:43:51 -0400
X-Gm-Features: AcwNN1Wxvg5q08SpmktKVndNHz2CGqilUY2VDTceI09JMLfUxf8v9o9CPku839U
Message-ID: <CADvbK_es1LF3eAnX2iTfZKeCxWFOt8cux+9F8E9OSN55SQuc-A@mail.gmail.com>
Subject: Re: [PATCH net 6/6] net/sched: act_ct: fix helper UAF due to
 extensions realloc
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Aaron Conole <aconole@redhat.com>, 
	Eelco Chaudron <echaudro@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>, 
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

Reviewed-by: Xin Long <lucien.xin@gmail.com>

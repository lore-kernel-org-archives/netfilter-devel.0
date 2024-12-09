Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D026F137776;
	Mon,  9 Dec 2024 21:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733781031; cv=none; b=Im2lDUe2ZA5c5Fc7D7XfdmYmSAssFsBN136k9A780IGVZlT/pOfNi8gsKEZ+dJAjX5QsB+BWXtt4fRAH3Kczw8I8bMhOekYndWrMnI8qc9/3WkFIBqRFLSLloQja3ypyRj9UyqzhGSnMAJhLLhDd2VagdScF+llkCP1RYfaF78A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733781031; c=relaxed/simple;
	bh=hDQM97Y4jFVlYOaNszFvxzMEgJBaT+HLzVV4nPU4gbU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ckrx0o5MX0VGeJaS7+wmvAlb5pKAOrE8IhFMODygBwjxXBgBdr4+qZPwILO8BbfFI55D7yEccedpSbprSOgMWn1FsWRnimTkyEiAPsU/0IvUlPUPzs+NT/vMPVMV8ipQhyyu6r3K/P6mD4Tewvp9sQ4f/Qg6WBLMFizV1WQmC/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AoyAscjn; arc=none smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AoyAscjn"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-4affbc4dc74so538318137.0;
        Mon, 09 Dec 2024 13:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733781028; x=1734385828; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8Y0BOvZ3mlVk8nypG+yFwWOupPhYt29InrHyTPoS3Fo=;
        b=AoyAscjnyjf3kl8ReZWM5qYMZkF+4MKd5gAOiP6GexhfBhY8H4hVA4t4gL18M+NjsS
         qxomJEHy93Ph6l6bbaCihIomJT+qUta7IJzWOtczhUrjT8pV0WUwKVhGgkI3fdAJJZ61
         ciUHzYgvnBWJVjS0FRADNGsQTffabY95gkvW5qBjjCbXidfiBCY9T7dUiNxvxKSrhmhJ
         JftELlJ/7zHh0406zCin+VPtJz8DU6ovNA5kLfJU+UTGbnDc7syuczTxBe+H5lFKHIWv
         zwH0n6WhA2Zgh/sWII0ecjzLwmQCOAtiamB2xcVzKufMoxBvUmD++lkjKiEhR/grxIWG
         PaQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733781028; x=1734385828;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Y0BOvZ3mlVk8nypG+yFwWOupPhYt29InrHyTPoS3Fo=;
        b=jgcF0LwhGLbrcI67y9MYrc/iVlJ7WasY4oPRi+Omsba8Kk4kTu9LCThzOUE2RR0o9Z
         ZP2vrmFkkl1W4mtzHmE/v9kpwZhN8mC7DH4qMi152QYNBTDvaqlQFwNJtSznhvfPgQi7
         XbRgYFZyCwuHlTnkBEXjiQVEqjzUERiTVegl/O0RmW3oaCIST4jYzC3OLAyYV/nCMhzb
         UHzT7hdMED71dAE7NY0SYnvtNAR+4sZ5CLeTmdH0k6SgU4GRXrTu0qX4S0cdAmOcdT3+
         SeJrUf0yrvLx23Dxgd1Wkck6DgwT352/0puBeSerDC+WlAWjGo1MBiPoL4+kvWtQTqpk
         sAIw==
X-Forwarded-Encrypted: i=1; AJvYcCV8oU4PzxSX/cHl2hm80IPYLrjIjdVyDFMIz2mB0zQdQklEJFWnRUs2oFUrWwguA59ibtSXfVYNcON3q1XHCWum@vger.kernel.org, AJvYcCX1BBNg3o2+6/vp66i2lgDifFwe83heUB53Rn90aHfqHdO5ykh1CuslZUgICBX/xPvlIf/+gRou@vger.kernel.org, AJvYcCXjuxMwPn6TOucCa7+8gExV8+Ks8MMAkminrUV6QwohOcYfh62JDWOyz4dh+kWm2R7iM70CWKfG3FGvJpw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwwFGu1J0VCWfW6D2eINCk+duoHryEiDyCchzGoDyb3+ApuQ2W
	maKd3Y5EnZyt8xp8WnD1eqT9XmDCRH80/dpdufHffH2TeC/Y4geZDKF+mobQMxJQwBzH/RBqrX5
	lYGiQL8BvVaWBa52k663bh0Hxdo0=
X-Gm-Gg: ASbGncusCHVUgLk3SIKO/ogM15OnmNeYY0Wj7hbBry48uKD01w6c7ExbxFxhIAI5qJK
	DSGUAbX/318sl9a3T0oP90maZVzbyMsB94x8=
X-Google-Smtp-Source: AGHT+IEJERBBBVubTHmz7RCJslnqiIv1uE9fucalzUR1VqlvDk6jAx5i9Q0rIdhj3HambxdRmGTZS4vnQT4UwyWQwCI=
X-Received: by 2002:a05:6102:4194:b0:4af:c1b6:c4fd with SMTP id
 ada2fe7eead31-4afcaac78d9mr15519373137.22.1733781028637; Mon, 09 Dec 2024
 13:50:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209204918.56943-1-karprzy7@gmail.com> <Z1diBYlJUIRBIc2L@calendula>
In-Reply-To: <Z1diBYlJUIRBIc2L@calendula>
From: Karol P <karprzy7@gmail.com>
Date: Mon, 9 Dec 2024 22:50:17 +0100
Message-ID: <CAKwoAfq99AKb=a54=eRSKesFYO2X5R8WR8KSrrXVB_Z4=rkexg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nfnetlink_queue: Fix redundant comparison of
 unsigned value
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 9 Dec 2024 at 22:32, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi,
>
> On Mon, Dec 09, 2024 at 09:49:18PM +0100, Karol Przybylski wrote:
> > The comparison seclen >= 0 in net/netfilter/nfnetlink_queue.c is redundant because seclen is an unsigned value, and such comparisons are always true.
> >
> > This patch removes the unnecessary comparison replacing it with just 'greater than'
> >
> > Discovered in coverity, CID 1602243
> >
> > Signed-off-by: Karol Przybylski <karprzy7@gmail.com>
> > ---
> >  net/netfilter/nfnetlink_queue.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> > index 5110f29b2..eacb34ffb 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -643,7 +643,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
> >
> >       if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
> >               seclen = nfqnl_get_sk_secctx(entskb, &ctx);
> > -             if (seclen >= 0)
> > +             if (seclen > 0)
>
> What tree are you using? I don't see this code in net-next.git

linux-next, next-20241209
Link: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/net/netfilter/nfnetlink_queue.c?h=next-20241209#n646

>
> >                       size += nla_total_size(seclen);
> >       }
> >
> > @@ -810,7 +810,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
> >       }
> >
> >       nlh->nlmsg_len = skb->len;
> > -     if (seclen >= 0)
> > +     if (seclen > 0)
> >               security_release_secctx(&ctx);
> >       return skb;
> >
> > @@ -819,7 +819,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
> >       kfree_skb(skb);
> >       net_err_ratelimited("nf_queue: error creating packet message\n");
> >  nlmsg_failure:
> > -     if (seclen >= 0)
> > +     if (seclen > 0)
> >               security_release_secctx(&ctx);
> >       return NULL;
> >  }
> > --
> > 2.34.1
> >

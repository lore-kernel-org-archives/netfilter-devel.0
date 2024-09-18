Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CEE176FA0
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 09:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726653129; cv=none; b=QGqri8+bP9DCUjVvLH9BuFAZ9ZA5BB/RRAEcsilFjycUNGEpSc/7B18tSku4smcyYdOf8ScFLLoOkhAxq/Fj+UMqbBnoxTEY97BbVwE9MSpu3BEYBi6O2OVQUqPMo+dMz5Dk5lkPVs99/KQC4NyeNZBLx5GENOW+onHmXYLKhK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726653129; c=relaxed/simple;
	bh=mid6M/+7GHu9872XrckWRaQvuAPQM+xM6tuV5wMBeIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qh/NKRFTv7pOhV369IlYejBsGxOUYyYchxw6ZY7MNIdmNGRUvyN6tdYTKl5nm2PS+5gwTrAxhsNSIAejloG3vTfbvSsmlzhD0v4Mnc+3E9F1RynAoU7F2IsaYuSBbx3JWX2pRY1vUOkg1slIfbrBspDtMeuj1AlibPQtnAd++NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L500v49W; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L500v49W"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a0b6e6057aso3321245ab.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 02:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726653127; x=1727257927; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BghhTpvb7jgihmXiYHuFAYh4iqQtx/0JlTIedI9SJzY=;
        b=L500v49WcrXM5gTcjQvSCykXxIDjuQ4uUpQD9i8f6dMQJ2vROjqvUBj/L4WR45Qh+u
         O8tHL0wrMFEHtJ+G9ZAzNkpLhXRygw1l6UpexEkEOrKne5MQTQ/NlHDA4FIEcbu5FQpE
         kd5R12+D45w2aTaJ+JEANUzc4HotnfQvj2g5mIlLokcBPbl7SVvrAQ1kIP63NTMm9sBd
         hTBCumMNflb9zDs6/P0sM+2gqLUhwNik+7INU6qb1RvznsOAnofy3enLvPpUJ2yUhIBS
         xIfiffWH88bzeHw159/lWbpqOMTSD4NTqWclwe1ihw1VlZ34fGd5v3SowtlbAO54xPvQ
         qeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726653127; x=1727257927;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BghhTpvb7jgihmXiYHuFAYh4iqQtx/0JlTIedI9SJzY=;
        b=Ft0C3h2ghQQ11KsdonM4XGkzdqUfWcy0Ktn6Lzit/LT6nQvFQYvL751nmONBqMb/aA
         KU1xfHpr302cpQC4Mq+99b4ga9HDjlnG/COed5rLUMEj+v6UGsVs7hxROZgiQUVA6svV
         mIyNtbLZ3xaWeVRgZcHZU8Judrw6jRRqqeXCo/cvGVDQ0A33qp5h1DV9EBn7c3p/EJHz
         DqyVgFCQOwOE263ttfXFarPson5jEksBfBaw60LtaOzdDrUDSPvAHkBTGoud1mH9SA0o
         faF5MPLUocSbbykU1EYc3YSLKuIXfD4p1D7P+klw/0ZszTR7yvWiS19q2lCAPuicaSdW
         fgfA==
X-Forwarded-Encrypted: i=1; AJvYcCVxt7doFEIWk6StNaypNaLJ00INUssGKO9QqAHqeObpbKh8FuvcLuLQVgMyE6TJPcG2alt8n1jQrGRDrW7uBys=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0YniKA057ygVLTfUgS4EqGjCYgJObo0GuaepUYyFs8unYjMqh
	mF3wc61uktL1bzaKMzggf38GrbhYv/88kddQuY3BkX6rKO4NOpvrnKZm7BKSP5UKxrTTw9aIOjX
	lSKG9kBKfQ3Pp+rl2EpDP2KahSt1nVb0SwmA=
X-Google-Smtp-Source: AGHT+IHqUPLf2aYOaUkXpEo9WtpDhXdYtone7isjD9I3qyZWwIBUyudpCe607rEnuEu0UEdYzeghm8V0uXKi0IEZFUc=
X-Received: by 2002:a05:6e02:152c:b0:3a0:a385:911d with SMTP id
 e9e14a558f8ab-3a0a3859332mr75462245ab.0.1726653126554; Wed, 18 Sep 2024
 02:52:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912185832.11962-1-pablo@netfilter.org> <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
 <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com>
 <ZuqPnLVqbQK6T_th@calendula> <20240918084202.GA10401@breakpoint.cc>
In-Reply-To: <20240918084202.GA10401@breakpoint.cc>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Wed, 18 Sep 2024 10:51:30 +0100
Message-ID: <CABhP=taCqWu5JSmZp+cF+p-=cDsbnQXpBU+ZR1v6238yC1pdmQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected packets
 from postrouting
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 18 Sept 2024 at 09:42, Florian Westphal <fw@strlen.de> wrote:
>
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Ok, I finally managed to get this tested, and it does not seem to
> > > solve the problem, it keeps dnating twice after the packet is enqueued
> > > by nfqueue
> >
> > dnatting twice is required to deal with the conntrack confirmation race.
>
> Antonio could also try this hack:
>
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -379,7 +379,7 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>                 unsigned int ct_verdict = verdict;
>
>                 rcu_read_lock();
> -               ct_hook = rcu_dereference(nf_ct_hook);
> +               ct_hook = NULL;
>                 if (ct_hook)
>                         ct_verdict = ct_hook->update(entry->state.net, entry->skb);
>                 rcu_read_unlock();
>
> which defers this to the clash resolution logic.
> The ct_hook->update infra predates this, I'm not sure we need
> it anymore.

Awesome, it works perfectly

I have these patches in addition to this last one

c3d69b2c40bb selftests: netfilter: add reverse-clash resolution test case
fd7c45a0aa7a netfilter: conntrack: add clash resolution for reverse collisions
8bb12723d1c4 netfilter: nf_nat: don't try nat source port reallocation
for reverse dir clash

It works with and without 610cea0d00f8 netfilter: nfnetlink_queue:
reroute reinjected packets from postrouting

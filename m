Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EA6244687
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 20:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768163974; cv=none; b=C1xwLmT4unA7U6EZsHYJNedKxBwVxXeHhPy6VmmQ6oNdzbf3+kqGj52bKeWwhboRCTktM7hYif0vxmoU5n4YGKby262BZAILMn6Vyn/Oc6d8+NGb+rvSW6FTXJshNkJmd/hXLts5FleH4TZsmr6meJpupmhj25wkGFL5BpdgKz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768163974; c=relaxed/simple;
	bh=BW13uDTRClwd+ENxHZXrwcj7SqhkHZAYp+zJ9mxdIss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NgQyxp6NNS1GCludnqz0zJpiSJijfvpzdHNzEyQyDFBGOKB2su0uvBj2i8e01z5pNS78ARkFv+5DhipvpFU3zk2HxuOvCBgHuGAIgIpnSoMxxXtv1mJLmsYMUg8CDKwV09SO7whyEK14QjZktyessJFTaK6Q3xuDAnPEqlh/+js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vlfe6jaf; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vlfe6jaf"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5ef31a77afbso1731726137.0
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 12:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768163972; x=1768768772; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P/B6ir2X1iP6OIYfvHzrgy+6QEnGmGpOcZQdGo4rUmk=;
        b=Vlfe6jafqpcv1447YgakVCS78OBd4NtiKJeKi9AmjA4LehYOexwfOhBTqE5PB1saYL
         5BdpepXDRGLdCg9REInDLz0uHw90oUXpQ/MnGigt1JuuMnjTEbvTZlZ0tZqREJ4cLUi4
         rirYJFFPdBhH0jQj9AVHBTuX13ak+pA2qdsLRkQ5SZXcamIEyzVLRO5tSuZucdTDDWNe
         XofE7u7qQMOa+9ijIGmDvXLNLVsoxl5oqKFcLSgdQSl/s13L0o/Md2lL5vSvtz4ovU8c
         15QlGRGnzZAy6tcLWxM/PFpTQojIAMN7oM0wKs1gNiEFiVawylPdCSdIqw4yO6x/OFgp
         iYLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768163972; x=1768768772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P/B6ir2X1iP6OIYfvHzrgy+6QEnGmGpOcZQdGo4rUmk=;
        b=K6nio6wHw8I83ZPAyvYmD01HT5byUBRRrn60nK/4SqPaNxKdgKA+1QrzC1Clcn8FtC
         PUvC+fS0OFp0muey47tgLXjcIFeMgRatELNp3GD7tWuN0w4jpJM3pnPAzY8GH3adbhaD
         dZkUe/OvVxIE4He9rwf0kMotpw7vcFAQ54ftixMSstwYaU5VdK80dbuYaAd4CDn51bzu
         G9PqgFHU7HFFhBjvJL1gg/AyQHkORQlzwNOeE/rClt4PDTojlF2CDvuTgi8H0x2AJPbt
         +B9ReSQxt+YMb4rSs5/cA5j8S1FrjSnQ/WNijw4aDKePryfuREFrM85bEWg3gvyGsFem
         w5Ag==
X-Forwarded-Encrypted: i=1; AJvYcCWCunYVUOHo+IzCMiZPk/C3/PMsuCU+lUXAo6wRGrzAmJdvuXkhV2M+EPsTzmzpRRSn/b9qB0V4oE9lSP9fYLc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwadCDF44JpNZ9WsKuShy1X9OcD6KTnCp89u3fzdrhMd+Gcvvcl
	5+XLlXCQAZSC2uPw9ZTWAKSKJGOjbA99Uw31nP95p4RX1Tr67Flo6u41EXVF54GwgtAp2eI/GNV
	PX/VFSb9kPodeBJxaMlQ/PuiAwADL0Hk=
X-Gm-Gg: AY/fxX7zct+dFKXbpUuk817gKAlcWsXxISEZOXk4fW0rYKB3c0iLPYlzuO5x5znWGJ7
	iVCA3LNmpAO4dixgnrN1RlVJKZs1MbU/juKYXSYCv303jqm7dTmfyAFZE082SGfPUICyYErzsF5
	jOoW1u4nTpgdRzY6GfUYe9GcgRAuaFxWp2STLq+OU5MozFgJOFgSPiCbhDqmXQOvhO1dh8trcnW
	ESoJciJyZ4P3XWSf5eGy3QOwjGGry0LdtVcKeKiEXyXw4OZhmGCG9b6fxs9XiwWTYZBmgIL+tiM
	ThEQypkJ6vpJpdK2dGmSq3Q92ksx
X-Google-Smtp-Source: AGHT+IHgiVt0XZYHJifogGXKM5jKONG9TLKcspZkda6yt0LOWf6kO999+bQ8W8E6x1OgBeJWn9LEF0UE4NTlDMeG5Us=
X-Received: by 2002:a05:6102:c8d:b0:5db:293c:c294 with SMTP id
 ada2fe7eead31-5ec8b94edbfmr6899220137.5.1768163972469; Sun, 11 Jan 2026
 12:39:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <20260111163947.811248-6-jhs@mojatatu.com>
In-Reply-To: <20260111163947.811248-6-jhs@mojatatu.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sun, 11 Jan 2026 12:39:21 -0800
X-Gm-Features: AZwV_QiHay8kyrsuwvPurpt476Csb0RIB49hzdeCN69NIk-5IDi1jZbzUDbC3ug
Message-ID: <CAM_iQpVVJ=8dSj7pGo+68wG5zfMop_weUh_N9EX0kO5P11NQJw@mail.gmail.com>
Subject: Re: [PATCH net 5/6] net/sched: fix packet loop on netem when
 duplicate is on
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch, 
	netdev@vger.kernel.org, jiri@resnulli.us, victor@mojatatu.com, 
	dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me, 
	William Liu <will@willsroot.io>, Savino Dicanosa <savy@syst3mfailure.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 11, 2026 at 8:40=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
> -               q->duplicate =3D 0;
> +               skb2->ttl++; /* prevent duplicating a dup... */
>                 rootq->enqueue(skb2, rootq, to_free);
> -               q->duplicate =3D dupsave;

As I already explained many times, the ROOT cause is enqueuing
to the root qdisc, not anything else.

We need to completely forget all the kernel knowledge and ask
a very simple question here: is enqueuing to root qdisc a reasonable
use? More importantly, could we really define it?

I already provided my answer in my patch description, sorry for not
keeping repeating it for at least the 3rd time.

Therefore, I still don't think you fix the root cause here. The
problematic behavior of enqueuing to root qdisc should be corrected,
regardless of any kernel detail.

Thanks.
Cong

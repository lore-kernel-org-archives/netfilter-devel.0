Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D937726AFB;
	Sun, 22 Sep 2024 09:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726995905; cv=none; b=NAJu8LhhyZQjak+ZY5MG5xZ57b9l/ktx6jGxRo9QHBFsvc7qwtNwgrw5FLjCec0h+HFA6Lsu7qPzV0EcoGCUYH7XhbCpJuKescYowJHi9xZH3ajwRHwlGY/hYogAcyuxjC4TlkCRItJ33kJbgohuHeBfZ/PkjVA5pp+Sab0Jur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726995905; c=relaxed/simple;
	bh=9ZNP7TFHAZc3BRVw8xuCm3iEcUlVEkdaSYKgk/Cad8Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T3sJjY0CZ6r1gZEOxsZR46Uq/9BJJdtIOc7uzUSauAbwA85PBtyOHpcoahztLBUOZUqQ011PphBPAM32U/XP6SNyErYx3DmgGvONsOXvSEU8r6kN5S7yfszUy/1GHzfnJQ+rIK/txau9zG94Sg/mtdiCcAcCeQcPRIz3/zduoA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fisVST3e; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fisVST3e"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f759688444so27088111fa.1;
        Sun, 22 Sep 2024 02:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726995902; x=1727600702; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IyCSaKvDj6Ef0oZyW1GXq3YNjZVJNRSaQyvNjHyvEw8=;
        b=fisVST3eKRZ4UrHUqWkADcGyaCAe0Lz2OSxnKp/wXYxWa9J71OzAaD9WabLPP8cuEX
         d5olDI77ZqFSRwPVX3Paa/JZ5FDVrWi51mCzjlemvwop0lV1Pk3+RBx6GRaDr7LgBDdL
         psD4mm/r9lXFUTrIHzgAxDsm1chgRLEevlTzSl4yAxs+NNrkbA3y3ygs6WKJX4qQnKoE
         npdwskUyR71QJanp8Ov5emrvx/Tw7No0hRp3nR3FDmZpgAbEGWoBJJjibtuH1ZEkOAPC
         bYAwhGvpobHvtubu9LG1GoZKWJZ9Fv/x4q2YAh2cP0JHgIcPPytZDPxHF51lvfrbAHwJ
         BVZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726995902; x=1727600702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IyCSaKvDj6Ef0oZyW1GXq3YNjZVJNRSaQyvNjHyvEw8=;
        b=bHIJVnpi2x8V5XsJeO+srgGb93mS/CZDeHuvR2ZuZDkrqqa1lv3E/ZPdmbZUJDahky
         +tuKKVpXbyEBLelq/BxnFPANOwWVm3YcV+FxOiigUnre4oTTXfVoiDisk32EFBBOQ5Hp
         BoTxFSQT8Bb8DrJUJ2XNfdqvIckbR3V3Ws+GGiq7HvfGRY2jfPQnA8Ym4qDnoXlMVP2b
         gvnfsb9qPNix340H3cOKT22Db8CyxZ+iKBx5NFU5Saqd/pJwWucPpKeFhfJbHzhzh2ZH
         rNF5UgzPg76U3FbzBOYJjnLoxxRrSbyu1CFlJWlkquzHR0CelNbQ0KtOuF+bosXGtRYf
         mHmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVmoaFXpFRZiMbvPwhKD8H/68JXOto3nmmuk/sWh0I+CGDvGibzpqXeXpA4LaPP5DzdwI4NUlx@vger.kernel.org, AJvYcCXHAQC7rSu11UtJq43ECQSPH16dtuWxOF6mdw8BCbPW+MKUd/6+wDzdKT4GIvXGPxn/zQCwuzUhVbE+f+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw542mzuiaB/BI26Yx1M+pxm0W8XLrAe+VbqeDnJ8By5Ubuibv6
	OdMhH7B3t6NQKRHdTx+zbJNjAHFBCoGUHS5UWAw3857zBfrqf4658A4oykBAteaYiR9CUBGJswQ
	i5ZVLqPjKRW69S9c2GhTb9rmu9+w=
X-Google-Smtp-Source: AGHT+IGm4zJHHGFfR6x4MQzoJiQIvx7ANR+hP2qGj10bxej/hKm3MdCZmaZZIj8EF2P8+RsapeoKaI8fGBxoZD2WQJA=
X-Received: by 2002:a2e:b8c2:0:b0:2ef:2638:48cd with SMTP id
 38308e7fff4ca-2f7cb335ea2mr44468641fa.30.1726995901662; Sun, 22 Sep 2024
 02:05:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829154739.16691-1-ubizjak@gmail.com> <Ztc16pw4r3Tf_U7h@calendula>
In-Reply-To: <Ztc16pw4r3Tf_U7h@calendula>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Sun, 22 Sep 2024 11:04:56 +0200
Message-ID: <CAFULd4bUoeviAnomH38rGRa55KSkz3_L49Jqw3Tit4UCdywpnQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] netfilter: nf_tables: Fix percpu address space
 issues in nf_tables_api.c
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jozsef Kadlecsik <kadlec@netfilter.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 6:14=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> Hi,
>
> On Thu, Aug 29, 2024 at 05:29:30PM +0200, Uros Bizjak wrote:
> > Use {ERR_PTR,IS_ERR,PTR_ERR}_PCPU() macros when crossing between generi=
c
> > and percpu address spaces and add __percpu annotation to *stats pointer
> > to fix percpu address space issues.
>
> IIRC, you submitted patch 1/2 in this series to the mm tree.
>
> Let us know if this patch gets upstreamed via MM tree (if mm
> maintainers are fine with it) or maybe MM maintainers prefer an
> alternative path for this.

Dear maintainers,

I would just like to inform you that patch 1/2 got mainlined [1] as
commit a759e37fb467.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Da759e37fb46708029c9c3c56c3b62e6f24d85cf5

Best regards,
Uros.

> Thanks.
>
> > NOTE: The patch depends on a patch that introduces *_PCPU() macros [1]
> > that is on the way to mainline through the mm tree. For convience, the
> > patch is included in this patch series, so CI tester is able to test
> > the second patch without compile failures.
> >
> > [1] https://lore.kernel.org/lkml/20240818210235.33481-1-ubizjak@gmail.c=
om/
> >
> > The netfilter patch obsoletes patch [2].
> >
> > [2] https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240806=
102808.804619-1-ubizjak@gmail.com/
> >
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> >
> > Uros Bizjak (2):
> >   err.h: Add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() macros
> >   netfilter: nf_tables: Fix percpu address space issues in
> >     nf_tables_api.c
> >
> >  include/linux/err.h           |  9 +++++++++
> >  net/netfilter/nf_tables_api.c | 16 ++++++++--------
> >  2 files changed, 17 insertions(+), 8 deletions(-)
> >
> > --
> > 2.42.0
> >

Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696F51DFCB;
	Tue,  3 Sep 2024 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725380413; cv=none; b=P274ovIPIA2m30BGhAYJnLT8Kop4hYL4lWDzoqZ+vZkNRIxbddwmxlOwO3vqlxZslzJ0ibZSwLNFtWk2qsCCRj60yVc/JZ/fkSN1bGFTRy/vNpLx40wmnyEhi5CpPPXXyUVXhZGXnuZzZ1Vj5KBppXw2Jm91Cyj8xR85eJk+0os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725380413; c=relaxed/simple;
	bh=kU60dZi/5tUizJ2hHxOG1Lno1caiHGBgxAEiEnaaI/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m5UPLoIqy7r4DLlu7uhIKvvVUj2pLDz53EQW9mH0UHKcVJ4rLvOd90OFASjeoMQUJqUUYQGo8q/yI0QzLgzVD6qgvUanSoZ/KTudw8LvYJ9wele7alhEOMiEAMBtBMyA5R4MJS+f6zMP7MafXo7JwH4mgLR68ZXgMhVax44TvGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AdIVNYcG; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AdIVNYcG"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2f3f163e379so2534151fa.3;
        Tue, 03 Sep 2024 09:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725380409; x=1725985209; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eg+e1TxP/Op9Jw93xjWXFvNAEp6dpRVhx1w8c9CEMg0=;
        b=AdIVNYcGBaWrg1y/BUbsw17Ib5xbumvcTRs4ivVst15O/fMP+qGNL0cio/DNTDYO3r
         wYuzmHBD0+mTjw23kJR62UhPH2DBDh20vxP5hU7yqNK96oYCuDOYVg7VdYOLk5OLwWo3
         XcEnX4YM5r6JPoOBjH6sGOG0WHKW+zmGE+s6scc++VXe88z/kEOV9N+LrbFzbKrXU1nf
         GCiriX6MyLry+zXkVXGodKHj5baCkeh7xA3i1LBNs6rWBW34RTR6Y+CLcBtWyrz7rURl
         0V8b4PEBqL/ND1SHMXqOgo7hSkOnMESdrAfLsoXTYOKjw6tLugm1sigx1jkC8/F56omv
         ngPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725380409; x=1725985209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eg+e1TxP/Op9Jw93xjWXFvNAEp6dpRVhx1w8c9CEMg0=;
        b=Pj80ZMkNB4/2fJR53euv3oRX86SxIS2gNoleNcz9QvW5/yx2km4pzNPjvNes47AFCF
         uHZiIcjp8sBhDG+DZrxVJWIeEc5Cie/79I5z2Ke1TWJeMi/68nXnqsGKExsYVhcATgKZ
         5Xw63jeY+IDuEK8E/p08s0+peElh2zFvYZ76PZoAUTiPP7A3hb7lM4aSDvqvoaUaRFKm
         U6JrFWB59z9BvXwgD1+8LmEB+WJirr0cH2qoUwvRYnZ2CG0XtEIjXF/cRkME/VzZUOcf
         gAZs1Hn9bf/xIMamioWrIb74awoCiK4bCPMGxXJlGLsWUfumws6T9Yham5AQjIXAQjlB
         ZnTw==
X-Forwarded-Encrypted: i=1; AJvYcCV1oyE6uQ3AA5AV5VsXGe38wYZg51ds74ZNgGr/EDVl2ger8X35eVyIPXAo/ys9ZtjldlvM2U/F@vger.kernel.org, AJvYcCX25fA/hA2GDgKvZvqpt/3d7QeDSJ+e9iiWWHJ4LeL5U18KdWsbgvgosJB5HO/t6cDQRs5lvx25Q1+rr/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRKwm2ENi9vD83FWGJsIbCrhZxaHGZ91DjKLsvC314E2hm8T8l
	WPASrhnXBayxLW7vGXIQSQARr0d0tPZ+3CNVDql5VBhMUKlgXupnQgq71zFv6JERsqcapCDiPH3
	9rASqAKc76AGyxRrJksGTQtPIzzY=
X-Google-Smtp-Source: AGHT+IGbuJMzCcU8E6GuXGE3Yw1Wnw7/FaQcsnCRRQVHXCyizIgOX5Kdra1kU41zTbMVeftv64aqZc3t5o/t96RE08M=
X-Received: by 2002:a05:651c:220e:b0:2f3:e2fd:aae0 with SMTP id
 38308e7fff4ca-2f6105c4b9cmr163510071fa.6.1725380408920; Tue, 03 Sep 2024
 09:20:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829154739.16691-1-ubizjak@gmail.com> <Ztc16pw4r3Tf_U7h@calendula>
In-Reply-To: <Ztc16pw4r3Tf_U7h@calendula>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Tue, 3 Sep 2024 18:19:57 +0200
Message-ID: <CAFULd4amgCH=h02SSEdxrdazq0A+5wOZgvPmRmn19eb7orSV_g@mail.gmail.com>
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

Yes, patch 1/2 is in this series just for convenience.

> Let us know if this patch gets upstreamed via MM tree (if mm
> maintainers are fine with it) or maybe MM maintainers prefer an
> alternative path for this.

The patch is accepted into the MM tree [1].

[1] https://lore.kernel.org/mm-commits/20240820052852.CB380C4AF0B@smtp.kern=
el.org/

Thanks,
Uros.

>
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

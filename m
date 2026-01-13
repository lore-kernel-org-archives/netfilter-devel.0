Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB038361DAD
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 19:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768332747; cv=none; b=RPJFA8K8XLQkj9IrpG7PNY4HMkWSPkzUPCCFy782CXBMHZ3koYGN/VH6x+fcsolmyweELEzcSvPXpn5H9lsIB60hxkO5yThXVar0opkdCqBUBWAbLlllnGLPT3LKR/J/KjWsGpoH+fI/CGgFsryutflGc+1PjdDh5/kTXSAyIwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768332747; c=relaxed/simple;
	bh=d1VCtjj7cVya6MZTtBwlMZaMcgKCOHjzsyH210DJl/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LOVuOtNAbXERL6IqSunftuX6fBAUquzLuO3eVcN/StrzvR/ae9ETW/Hi03p+7aLkN6WV1/UsQC1eGU/vcBe3s1xxf5/pqkz4hJX3n5MI97nAn7K7NgKUr2B7bjvAtqDpXC9WydN7pLMAulqu/fn03So0FqBk4+FYDgCFEkk2QeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V73C823r; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V73C823r"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-93f5761e09aso4594108241.1
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 11:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768332744; x=1768937544; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CzAcQXW0+VMrSsxc+AImvg2uuT8BF5o11u9lZ3+Xqcg=;
        b=V73C823rrijplqq+pgi8vUwfUHnvs/J7KkhLcwLOaXRBPnanDOr59XdOSrn+RHsn5C
         UTUVSVeL/gZFVaKg8PquRWtGWsn+NLU1asE/se6pl9jsqLcY2xtRKV1zz/hlBhjKuvDe
         DMZSo2dm7WgS32b0kY4xW8pYgAC6UUcDaWjXB4pZTsTJqA4VdNT5cA1X8/e7LGxdEBjk
         Aez9Y6WOHpUQq5o0VEOin53/xMvBbtqRION4RefFeVu9oi/uf2DdGCPJXdjRMGAj/iRH
         RFQ0gyQDYNYKzK/TGrK1P4b0e5Hu/QQQ/hFwjgb/qIeF5BK6pypqXRnKGOgJP5Y+196O
         0u+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768332744; x=1768937544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CzAcQXW0+VMrSsxc+AImvg2uuT8BF5o11u9lZ3+Xqcg=;
        b=Du6Pdgmyeriz+VzifKgjg+ZRGvFptUAW/twazActki9JroofoLBeT4vBkk3QkQ/SFM
         RuMCI6/QaC3ckV9k43KQAiebKyHIaK+ysc1GYTsODIIxFDJ3Jre6vcB/gooIlUjFRmon
         VeFVx/D036L5AldKVMgRNb4D/Kl2g702uvXaYC5aXwS41Bmwn2oEFmx3fW55V+Is2gxv
         PMesoRQxG6Q/BmfPqViuH/xg+NH/f8MXbqalEbSbN1VGNJ5v7p4x1dRmCxsF9tTQ795r
         VlphQpFhUWQ65D1oEJvEWDk2WVeSLmqeLWKn3XAfV5USSetr/D9Wg/UkHKwztr0C6uP2
         Ynxw==
X-Forwarded-Encrypted: i=1; AJvYcCXusF47axP/Vyi1Ty1q/Qps7idoxkW+KSM8gbDycZgDEMGMb1H8zB3BRVUzDD/zaBgNjSTN9sEZGg9skk/f9oc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuEQzckdlWu8u9piMS8ODe8/BiA874J2z+x3fMVvj05/RJkMCY
	qrFaAO5txF41MKnNt6QUwZp/9+ARieoIQqOfwRxB5LxmDMr7erCkwYB+ifUMx7DyQzMHZnsMf0E
	ckNzFd6C3DEBBf9b2JAbmFGyukDbB/oQ=
X-Gm-Gg: AY/fxX5yw/TlR05t2XSK/De1ZDRQo+HGgL+0P2XHG6vb7dD19dc5tfGJn9TTBwan9JL
	66wyvmYL6TqZh2eV0jAAjAqX8UcEbO4tenTH0DZ6vRRoQtJ9pzVmOzxUtDuSOXtDc1colcSxZ0R
	1IoJqqCGWcc4O8/Ekw2IV2NqucO+m/IZ/KbZxPFoi/JkZnVpp3DgZ5qXLh1WLO0Nt5xtAlIin2v
	wEn2oD1FfCDX9BXuVD1Y1GdcWRRqAmxj/fm0Cu9IxP7O0YijJ71+rfj2iq1CHLuUJSFNpIIiB6T
	oKgknOErqmdCj1t/woQA+UBy9Qgf
X-Received: by 2002:a05:6102:f86:b0:5ef:a9fb:f1f5 with SMTP id
 ada2fe7eead31-5f17f444459mr165987137.14.1768332744506; Tue, 13 Jan 2026
 11:32:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <20260111163947.811248-6-jhs@mojatatu.com>
 <CAM_iQpVVJ=8dSj7pGo+68wG5zfMop_weUh_N9EX0kO5P11NQJw@mail.gmail.com> <CAM0EoMn7Mza5LqV5f6MMgacuELncbr1Ka6BOi7SA_2Fe3a7LCA@mail.gmail.com>
In-Reply-To: <CAM0EoMn7Mza5LqV5f6MMgacuELncbr1Ka6BOi7SA_2Fe3a7LCA@mail.gmail.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 13 Jan 2026 11:32:12 -0800
X-Gm-Features: AZwV_QgjnKKsEZ1YPPhn6INdNnx6MAEfEoP-7GL1P85eDTVCjK29S422tFLaiBU
Message-ID: <CAM_iQpUEgzQwrO5DJ05Rzx8CJJ660xZPcGqoD_SPJ2buo7K_Cg@mail.gmail.com>
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

On Sun, Jan 11, 2026 at 1:57=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> On Sun, Jan 11, 2026 at 3:39=E2=80=AFPM Cong Wang <xiyou.wangcong@gmail.c=
om> wrote:
> >
> > On Sun, Jan 11, 2026 at 8:40=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.=
com> wrote:
> > > -               q->duplicate =3D 0;
> > > +               skb2->ttl++; /* prevent duplicating a dup... */
> > >                 rootq->enqueue(skb2, rootq, to_free);
> > > -               q->duplicate =3D dupsave;
> >
> > As I already explained many times, the ROOT cause is enqueuing
> > to the root qdisc, not anything else.
> >
> > We need to completely forget all the kernel knowledge and ask
> > a very simple question here: is enqueuing to root qdisc a reasonable
> > use? More importantly, could we really define it?
> >
> > I already provided my answer in my patch description, sorry for not
> > keeping repeating it for at least the 3rd time.
> >
> > Therefore, I still don't think you fix the root cause here. The
> > problematic behavior of enqueuing to root qdisc should be corrected,
> > regardless of any kernel detail.
> >
>
> The root cause is a loop in the existing code, present since the

That's the symptom, not the cause.

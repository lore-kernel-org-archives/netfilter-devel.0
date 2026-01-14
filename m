Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD57394463
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Jan 2026 16:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768408448; cv=none; b=dN24AgKUiJS++zsaCdG4NRY+OcNxfyODm+vICku8Zoojv8iJNhHph47+aBnLBNoltF8oi86dyH5LmVjGF6n+8EA1qtBdku5vQdC60YevDaINbYGDFW2dWx1ysvoI8S9HL0NGBj7V9z1s1W/i2tJ7KzZWtPaDW/MjSkz7dOvguiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768408448; c=relaxed/simple;
	bh=EV0/yy7esrd7Dn9sH9OIVX7FqE756S3/nAr8EYjENSI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q/Wnf2Qly4tRNGsqiRD9nT+ffqL+8/tazmnyy5xV8ewhj3EZTmwOzwODoE2/quk4O6Ep8nwhKXgjaIHrUlANA7M/sNDdal6agUJ/qhzdy/SNfGKR9+1TkY3QcpXHxXxd4ls05PX7Y3KAgVDTJZuoq81MoFIdC/uu4MHOQy7M6Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=hQr9aWtf; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="hQr9aWtf"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c06cb8004e8so14725a12.0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jan 2026 08:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1768408446; x=1769013246; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EV0/yy7esrd7Dn9sH9OIVX7FqE756S3/nAr8EYjENSI=;
        b=hQr9aWtfrw+gtHD4U6I6cvT8E7pkTDipQoYvNrrUmLaIZC4Wdh4yLFhnhSkXtgd1iw
         v0+5JhjPkgGKMgaY3ri1YhafS6lUIwxyaLeCLe47Z4n4O6z1zozA0iYDmAZ8PaUYThPe
         AfZp2KtR1aB/P1oOrpl/JOTHr+1qUTwZNfgvfGeiTIzV3eWYqlUl6HOvZvSrK0baT76M
         fFDFeHeQpkVVtEszZFnvoL8UuQMvmOBFOKddWIdWN3At8GFvGQSq8fpJ6E9W9TkI7sdj
         crqBLkrkZjvWfhb9NY4LpBFL3+c7m2WyvhYpxvZ9TtnIY5Cgd2/jnwTMGwHRXfP5+a0O
         gYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768408446; x=1769013246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EV0/yy7esrd7Dn9sH9OIVX7FqE756S3/nAr8EYjENSI=;
        b=TAcTdbJl1C79D6xOGWsm7/mEgvEszz8lCWwxMqGaI9vLAuK+aZ2ReASOrA7ghbDFE7
         DhUIQ9ueskO7zU88z29iNy03cEBFi4fhOH5IMmG4r+dZ3DlbDRSZsaBzmynvAmA2lpSk
         H+HJfx3/USk6hsN5fiD6AzWdnX+IrwEvVqmDldInxInX1DHXIxmu7as2aRGunV01xkOa
         41nGnh9Jqd+3o1sITXTZaacciznR1Wt1+ihrMpwJX8KZgg8io+izBhrdj0MglTvgCY/w
         +9D4hdpIor+BsVA3R5rMgB+TGAYzduf9euLi+57GW+c2qKw75Fs10szEWv71vD03MgLC
         jT2w==
X-Forwarded-Encrypted: i=1; AJvYcCVrDepk0fo1Dg1XnSrLl+RxgAfmTv7rTPsvOM2L6BeM7E9KjyqC7kbG6JI+zkJt5ugt/a3a+zLJKE7YFOJkUVI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTBnMCNwIKnqJDd2zHSLjmHVZaHLnA0aw+WbkuYnlt/13ylpVh
	wQVm4Fz0VJ3dvBHcAxgLn1P22b3xLiAthkGDx9APUAANNOVbK3Yo70XTVAXXKyC1JzGOm4wzsLC
	QqUnx1h42hgVGkW4XIQWo16DQcirb6khOYzWNWddR
X-Gm-Gg: AY/fxX7v4FH2H302UgS+jb8/kU9nUefi1JAXIMEfz0X1Yx754Q2L6FDhb1zdcK6otCn
	JFiHsWLUwkm7zJOa7LrY6orfAAXIMCsExwuPQHiywI5oabO+/vrIkFDHiMdxIQPB1e8zwROzCqB
	LzHlfLT9r7Stfzw5r2kqP4dIxERzopEZPxpJ7IGQgZwacZ9lidxfbXnpyLJ8RkfPfahJOGghwIs
	Qs1eAbf/sXbucGVNvBeFfMoAGmX41BDi7/OoH1aC+CDT+TqmHtCyU6OY/ykLzZeaIo1KD9io9Aj
	/JqKTWRYe7hNXw==
X-Received: by 2002:a17:90b:1f83:b0:32e:5646:d448 with SMTP id
 98e67ed59e1d1-3510b12673cmr2360317a91.21.1768408446393; Wed, 14 Jan 2026
 08:34:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <CAM_iQpXXiOj=+jbZbmcth06-46LoU_XQd5-NuusaRdJn-80_HQ@mail.gmail.com>
In-Reply-To: <CAM_iQpXXiOj=+jbZbmcth06-46LoU_XQd5-NuusaRdJn-80_HQ@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 14 Jan 2026 11:33:55 -0500
X-Gm-Features: AZwV_QjM9sCmciqd-3G5CC1tZ7mrTsZr3pe_blrLR8iInt1cI1E82GjtFqVpO9k
Message-ID: <CAM0EoM=VHt3VakG6n81Lt+6LFzOVKAL-uzjM2y_xuWMv5kE+JA@mail.gmail.com>
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch, 
	netdev@vger.kernel.org, jiri@resnulli.us, victor@mojatatu.com, 
	dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me, 
	William Liu <will@willsroot.io>, Savy <savy@syst3mfailure.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 3:10=E2=80=AFPM Cong Wang <xiyou.wangcong@gmail.com=
> wrote:
>
> On Sun, Jan 11, 2026 at 8:40=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.co=
m> wrote:
> >
> >
> > We introduce a 2-bit global skb->ttl counter.Patch #1 describes how we =
puti
> > together those bits. Patches #2 and patch #5 use these bits.
> > I added Fixes tags to patch #1 in case it is useful for backporting.
> > Patch #3 and #4 revert William's earlier netem commits. Patch #6 introd=
uces
> > tdc test cases.
>
> 3 reasons why this patchset should be rejected:
>
> 1) It increases sk_buff size potentially by 1 byte with minimal config
>

All distro vendors turn all options. So no change in size happens.
Regardless, it's a non-arguement there is no way to resolve the mirred
issue without global state.
It's a twofer - fixing mirred and netem.

> 2) Infinite loop is the symptom caused by enqueuing to the root qdisc,
> fixing the infinite loop itself is fixing the symptom and covering up the
> root cause deeper.
>

The behavior of sending to the root has been around for ~20 years.
I just saw your patches - do you mind explaining why you didnt Cc me on the=
m?

> 3) Using skb->ttl makes netem duplication behavior less predictable
> for users. With a TTL-based approach, the duplication depth is limited
> by a kernel-internal constant that is invisible to userspace. Users
> configuring nested netem hierarchies cannot determine from tc
> commands alone whether their packets will be duplicated at each
> stage or silently pass through when TTL is exhausted.
>

The patch is not using the ttl as a counter for netem, it's being
treated as boolean (just like your patch is doing). We are only using
this as a counter for the mirred loop use case.

> NACKed-by: Cong Wang <xiyou.wangcong@gmail.com>

Calm down please.

cheers
jamal

Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB5A347BBA
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 16:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763050736; cv=none; b=ho4LVF0nLBVcO0b27G9KI1ihy3EdoJm/Az7hkkEUks3rewVW2nBMrf3cH4c79knQiThiq9+LVilTWN9Y8sPqsgA10bfkrnLwRDDj5L+KVWp6+4cL+xLJ/5+hIwHBaTpBr+ziakjsnK+mXKJ6joBJWh5gPMttDdR3FT1DbBnCLeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763050736; c=relaxed/simple;
	bh=X+jglSuIcAqBj4r2Yvzejgtem7Zuj3d3HuPiUn8D4x4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UoQWzbDOW7Ah3MKlaMYLWNJOb+aghApQzJeOwISkmHx1Hh01x9QIK0uDqUlYqVmUUTgSBFTbFoyYvPqExEWz4UXk6qQxxOzUYdcgyBVR2r6WBtn59OqSffe6IlZRN9U1KO9iIKfK/u6dXgVoH3SrQuLaJsXGWOFnIneI3WqWMac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g2Hxzr9d; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g2Hxzr9d"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-5dbd2b7a7e3so712324137.0
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 08:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763050734; x=1763655534; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+jglSuIcAqBj4r2Yvzejgtem7Zuj3d3HuPiUn8D4x4=;
        b=g2Hxzr9d1+BSv+THQ6Mf2zWVTLYFPfNC0n+CgAzWx4ljQRadWCZssG7VITcPJ/hdwb
         SfhWo508HygUpzjAoiUc3a1ooLqcasT5utH2z3Dp6muTbYmHa9N6WFd7rZJovYMtDlQu
         g6xMxN/o7TBprchv4nFV6515aowPDnqKV9QFHMDiwZwssURu7zQzhqAPPjRV8+HA0q2B
         B/frdEHcLxNCM5LYGwqqzLXv4qBD+dwRoFvmsfrE5HdrL4VKtDUlW/YETWvG1Dc+Obai
         WE+WCgAAGHYKbBbzsFnRh70tvOoQymvEr181iJFSPQCmhdcV8fYObR/3RdxhIB/A3ogg
         FhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763050734; x=1763655534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X+jglSuIcAqBj4r2Yvzejgtem7Zuj3d3HuPiUn8D4x4=;
        b=TNW8ZPgc3iY/1BaOOJSVzBamOxcc10qWW4oZbDtFfT02NP80yxjRZZOKQ01/p2DOwr
         qxZ0ekp6DQdYJDafFlEKk78IQ4IIrL7DTjI1tXKXuHbpRu0cbVR65MpRxS1cHDaBiQN+
         RevKT2gRDBMvwHRVzgAF1STnTok/2J4wsx88eXaB6J2WD0JTtzjbVVzPfYAlhloN3qnl
         OEzpSH6qmDsHHcn6QD5tm5uDpifVvx5nKLdB91Gyu+xaGl59drM9iobp1hozjUNkjcfm
         U4dMSBb6ncyFTXfQfz7ZnRe20OQxtnro4fi0oAnU1Ad+EgnyEbM4s1FMLqoQBPj8Lg7G
         kLhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAPnbDOZMFhs4MKCoMrMYwn52rwoPkv70jdh/kPLw2b6wPLzlL0jgFkFSKJdNQ+0TqN9QVHJUIUoYztcvrq3E=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywcu4YVI1z4mEub7sYjDuuc2eqYqjcPRcvIaENzBGw+w1Z7SjD9
	aklvtchBIfXLka+kkkYSjuWNad75/qkAQxDST2pSCb+pUcd1bf5f0/K1m8iJ2XHFXy8bxQDLds4
	1fYD03xjevRqLpfAP5PzAbFPNbwLpfYY=
X-Gm-Gg: ASbGncvAtT43NvK/UWFUti0PV0DFhwRx5KC+oWAmQPgGXhjo4k7aLePeY75LdTELjvQ
	7yB+5DPfb7KUWDtWtMIGjnOtx6J3JctS4n+oKXknGEyKiyThXkl0mH+LmSAvedDStCHwh9aqcIt
	Km1diBxTKSoPCmu83t+0GQvUwb4bfODehQBscKCdD76qMbt1NcledOHoAhQnMgVuoUyWoXuGZCF
	TF6Jxzz/SFEuypwOn72Y5jW2uHW5sFO0lockgAh9JV7YIygQ2Jxkh12xq01O98=
X-Google-Smtp-Source: AGHT+IHQlvloEzjKkY5BkMvD2gAnBdnRNb1amCMLvHF1Utj0ORHdSRDHFy5DC5NLvgH60/r/vrHA1AW5hpH3I+XpRwc=
X-Received: by 2002:a05:6102:4487:b0:5dd:c3ec:b5b with SMTP id
 ada2fe7eead31-5dfc5b72883mr124216137.31.1763050733707; Thu, 13 Nov 2025
 08:18:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113154605.23370-1-scott_mitchell@apple.com> <CANn89iJ_b6hfj96Me-8AZN92W+cA52HpGcu81J0MNtzeahpfXg@mail.gmail.com>
In-Reply-To: <CANn89iJ_b6hfj96Me-8AZN92W+cA52HpGcu81J0MNtzeahpfXg@mail.gmail.com>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Thu, 13 Nov 2025 08:18:42 -0800
X-Gm-Features: AWmQ_bnF1bGJN_bDR1NS8Ie2R0lRRCVzMsqRXHPobd7cBDwaINkzoduMtW9VB0s
Message-ID: <CAFn2buA+uHsRLU-TG9Xy42-pATex9Hh7kD4uCtcVRHAKVCgZow@mail.gmail.com>
Subject: Re: [PATCH v4] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
To: Eric Dumazet <edumazet@google.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 7:50=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Thu, Nov 13, 2025 at 7:46=E2=80=AFAM Scott Mitchell <scott.k.mitch1@gm=
ail.com> wrote:
> >
> > From: Scott Mitchell <scott.k.mitch1@gmail.com>
> >
> > The current implementation uses a linear list to find queued packets by
> > ID when processing verdicts from userspace. With large queue depths and
> > out-of-order verdicting, this O(n) lookup becomes a significant
> > bottleneck, causing userspace verdict processing to dominate CPU time.
> >
> > Replace the linear search with a hash table for O(1) average-case
> > packet lookup by ID. The hash table size is configurable via the new
> > NFQA_CFG_HASH_SIZE netlink attribute (default 1024 buckets, matching
> > NFQNL_QMAX_DEFAULT; max 131072). The size is normalized to a power of
> > two to enable efficient bitwise masking instead of modulo operations.
> > Unpatched kernels silently ignore the new attribute, maintaining
> > backward compatibility.
> >
> > The existing list data structure is retained for operations requiring
> > linear iteration (e.g. flush, device down events). Hot fields
> > (queue_hash_mask, queue_hash pointer) are placed in the same cache line
> > as the spinlock and packet counters for optimal memory access patterns.
> >
> > Signed-off-by: Scott Mitchell <scott.k.mitch1@gmail.com>
>
> Please wait ~24 hours between each version.
>
> Documentation/process/maintainer-netdev.rst
>
> Thank you.

ack. I will wait 24 hours to address Florian's comments on v3 (unless
instructed otherwise).

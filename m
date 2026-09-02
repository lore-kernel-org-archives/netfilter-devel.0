Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B584D443A97
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 23:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788390415; cv=pass; b=sBei1/AIU6kAWAqxPN9Qhq0Fm6qjdM5qvlB+30TFvI/mDJ9JimAPwW6XZNcsnv6KaV7aNsC6VnSe8MWWc3PLLLT1y44g0OtuWuHZij+cYeLr17m5KGrhSMY0h4yrCBKFQnzkAm61IhZAa5UplOFcpGMhLvHC2SD8vzIUaJsB4ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788390415; c=relaxed/simple;
	bh=QXO79iuzD6hxpf2i+Z0dPQolgpr8pZk2dfjP1ELM1rE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UXGKdOzTXflREOTgaCulANEBlTDLdaYQ5Ze6uWw6beuL39ZmGBkZVMwTT5xTBqZDGe4V0aDKj+WBG6g1AR8aEdXmTy1SAa7sUuD+VQNiYcLdyJb6Af7W7VSt+/eBmIRHy86SfSkUqpEAReDKtSDKefjjgCTDL1KNgBx7O1scO4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XitNxZTJ; arc=pass smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XitNxZTJ"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d9201076b3so20709845ad.0
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Sep 2026 16:06:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788390413; cv=none;
        d=google.com; s=arc-20260327;
        b=bR4X6v4b0EgxhqHuIP8Q/lflWuIa0er/ZUhWGWr3E8MVskUWvKTZqL7Nh7fiw/zOfz
         fGabM8ML9+gJsp3pmP/Ua0fCo0I5k31fILcQuZD+RSwGl0hz+o1k65Q05eW3mw1paHjt
         8pBjYXGE+w2Adf44WNQ6sXOlRTGvOpxAEizCrOt7pMhdjJ3TA7DeK+PlnvZq8kULhjbX
         FNWrOwWgBnXS/1Reou9rbyPhl6ggMXEj6RRiYNL1PLSg3mB85sA6se+pt7jR5YRcm7hD
         PMKiOVXwkZMYUqf1d/FoS5XsNM6i3ULnMK1diHxJzzuQPeXZS47zbWtwxgur61EXrHEV
         jyyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QXO79iuzD6hxpf2i+Z0dPQolgpr8pZk2dfjP1ELM1rE=;
        fh=X5FQV7hJ5M0cCzBLr2KZ/pjAiVh/aP86+vqpcqImeiA=;
        b=K76sQ0lxm8GdrZmzfDo+nFe+1mAy9tFjtuhsN+cWZh0CCb17noLIzyQmStQTqZIbgH
         YRAf1TGOTbTJS2l6/O0fzRBJNBO/WmF3va0Syrq1lxfYtJDbRTqUMz9h4yJtuet3s45N
         rEQ6ox79bCGmbaXReav0Dto6fw5BrRr49+qDsmlKncwwOukZyJEhg/iByyc67ySKOdhg
         ZaMZZBnpuNcaSTVLqEE47DTHOboCgjL4eDtqG1SxgUwcfKyG0IG5I/VRY2FniwGY+MHB
         XolZZFhtkAX1Yjct9zXEz64VWpAbGTNx8XqGLEudR0ggYeJyUIQ+/GM3zJVKW4iEkiC6
         4DeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788390413; x=1788995213; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QXO79iuzD6hxpf2i+Z0dPQolgpr8pZk2dfjP1ELM1rE=;
        b=XitNxZTJ09uvzoUwOzTftYhHODsEy6nLHo46uZbaIONoDW/z8eo5dJmoVuw1Wv7VXO
         JikoTn+0Xwwed0w9GgbXl4YipeoTlB/mZ2IFYGbPqgUpBzNWpJUweZOjWQ7pWus8rq+c
         YQYn2ltbPZkQ7wR6P4A8F7Q2NLAuRmhwJrTm+d4xmC1EEenqOld9yaxGOFmO3f5SmLjI
         52L08G1/pdooVZ++CucMGIj3vUHptDpZUHKyxPPs3c76/7EfmMNRmEY5iqkmg3PAN5xn
         ybPJD/DwG9Bb+2QxC151wb7nOiq/jZMivMW4/VmpxbV6Ls1GxjhuFowL4jTxG7hLxhVr
         yD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788390413; x=1788995213;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QXO79iuzD6hxpf2i+Z0dPQolgpr8pZk2dfjP1ELM1rE=;
        b=LGqZiqkglvIjRoaQkM7Ems7ww3GcbhxISnw7My+jYXrf8L2Ee036FkBrYBlZrPgIRz
         H9LJ7btOVpXvKYRlX9hOZBgGgJpDfRSOPNM3FyjkIUaBfh/UvLEfNMPlTsuzB8TnJaaI
         ZTNKzrdf3IDep7+bsSoM3PrGLW9FcpneRM5/Oop4dmzqwBru32FXRSik6lNpH7tTsgU9
         JMfA4fqsm7YkYPNvADXRSIL4y2ij2WHW4iLUOPfBHro6oM48Wf6sp7/JqSJhS3SDg1di
         3CWbvaxX+Z9X86FQqe463EzbYezFizpMYVqCilpvIT7WwlNe9rUxvkqvVGlYWggwb0xo
         /D6w==
X-Forwarded-Encrypted: i=1; AKwUvBzZuNNUOf55oVjTjbPQ45m818O/PIRCiJyObcysGUnx1ffCd2Rrj0wSJi5Y/Ajg3gx6cZt/x8NA3HJ21oAMAEQ=@vger.kernel.org
X-Gm-Message-State: AFuF++k5OtJhpoYFut+YypkU7M3zVxhCkM53AsyvbNajHbLmj/VrkkeX
	RlNPQrN3opl1DRzxFKmsYyYhTer5jqwMwjNmeVHJePdkrIPVLXBpJcK+PSg2lzrLwZgTxfcY8LF
	yKJTPqre6Y53LBteDcq2mejgIF6vDYmsh5+HQ8vkP
X-Gm-Gg: AYBFou1k/4BUWYbckVnkp8Q7qZTZgeT8eLMop2YvL2UTmh2qxDT9Y2IaywNXxnqHC8X
	QwlImd+jWn2poCWVALVHicgBthGguvqvlhAZlTSyTEBbqAgRcsdsoZOe0uIIvLtY22PdmX7vYmP
	a1N29nbotG7zXp8tRXokjirjYSBL/q/ykY6sf0ObhbZdQFHyV5kNtrYCtCIC5k3X7b84X82AdoU
	i9YLxj5bdObEggNHJMS78rmvvDKwD9IRPsHf92ev35XJyAi0FRAYjGz/geX6Nayre5yQn5GJwu8
	k9MUHpDfwfeiBusAE1jWMXsWYg779fUbYzoKKi7AoI0WhIlGB+t4/B5UoPAAK2qyT1d6tMza/z0
	H1PC9oGfjWl+DJBSwkMHlqPXrVMSYOgqtkWU94wxquyVBPt0Xf8zG88yrve5VtH+9wKEAqqrIDx
	Fpx0w2kBgnjw617Es/3Yd0R4w=
X-Received: by 2002:a17:90a:e7c9:b0:398:9bd4:d12 with SMTP id
 98e67ed59e1d1-39aee219f45mr11238909a91.17.1788390412505; Wed, 02 Sep 2026
 16:06:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902-sockmap-lookup-tcp-leak-v3-0-b998b3d49d07@rbox.co>
 <CAAVpQUC==6KEBs3XgFjZ536mJ23cbHma8HuiWMu1DRc_=YYOHg@mail.gmail.com>
 <20260902155216.4fa23444@kernel.org> <CAAVpQUAWjBuF1Rgze0Vt_XvkUT=Ajw-F+Kh+s2iHk38c8iAapg@mail.gmail.com>
In-Reply-To: <CAAVpQUAWjBuF1Rgze0Vt_XvkUT=Ajw-F+Kh+s2iHk38c8iAapg@mail.gmail.com>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 2 Sep 2026 16:06:39 -0700
X-Gm-Features: AcwNN1WMA28CGWvKALBaFm1vrr9aTSS6G_YD085NjQpsHnEJcUtVs3PqmfzqfQ4
Message-ID: <CAAVpQUATOCCc0N1jnfy2+tkD_zj1su-a-4+bV6qXOSzR7y_iQQ@mail.gmail.com>
Subject: Re: [PATCH bpf v3 0/2] bpf: Fix socket leaks around connect(AF_UNSPEC)+listen()
To: Jakub Kicinski <kuba@kernel.org>
Cc: Michal Luczaj <mhal@rbox.co>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, John Fastabend <john.fastabend@gmail.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Willem de Bruijn <willemb@google.com>, Jakub Sitnicki <jakub@cloudflare.com>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Joe Stringer <joe@wand.net.nz>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, bpf@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 4:04=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.com=
> wrote:
>
> On Wed, Sep 2, 2026 at 3:52=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
> >
> > On Wed, 2 Sep 2026 11:58:49 -0700 Kuniyuki Iwashima wrote:
> > > > Several BPF socket helpers acquire a socket reference only when
> > > > sk_is_refcounted() =3D=3D true, and release it, independently, by
> > > > re-evaluating sk_is_refcounted() again at the time the release runs=
. TCP
> > > > connect(AF_UNSPEC)+listen() sets SOCK_RCU_FREE on an established so=
cket.
> > >
> > > Due to several bug reports, we are now inclined to forbid the
> > > buggy transformation.
> > > https://lore.kernel.org/netdev/CANn89i+px52TtJy3S9=3DuHxGj3s-WueguRo1=
Z_4FxO=3D02KLmwmQ@mail.gmail.com/
> >
> > Kuniyuki, would you be willing to send a patch to do that?
> > Not sure if anyone else is planning to, I wasn't..
>
> Sure, I'll post one like this with s/synchronize_rcu()/-EINVAL/g
> https://lore.kernel.org/netdev/20260804015349.2353056-1-kuniyu@google.com=
/

and cover IPV6_ADDRFORM.

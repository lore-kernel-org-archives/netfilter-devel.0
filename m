Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BFC346E40
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 16:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775061116; cv=none; b=ifqBXs+aAI6f2UJvZeKZYwF/w7rDIbIFx6s62GwcJ980DAqHS81lNqz7p/rq7NZVqeP2te11J6a1blORQGMJvVlCtss2dxlGgn6N0OG4TbkJIrkAS6z/zvJbZWRwWmDV6ox13l9QInaDcujvFjQpOY6lNpkiVsU2956lP6yvJ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775061116; c=relaxed/simple;
	bh=ybEdMnj+IV21R50M/Nq06VgnFb302XMUbdzsNI1SGq0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ukBdKrSaUVPBjWnpNtQ7imi9R8ilfOdqN/Mw/+nejpfAto8atf9h9YRyRrF9jnjErEBrReAaT/w8vrFtHMqBQwmZMFnvREbHizd5H183h6y4VPXdmsCMS57NHX4R76p5OdZlmb21feXlEiJaPLbR77uHq78ZVj3M8xSZtWepYuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nz2cL0pJ; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nz2cL0pJ"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-66bb4d4fcb4so7478709a12.2
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 09:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1775061110; x=1775665910; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wMfn5M+yor9qcHDuzn1ye+wM03ph8KGxN0vfAlP2l30=;
        b=Nz2cL0pJLpxRZZ2pPdTAwE74ZZnalePpg8+I+dsyPJWgJz5T4yKM4ilrEzYZnKl4Kt
         P74p/9FRbERKzOrDkUDXqyPKHKlfMqOba6Z6uCOX9OYXff+vqY8HVM2UGkna8NTuHTO4
         f04G4RLlgrS1OeF/LqJkLdWvk+Oq+bNPFz2Tw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775061110; x=1775665910;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMfn5M+yor9qcHDuzn1ye+wM03ph8KGxN0vfAlP2l30=;
        b=cPFMQ4D1+MuSrP9dvHO2HVuB4VYH7M7UaVMqzf6YN2xujKnqrlzeNem3ESXsu1pMQP
         rxxCVFgbV0JCX6KqDVu6ajT5wrQvC5gGmHM0nTf0w1PpOnM7aqLkSqV3n3YopDh4/Dza
         YYTxjzkUKx/mogiSMdWrHrv/A8L41VrRJVrNBCA1dqrWzEspQaKb/07tPrBPzvoOKlWJ
         76/ASwpd8GUNjWKdDEFs01P9+iQKliQ1sm8YF1AKDcynrifQprGHVW97Tmj9ioJ7epJ0
         zufMNQ2IlMtj+T37te5ztwN3rwd3kOiyNPG4VYsmn6wS/ATQe1Vex9inq5SoabmBkLeT
         rV4g==
X-Forwarded-Encrypted: i=1; AJvYcCUBJbQhM2WnhGqxEtiyLjE7yKIjh4k9wbIv9GIIDlZreaiQqzTQo/MgZ69NQwFFHSFA12u+Pj407PS8Ec10Q0o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy26hm2I7x/ImUvrdDHODtWpfhQ0K5KALTFd48aFevFtCPaPXSp
	/gRiKmTdPuCNFXx9Zb8pMObCF6RLOZ1yStzPjjdwkUzcdQskE+PLlwAnvckCalDR+b7ijCq/2Ex
	fNu2ausX6Cw==
X-Gm-Gg: ATEYQzwX1cb8waAs7QuLyWRiHrHvkJaUIipfrO83PBe4esIgZxwHi+7XhHu+FgIGeFK
	UpjpFXrFYnYdV1NMUmy27vtwgsTnj8XicmFpGZ9BqDLzTm98gDOIqdY1a3nEF2CAi02h3LKW7AS
	iPU92rEY8mWtJERAiOtPKqR395uymbxllRswglGyAILE5cxRvCujgQYtl5OPZrJj2Hd4wuH1oSV
	Y6oc5ArLvG7E/Ec19DFjD5ThLBXsb77POTpwXAyNYZNHYFu9Azi8m/Vmj6k4W8xbzkY2fhYL3X1
	+A+Dzho7fVr4CgioU5VLbALsPTd1bAtgd+A1Js/CpZU7E/IqbqMo2z6cp6zPrWnaI/7ZuI7AATO
	gweFWkAsSb7snKMqHc6prxY2Wx6ZFwvF6PxxqxPIb7c1mV3DBV9sxnhQUAGw4chiljPcVlGDmo9
	sWXatkUvWO/X+0F/0z4kvZmzjSw1AbyS9dMTWJNS1mngPwdFQrQYM6TFyX8s5W13MVGwRgQE/y
X-Received: by 2002:a05:6402:1ecd:b0:66a:199d:138 with SMTP id 4fb4d7f45d1cf-66db0af1f18mr2899211a12.20.1775061110448;
        Wed, 01 Apr 2026 09:31:50 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-66e02d44fd4sm15831a12.8.2026.04.01.09.31.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 09:31:50 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b886fc047d5so1146993866b.3
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 09:31:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUw+z4/2drNt32gPGKghQ9mtaoX5L70aHogJ3wdlZG8rAPEBBFeUz+MGjlFfq21qcdmYS0eVDpiho77aP5E4IY=@vger.kernel.org
X-Received: by 2002:a05:6402:35d0:b0:663:4315:7271 with SMTP id
 4fb4d7f45d1cf-66db0cfbdaamr2927572a12.23.1775060766098; Wed, 01 Apr 2026
 09:26:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260401074509.1897527-1-dwmw2@infradead.org> <20260401074509.1897527-7-dwmw2@infradead.org>
 <CANn89i+GHkkubJp3MTKZ_r4tde1qLejfsxUh+w0gPZ3ec+YdjQ@mail.gmail.com>
 <252823d75e9221647e7f8ccef6105432aabe8d6f.camel@infradead.org> <20260401080657.70cd9bd1@phoenix.local>
In-Reply-To: <20260401080657.70cd9bd1@phoenix.local>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Apr 2026 09:25:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj5KW97ZHUi_5kCwC+Lh53_sj2HJ1SnBU1pQAOtnk7oGw@mail.gmail.com>
X-Gm-Features: AQROBzBuhMzLrgonz6WGspEvkWFhuj-ddiDGEYTFKbMu2F_LUT3de-t_k_EwsPU
Message-ID: <CAHk-=wj5KW97ZHUi_5kCwC+Lh53_sj2HJ1SnBU1pQAOtnk7oGw@mail.gmail.com>
Subject: Re: [PATCH 6/6] net: Warn when processes listen on AF_INET sockets
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Eric Dumazet <edumazet@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	Guillaume Nault <gnault@redhat.com>, Kees Cook <kees@kernel.org>, Alexei Lazar <alazar@nvidia.com>, 
	Gal Pressman <gal@nvidia.com>, Paul Moore <paul@paul-moore.com>, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
	oss-drivers@corigine.com, bridge@lists.linux.dev, bpf@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 1 Apr 2026 at 08:07, Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Wed, 01 Apr 2026 10:28:23 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
> >
> > Maybe on this date next year, we could make it not possible to build
> > the kernel *without* IPv6... ?
>
> There are some government agencies that used to require that IPV6 was disabled
> for security reasons. Yes they had broken old firewalls

I think you missed the big clue here. "This date".

Sigh. It's going to be a long long day.

              Linus

Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328E95A7B9
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Feb 2024 13:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708952710; cv=none; b=QU0arEDeFlcNOYdg+6M+04ahk8+8qsKtUkXUzsJuDZb9XF3eo5dOcKa4g+wHn9OjWRcVVd9JqOTxt7yItIj+k++Ca/xLK/W5hpI/ngIzD6tK+s5sd/WosRDEsWEjkFoLkygLxAyRhsQq5qG436KQ3PvgIhtmME+l2V5Qk7aavrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708952710; c=relaxed/simple;
	bh=TSU/7vhopuediqaMB29afnxjrkk5SfO2S1L2CO1wyA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a0JgWotBc1Sa6fU8nuTSInavLU/HaNA04GfIAT1UrUAlGIszCbFVl4ZyCx8b8V6OptX4KCoXlA09s6Cylq3XPGfy92e7eQ5U6iK9Oa5sRU3FOBja/rXFEyDDPnJmV7GthnbMXkaTshwJjp0py30EofoNLSOmFaTrXjbLV/PUnIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cUtB3ULY; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cUtB3ULY"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-56619428c41so3096a12.0
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Feb 2024 05:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708952706; x=1709557506; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zy6MKgUPkyetuB1Y1eJL9OxnWLY+8uMAQrEG8a3TiZc=;
        b=cUtB3ULYfuD4wu/3vO/+EMNrEJQFpSEdwicV5GW1JRkokPnatObaalZUE5QO/VgX7Z
         ljhxEnEjkWsRkDt33gI2mGG9EpaO6vHZq7YTkE5/HZZjGp3OFwdshoiRfGw+tMUDihpy
         rl+yUsQAa2tLgk1zrBc1+tN4OOJ5fr8w5R+f8Nyl/b3P4olO9jgFnq8MOIJ7+UoGofcB
         oMIw1NpKYynhEv79H7sEpKcVxLKSuVAOklw7AMtzMLAUnm2vIkf0sgcJ+HYEu/30glsE
         Aqk2KOHLEddIUnvNB0H4HjXP5kDPAjPPMyaMhleZl9wgXZktS4QoM4v56sUbF+C83Bpp
         QHBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708952706; x=1709557506;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zy6MKgUPkyetuB1Y1eJL9OxnWLY+8uMAQrEG8a3TiZc=;
        b=epmxq1FnVdrfannZj/6VtbgJVXgFHXvcLsXZzJqUWPXxwnjN2th27Hz492NZDqIEli
         pllHasgYbt/eKirU+cU1nUsf9t7qd8Oco8lxzAvd0ZTkX85C806rFC+O4tGMC38cyN2i
         CVqwvINte3AGnHPIVxZncubfWfspkQqD73cnRKb6F76bQ+BBm8qX1UQCapyVMSdK8cEM
         qD0C5yqy8291Nw0Jo5/Nkevu+fGl32jjCRvFt1sSC6l05j1p7Z/lZTPgbK2bFJR4iDul
         KS41p8q1yHjGjpPcDsrOn5Hv7z/YkQgMmdvC9u9+M8Ov3mkBVWQtFDVdW6ncKhvKrITo
         TQtw==
X-Forwarded-Encrypted: i=1; AJvYcCXidkQRQlks5tbpQExEX99zn/hC2LVojWxFxQMtikLMAX6rKweM/F3B0upXJYir2IDL/LE1Hhh28qVmZ0cwQRKUSkJqNcS9FYIK0RQk6pwe
X-Gm-Message-State: AOJu0YzsJKnbrDvK5wolJiBevPXv8Ky39VbD1U2zianCMdKa3NwYRk8j
	d82IXxOSkMaBb8W6GOagJ4EcYprGz7r1yAHIDI7tzSN5XjYRN8hO/YdGFwQ9MZdq+DFA9HepSRc
	NM/UMm7KPabByPMxmz07xPcY3/75WH8somNOg
X-Google-Smtp-Source: AGHT+IE9kaSYsBbM+tOsGzJDOXFjCoBfN0PchoTRkAb97i97cnXlO1P4tee2BSQu3/6t8WsOawF9VLsrsWuCV8jCdhI=
X-Received: by 2002:a50:9b05:0:b0:560:1a1:eb8d with SMTP id
 o5-20020a509b05000000b0056001a1eb8dmr279013edi.7.1708952706186; Mon, 26 Feb
 2024 05:05:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240225225845.45555-1-pablo@netfilter.org>
In-Reply-To: <20240225225845.45555-1-pablo@netfilter.org>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 26 Feb 2024 14:04:51 +0100
Message-ID: <CANn89iKjemgfRL-Yy2AS8kQj4iEa3DGT+uq1GabFTTw6Mr5o4w@mail.gmail.com>
Subject: Re: [PATCH net] netlink: validate length of NLA_{BE16,BE32} types
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 25, 2024 at 11:58=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter=
.org> wrote:
>
> syzbot reports:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
...

> After this update, kernel displays:
>
>   netlink: 'x': attribute type 2 has an invalid length.
>
> in case that the attribute payload is too small and it reports -ERANGE
> to userspace.
>
> Fixes: ecaf75ffd5f5 ("netlink: introduce bigendian integer types")
> Reported-by: syzbot+3f497b07aa3baf2fb4d0@syzkaller.appspotmail.com
> Reported-by: xingwei lee <xrivendell7@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  lib/nlattr.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index ed2ab43e1b22..be9c576b6e2d 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -30,6 +30,8 @@ static const u8 nla_attr_len[NLA_TYPE_MAX+1] =3D {
>         [NLA_S16]       =3D sizeof(s16),
>         [NLA_S32]       =3D sizeof(s32),
>         [NLA_S64]       =3D sizeof(s64),
> +       [NLA_BE16]      =3D sizeof(__be16),
> +       [NLA_BE32]      =3D sizeof(__be32),
>  };
>
>  static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] =3D {
> @@ -43,6 +45,8 @@ static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] =3D {
>         [NLA_S16]       =3D sizeof(s16),
>         [NLA_S32]       =3D sizeof(s32),
>         [NLA_S64]       =3D sizeof(s64),
> +       [NLA_BE16]      =3D sizeof(__be16),
> +       [NLA_BE32]      =3D sizeof(__be32),
>  };
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.

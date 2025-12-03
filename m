Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A4E2C21DA
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Dec 2025 21:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764796061; cv=none; b=mVUtXxcb9Mtr3VORwqwKMZEgz9NUooq2HZmylPfAtmD3nEhpiKhCmRWIVIBAR1JWYivudGn8NA7JRyjCRhm4MF/iY3Te6vP+KbtWjwyXIE8EdG+YyRtmKoVlODFlk6J40Z1w4hlYh1q6Z+u4/jAvlgARX9Tx+ePlfXUX6RMatzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764796061; c=relaxed/simple;
	bh=3d9aGC6njWAs8y8BO9Q+if9lLi5u+CBRThmGFWSqsLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R4rDyQSIU7sZ2CqrMTowDex1Bbcer24Jz/QfmG99J/XKJcHbSnaMR5yF613Hx0Nf6wGGwvPZS4qjrfIUAnqkgnhPY09YBo9IjKht9jAZ/EASbvEcclvalaSzK8dDEQv6HvlXgXb8lWlVQxESZCM4VHdVe16BfY9hsHMZe1/ns7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FeFtVoLw; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FeFtVoLw"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-5dfd380cd9eso175188137.2
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Dec 2025 13:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764796058; x=1765400858; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3d9aGC6njWAs8y8BO9Q+if9lLi5u+CBRThmGFWSqsLE=;
        b=FeFtVoLwIernLHUcn2tQqHiCCMCChIRDz/sHWZexupT27i5LLMWRsNV3AwTcwXotNC
         5WD2yOsJGCfBuzAHZmDzkwm8mV6+dFWjnjhjSv2dPXilOHLmQ1ZpUL1giYXRtOsEQsLv
         Ep2TL3Ce2aHB4K6URlCb0enJ1cYp1jTjkOq/Pa5CgYxNOHzLgJQGyl70yLsqnv07h3dV
         zG8YiWzWOxeqnDmBHLzsDoK+GUloMQ/eRQptHhOsTDp5lp9e0kepjTKaQOGAdmCCoLCQ
         3nftLqeRAdEglN6ILLaN2O3qtebSebp5XGLT0SDfLsd2DOWrSDJj05mSh4vN5cj2H/pN
         UvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764796058; x=1765400858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3d9aGC6njWAs8y8BO9Q+if9lLi5u+CBRThmGFWSqsLE=;
        b=SqjaxJmiTly6nd5sMXWgZxz/ZeRihmlqgRehx3pqfU95tqzSBKzXbs3ZSo5mjTM3aF
         olXdQLkiFOkwWHHsfovaYBtIj7RZnsidQeDL9aUYdBTTlD9RhDK/VN4hkr7lW/sKKXu8
         wY0673cFbnWZNWQUyQ5H1uVIeuhEpib13kW/ddeIPCpBEgbejcNntH+46P+AAv7LfG6d
         pFNREDCoNysjeyu5y7B1MsUeWNuJlyqJDv7gGFdoFb+gMMgF7SfZzJDEVcZuCCS86ZLI
         xvejsDhJaqsFlREn/mVF5EY8I8qEMHz5ZjwcxRL8oYV+0PvKAIvmovgH0wXsgQZTchPJ
         0EFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPyy0qC4VEPRFHkQSasDeLE1Uud9jGXtukiMOqztNhp+nGJqZ7s56rw6eYt51GaS6bM7VF/1wPJpG5sGwle6s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzELQQ7RvvM/NVnXDv8BjlTr1aYKEOhuYXWjNqo1jh9aitgUMeo
	2YXFgZgGsPBZQ820e5JWopCh9+yXmgk0S92E1vr1K2fUdy6HoLHHmm1IC6/uKUh2lP+3Vom2nwH
	iMUDsh56QJfkXCLeB+jwSb8N7r3o9JfM=
X-Gm-Gg: ASbGnctb5W4UfEgDfuyNn8TLWVM8xdYqMhV9lATqEjlQvAjgoOsoJsxuJevwF5ve6Tq
	p1VFKSLRe0Q3d6J7w4kZQwLA3N2F0Y0Agkt+Vsc/xSTd0KltyXKORsnA7XMvsBCVTShJTqv5+NP
	Af5eU/CC/eAE6f8LQ6o0FX8HsCHP9+ocxw8NYl+YsZIIqBO0Z6OFertS6iKTi8npebfL9YPpQ6t
	Dv0DS65u0h7TSCLyyeI4tgrEHQ3Bhb8o6SSNjSDR1BrFzjj7FTd2QOFRFSx03Uup4zxxCt7va74
	hAfLAaO3K1J1NoQFkrynESo=
X-Google-Smtp-Source: AGHT+IHdAfimol68DLumAqunidsHIT0rEt6ihzkJKjfjB1Fpx4xO6ifuhvmA045Unpi4oj8UbhPgZh3GuuMpgILmXeQ=
X-Received: by 2002:a05:6102:4193:b0:5dd:c568:d30d with SMTP id
 ada2fe7eead31-5e48e36caafmr1498913137.30.1764796058300; Wed, 03 Dec 2025
 13:07:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251122003720.16724-1-scott_mitchell@apple.com>
 <CAFn2buA9UxAcfrjKk6ty=suHhC3Nr_uGbrD+jb4ZUG2vhWw4NA@mail.gmail.com> <aTCEOnaJvbc2H_Ei@strlen.de>
In-Reply-To: <aTCEOnaJvbc2H_Ei@strlen.de>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Wed, 3 Dec 2025 13:07:26 -0800
X-Gm-Features: AWmQ_bn6jvlgEQX1iRcPAlpxmFuQ2XesxYMt5bijkTTCvXVOrAoKa4yW5JnmoQE
Message-ID: <CAFn2buD9PZsahDwH25n3kxoVtkk1G_dCErCZViqxeC7jnbO06Q@mail.gmail.com>
Subject: Re: [PATCH v5] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the timely response! If you are satisfied I'm happy to have
it placed in nf-next:testing whenever convenient.

On Wed, Dec 3, 2025 at 10:41=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
> > Hello folks, friendly ping :) Please let me know if any other changes
> > are required before merging.
>
> net-next is closed and I don't think that it will re-open before new
> year, so this patch (like all others) has to wait.
>
> I could place it in nf-next:testing but it won't speed up the
> required pull request.

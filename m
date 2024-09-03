Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FD81A42AB;
	Tue,  3 Sep 2024 11:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725362441; cv=none; b=WNq/2MhqafUqQTbNjGLRf8DveOEH2oabXc8GMJlrhbFCk1mhEica60EZNvKteZnrISqGksPrrn77w8WUcZaZ8ghLbY6zzSCNhhF8ZYzryREmQCvNZZPsJj1vjLiVMrtBH21KhO0rdInm/EKJU+S6dpHuhKcGn6VTMv4AsvBdRVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725362441; c=relaxed/simple;
	bh=gL832RMgsuKy/+BwHaJJQ2yxbZhG8cs2au5Xh+f7eIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=biK1iXVF3JD89iSoTyeb7Ely3R5WdOY6GXmUN3Y9c3SfWQQ4Gz2+Ih38CJHch5/9tJcsK8Mp7ZSS6J/BvhCiD5mrD3jXdZPy38Ldygc06SqW6oym5xO6+KT/YFInR37HdoZVitwQekyZeb4NiUpENZNyAZV1ThpIj9P73jBkXZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sj8W7Jv8; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sj8W7Jv8"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-39f4f62a303so11048875ab.1;
        Tue, 03 Sep 2024 04:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725362439; x=1725967239; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xWEeBc/epxHERRssIee9gTo1SP4ibU4XuBlFJf2nF5M=;
        b=Sj8W7Jv8RyQgRL5oNOnAJDSTSx+nDsy4Gb5s+ttHe0UXsNZJUCHimFvievvl0Dh2lu
         LAKTTYMsrmFJVYpFNuTKqoyFxgrbITaPKThddSkwzn44AuF6rptGs7hWN/aB8AzrwU7d
         Srs6X2P/JXR3aybuYnEuueNmMKzDEwPEHHD9J+oXjq2NGNjCtPgwaG9YsNjCxue32Ujo
         nfz3eMOgT+swRrljSn1Bc6wi8AVL+12bEklCjxCpOHkP4lUKvoCfbFXiuTUm58Dv/+G1
         9RXBKYl/u16aiz5JllJ1wPDERPtENDd8KEw1lBRINKROTcbU6e7NAnD9Q3Sl2d39Gy1X
         vhyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725362439; x=1725967239;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xWEeBc/epxHERRssIee9gTo1SP4ibU4XuBlFJf2nF5M=;
        b=WtyayAd35Hjl9s6VG72/THJungBZjqETATcGf0onj9qutZ7Gj9Aur0sycIVneNqbpt
         SIahBBu90Pol9oZQpPsYi/hVAnZ/5D13NuEyZgN6MLzUvWxL85g4FcxAYXjL7L6CPO77
         R0L8FxY2wW5JhDwLqjvFjS+uJ/3GPQVc+XOyQyMG5ZQQvTLYVBKJHkkDx9hAm3hOnxCj
         DUyNs2et8FxYbQWnNEyTtNqzLu47h6qIc4FAdTd/OM0m4i8tbet5p9RKHDc2Y/UDdihq
         EwE5HLaiGwNuRCN0+8Qp6kZBeXYHheq2BNzBj/FlRrsOCHwqaczdYgmgTd2IbHGzDQGY
         YTjg==
X-Forwarded-Encrypted: i=1; AJvYcCUrCo37XlLdaw4P+MS9TPe/Kavicau6XVdZBDo1aPDcr3au6GiGJhF7JzVTWGMLfM5gVXRHbJk=@vger.kernel.org, AJvYcCXpZSHnB4yBCgcfA2gdf6qOaFiBqfBkksiaGyWO9cabUyOJAMZTXYXm5jtfQgjxAU47vdljVi7bnL5kCmZUq4wb@vger.kernel.org
X-Gm-Message-State: AOJu0YyvvnhrErAZ35tN+MaJv841KgNDDCc8e6qyANQdao3DuRvK64VV
	ExNoXO02KiqGYBZ8QfCEFPtZXSmFuTwYue0P3xV4wc9m8tg2dG6RuM3Q+XHg/4CxTq9F92xHRBE
	/FRlQk1Q0SuX1nZypzriULge4//w=
X-Google-Smtp-Source: AGHT+IH5trJptMspWOS0tZAYCFIlS9UIW/kdHkQ/z4bwqueJExcpZMfXZ2SFgWzUoeQWbhOybHXFdk0Eru1WQGWJeV0=
X-Received: by 2002:a05:6e02:2168:b0:39f:4ec5:f4ab with SMTP id
 e9e14a558f8ab-39f6d777a0amr16698715ab.19.1725362438795; Tue, 03 Sep 2024
 04:20:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240830092254.8029-1-fw@strlen.de> <172536182876.258777.18006579321312248065.git-patchwork-notify@kernel.org>
In-Reply-To: <172536182876.258777.18006579321312248065.git-patchwork-notify@kernel.org>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Tue, 3 Sep 2024 13:20:00 +0200
Message-ID: <CABhP=tZV4G4EcAdtPKw8BDixptVCvfA9U2HAG98bx1JNDOrR4A@mail.gmail.com>
Subject: Re: [PATCH net-next] selftests: netfilter: nft_queue.sh: fix spurious
 timeout on debug kernel
To: patchwork-bot+netdevbpf@kernel.org
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org, pabeni@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 3 Sept 2024 at 13:10, <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to netdev/net-next.git (main)
> by Paolo Abeni <pabeni@redhat.com>:
>
> On Fri, 30 Aug 2024 11:22:39 +0200 you wrote:
> > The sctp selftest is very slow on debug kernels.
> >
> > Its possible that the nf_queue listener program exits due to timeout
> > before first sctp packet is processed.
> >
> > In this case socat hangs until script times out.
> > Fix this by removing the -t option where possible and kill the test
> > program once the file transfer/socat has exited.
> >
> > [...]
>
> Here is the summary with links:
>   - [net-next] selftests: netfilter: nft_queue.sh: fix spurious timeout on debug kernel
>     https://git.kernel.org/netdev/net-next/c/5ceb87dc76ab
>
> You are awesome, thank you!

Indeed, thanks for fixing my bug

> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>
>
>

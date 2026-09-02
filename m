Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D48443AA5;
	Wed,  2 Sep 2026 22:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788389555; cv=none; b=nHnNVN5BiXlReokv2COTOHfAzKdDEIJci5pWPRctEPxBr0+461ZOzEctxqHjDj7UvWw96KopN7iOddvrpfWU7mpXWq9cIJe7IE83dTzD1rG7uZh+888Vc7Nhfz0HkwtuV+5KF0lzmTsmZZAP3LIbwwm3MHmbb+U4zHLc6XCkGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788389555; c=relaxed/simple;
	bh=jPy/vhRnfB9J5DrZW1+7yOkwzkCKQGz1PKr4vTz4abU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MJmN1sqbXzz5rRePcckj/3++gtBDYTVpeZeTlXrNhEiak/0Cch1GuMuw9oC5yGrnkKm96wMm2cq6/lx+SFkbaDAyMOWbnyEhgSnJplzz6z8lPUZc5uvCq4XJxaowD9ncsZgH4uH/PBZmS0MkjEkk6clACItDRUE9xt/lwijy5cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ABT2fz0Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ABT2fz0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77C71F000E9;
	Wed,  2 Sep 2026 22:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788389537;
	bh=aesFN2OHbarFM50VtQtwNH9OJpNYeiU/N7P2t16enJQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ABT2fz0YYmV6oRP8XGH5PsyGf2cm+MFOfBtxMC35kopb2qMQH7dEFnf3vkNsagATF
	 1QaCueu06oRLe+UvB9dlIbBu59STycKG9dUSI398JJf6jy/u91vqR5R3VYVl2ryX7W
	 Jh4SaA0myYHvyRn/bCjqQdQMblaG+0FHtlcyfeT1nEtjUjFTvomz1A5sZVINKyKZ+f
	 3e6Rrojphf1QXoh7pRKQpprfcE7ijB+h9+yNlDz5IE08TODhoXIidUSI8ieUYUzLfN
	 DXa1AyW9/sSj1FTjIWDHSC67fjE+m0O43OMj91y/t9OFhNN4f0EWPNT+Mo8R0o6X20
	 fzDUBr6sXbHnA==
Date: Wed, 2 Sep 2026 15:52:16 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Michal Luczaj <mhal@rbox.co>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya
 Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song
 Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa
 <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, John Fastabend
 <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Willem de
 Bruijn <willemb@google.com>, Jakub Sitnicki <jakub@cloudflare.com>, Jiayuan
 Chen <jiayuan.chen@linux.dev>, Joe Stringer <joe@wand.net.nz>, Ihor
 Solodrai <ihor.solodrai@linux.dev>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter
 <phil@nwl.cc>, bpf@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH bpf v3 0/2] bpf: Fix socket leaks around
 connect(AF_UNSPEC)+listen()
Message-ID: <20260902155216.4fa23444@kernel.org>
In-Reply-To: <CAAVpQUC==6KEBs3XgFjZ536mJ23cbHma8HuiWMu1DRc_=YYOHg@mail.gmail.com>
References: <20260902-sockmap-lookup-tcp-leak-v3-0-b998b3d49d07@rbox.co>
	<CAAVpQUC==6KEBs3XgFjZ536mJ23cbHma8HuiWMu1DRc_=YYOHg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 2 Sep 2026 11:58:49 -0700 Kuniyuki Iwashima wrote:
> > Several BPF socket helpers acquire a socket reference only when
> > sk_is_refcounted() == true, and release it, independently, by
> > re-evaluating sk_is_refcounted() again at the time the release runs. TCP
> > connect(AF_UNSPEC)+listen() sets SOCK_RCU_FREE on an established socket.  
> 
> Due to several bug reports, we are now inclined to forbid the
> buggy transformation.
> https://lore.kernel.org/netdev/CANn89i+px52TtJy3S9=uHxGj3s-WueguRo1Z_4FxO=02KLmwmQ@mail.gmail.com/

Kuniyuki, would you be willing to send a patch to do that?
Not sure if anyone else is planning to, I wasn't..

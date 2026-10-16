Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682CA2367B8;
	Fri, 16 Oct 2026 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151776; cv=none; b=eAyZ17W8/Ftvh2fIGqq4Gb/eQYDwTMubLOnjgwbtnL1hK1x7QH0t1GxoH7QVsTPc5dWF8n7Z9e0jpI+AhBemibw18+08esuSBOHtwjw5CYX6lSs9drtifRVr1PPmhmcDwoZAcY00QpIiVAUMN283JvnqDA86mNqndSy1G/t1Rio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151776; c=relaxed/simple;
	bh=HyzdCibjmBuu+Mz4LlCW22CV/VlkMRvQdGIUrWUb808=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Fvkkkbk1gZjiOtANUxkEUTV3v2gByYmvPu0WUWiqb+L4pgpXV4wVdu+67zebqVud0d+TaOn95vm12To8Ap87sNRaLHNDqsUjp7DWHfqMwRafuYlK1TkrycofcxZ0+Ql15ede8OH+d56bsAPttK6zhzj3exw6MkSJwi29Zq9UxYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D8d8CjKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D8d8CjKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6E11F000C4;
	Fri, 16 Oct 2026 11:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792151775;
	bh=HyzdCibjmBuu+Mz4LlCW22CV/VlkMRvQdGIUrWUb808=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=D8d8CjKVNhFOL0ZW1vZLe5n6wQ26trtMwAg7EsG7zapwri+Lvwj4ZOE4hvFVMQmae
	 uMoWfwfoupMlrD2ucAt7Sb9Ir/vw8aWgvP9YS9YaZdfUrcuWVi2spo7Yv4Z3jUa+ww
	 Q14d6WGAlfruoisaThHdRqgl7y/bIm2dnYy4kmUwrNwmS0R97jLrjB6HOio6fLFOlb
	 9NQvrHi8gKQWFpGPU/anFZRUBWpwyBLvRX/5w37LnJ/+W7Tm0yt9ZeMNxI/YxrGx0O
	 FOnNVlLlIVBEP+gJyGCU3i3dDiY35OtyGMC7McI+O/NZBteKjHyNdeW+BxOgW2d1zT
	 tPHSuBr9nTxZA==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, Jason Wang
 <jasowangio@gmail.com>, Eugenio =?utf-8?Q?P=C3=A9rez?=
 <eperezma@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, virtualization@lists.linux.dev, Rusty Russell
 <rusty@rustcorp.com.au>, Max Krasnyansky <maxk@qualcomm.com>, Pablo Neira
 Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter
 <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel
 <idosch@nvidia.com>, Simon Horman <horms@kernel.org>, David Ahern
 <dsahern@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev
Subject: Re: [PATCH net-next v2 6/7] net: add ip4_parse()
In-Reply-To: <2645c102b2f73292d1973b82c95def24e48064e1.1792067836.git.mst@redhat.com>
References: <cover.1792067836.git.mst@redhat.com>
 <2645c102b2f73292d1973b82c95def24e48064e1.1792067836.git.mst@redhat.com>
Date: Fri, 16 Oct 2026 13:56:12 +0200
Message-ID: <87h5il506b.fsf@all.your.base.are.belong.to.us>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Michael S. Tsirkin" <mst@redhat.com> writes:

> Multiple places in the net stack open-code the same minimal IPv4 header
> validation: pull the fixed header, check version 4 and IHL >=3D 5 (where 5
> is the fixed header size in 32-bit units) - and locate the transport
> header at IHL * 4 past the network header.
>
> Add a helper for doing that: it returns the validated header and
> the transport header offset, or NULL if truncated or malformed.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: LLM

Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

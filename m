Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB73A39D3FD;
	Tue,  1 Sep 2026 01:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788225723; cv=none; b=hlwp2TEoead/1/PFVX9lSsAdBybbaky88cw/mlT+/gQZomsMgOD4zvSQu3e4e8pouyHsdfIUfb+CkcIlEdzE0r+HRmoLMsyKcTPaX6FzCZoj8+Upj6/TEzUcy6xu6oP/Lwx+5eH2nOsudfrrj41Plrbj4dWW7+OiTi3WB0dvgsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788225723; c=relaxed/simple;
	bh=kf3JwUxSQPCNsBeJ1W33FuzQTEV/mi4ddV9bThbV82g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yo3X6sSE535avn2+4E1lARq1rzvLN4xiC/73PpHLXDdCUTm/94OSKySiQAofQqVEP8pCJK8s7EjITezQxpwvAIwO/BF1NvJ6lwdZgfoEqAXZfFcobUT+e3SHZXz+PaBaAjny6aRn+MuHboPPUR3KpBbwUaz7vqxg2i8cerOjZQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kpevG456; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kpevG456"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD181F00A3D;
	Tue,  1 Sep 2026 01:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788225718;
	bh=ry3n3u/QgT+ueyUZE3MNBWNcN9sxIUHDI00PpIe/2SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpevG456BrJchHPPJsynXc6IjfzzXMaAh9EBv7GX7BUdr3GcsfSeuCmZACVB1nBTZ
	 G9yyWEYj2MuoP0If1QVZEglLUMrTQz4xyLZPQvHqMLRk7D70vzCZVb+lTF4rKcVOlE
	 cL5WzzOxEKwRRHTLMCdiWDuWt0W5Uv2da1XBmrPILoGtp2k4NS4/Yj3ePNyUsjWlyv
	 08/6DgmvLISPgkFwk8FgrPuvCDycOr7veTDhRMOl4+oXaLuReupClTR2O13mDlpQma
	 +51Cv3nwcXtkR9+/afBrmfMoDp0rXZwAEBFCKCGuvCkE85dCx41nZ77napNFgzBgfL
	 xmFGXGcZ4K/Sg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Martin KaFai Lau <kafai@fb.com>,
	Wei Wang <weiwan@google.com>,
	David Ahern <dsahern@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Sasha Levin <sashal@kernel.org>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>,
	Kuniyuki Iwashima <kuniyu@google.com>
Subject: Re: [PATCH 6.6.y 0/4] ipv4: start using dst_dev_rcu()
Date: Mon, 31 Aug 2026 21:21:47 -0400
Message-ID: <20260831-daily-reply-0003-dst-dev-rcu-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831-cve-2025-40074-6-6-v1-0-027e51b162a3@bootlin.com>
References: <20260831-cve-2025-40074-6-6-v1-0-027e51b162a3@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Three other patches are required to be able to apply cleanly the final patch.
>
> Eric Dumazet (4):
>       net: dst: add four helpers to annotate data-races around dst->dev
>       ipv4: adopt dst_dev, skb_dst_dev and skb_dst_dev_net[_rcu]
>       net: dst: introduce dst->dev_rcu
>       ipv4: start using dst_dev_rcu()

Queued the series for 6.6, thanks.

-- 
Thanks,
Sasha

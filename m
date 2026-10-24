Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792872697;
	b=ps006qxBcXrNdnn+SNtjulTryyKia0Tf1l/6wyexpLixdFxFjzuCnWNTgdfZnUjKAHu1
	 A9jm1VSpLjXVeJtrwUe2jxGI/C+7GvVi/wuZasA1/1iMxd+fmdAVhfZ0f6qyG37uQ04iD
	 RCSUJ15xFmeCHgFLSX16IGHzQOyqdExr04rGCG+4NRzyx6ogyKU+6R139grTtKHLBxoQd
	 rZNwr+SDN8EGyEYgEQf6DzxgnnuF7S9BGLkPw30iJJdy/OxbtvQ674TdhrkkDHbyMGLWc
	 raBDI8KcxHGsFpQOb8FdoCR4SrZOPJeMpZQA34IBC5A16GXAOcpU4B3GMHiudRrOeWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792872697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bi+Xva82DBXRueJTQzCkTQF72ZdZ+thGfwUT8a5lNHg=;
	b=mxoHJs0263Stq4LdlZv1mGfYZOf3YXBl/ULQakZhIf2MzQTpbEvJhcy2lIkCBVX3JY2N
	 gDMx1+pczp1hFB8CBhH/7l3lPAS0lNW/QI1DDYU4gvG5AnKDe0QdoraJkOmuY+Ny72d/s
	 xUQI6bK4Kr4pSkOEobVLpxXgqTG7uOsvQyv4OjXaywXh6Miw6coOMspewC2UTq6yTp9R9
	 egKFNbaH9BYtI3UVKLv/FPTgvEl+30+lN87Vtx4ypxG/AIa+abakdg6E1RSODVrFhALn2
	 +IMOAYkCocGpY56YK4UAQIWjsU8yI9f3xJPLQYZOcY0z5Emv3x41RhNd8bXNAKd0+ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="KWU8HJ/Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1C3606A32D;
	Sat, 24 Oct 2026 20:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KWU8HJ/Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967F01F01825;
	Sat, 24 Oct 2026 20:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792872697;
	bh=bi+Xva82DBXRueJTQzCkTQF72ZdZ+thGfwUT8a5lNHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWU8HJ/YfJ4HTUxb8fBF4ldledOz98AhFFIfv7J4ntUo9t0iGgp2q1aylExfYj5k0
	 /PivJsgv2GmXY/ZNzbrKojmLj6MWyHprUjsP/KRMo3cG+5iv1ztXSe3/7TdUBtH43b
	 VL0LVe5NMNX0UqL9IEnffxnQek4NR2hyrOSBKtgAW43o7HtJxuBafRYbGkifton4Fm
	 QGywgRhUr3GJyaDgGVKcRpvAFlEknjxW+NtDgWqMtUEvKlvWIw41nvajWbuBUN7O/+
	 cqg4E3uAIo90HeOvFp8kS44LH++8YEN6/DNqKK3iVuFzGfr8TQzCh57mvgq8D58elY
	 xbcLQqCfzizVw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Subject: Re: [PATCH 5.15.y] netfilter: nf_tables: always walk all pending catchall elements
Date: Sat, 24 Oct 2026 16:11:10 -0400
Message-ID: <2026-10-24-1-daily-reply-0012-nft-catchall-walk-5-15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261024124927.5289-1-steffen.pfendtner@kernelscan.io>
References: <20261024124927.5289-1-steffen.pfendtner@kernelscan.io>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> During transaction processing we might have more than one catchall element:
> 1 live catchall element and 1 pending element that is coming as part of the
> new batch.

Queued for 5.15, thanks.

-- 
Thanks,
Sasha

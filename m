Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82CD260565;
	Sun, 27 Sep 2026 22:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546827; cv=none; b=FTYTt21GRnzuRNzJHrPheMNuDeM6Td0XLt54cglskWm1EI8eextmNqsK4zwGXX4+o3J4vedCgYJPP1bbHjIVoBtv+nd/vVW8FTjPYbBEY2eYdKjVJIr59BXZ413FUtLvXKCD4kKEqTwHNWAenMjeiHf4EJXPBs+2ZurH39AOIEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546827; c=relaxed/simple;
	bh=d+aJz1zKHpn9rY7AAI0z0Bfwgrtc1GkTtmSJdeejdk4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PjzUmkbZGy4N+ZERv6zqFRwdYZ9WcaH49cC9mmwM1W/wnyBgdwlF67oF0hTdRKn5qpi1850mRpbG8/MQ+I5czbCHP2Vup64hQJsnwKrZdEGIfrIWP3dDtscUWnZH55Pe8hAd9lP4jYFHdrb+wrfDcPWDNOV4+Lln7IxbXSrVCcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DRbYTJQj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRbYTJQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993F11F000FF;
	Sun, 27 Sep 2026 22:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790546826;
	bh=Gtpu0Nj+ZvaUDoZ3qvo7pqTSdauHwZKukSlMfQ6OCtg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DRbYTJQjGI7MSfxD5g/6y/vbNqJoUKgNFrV729EBHkR9Xm4oo1SjT6WQITJN0HpuZ
	 KAbvbcJsuW9oy8+2D58iy+DyyursYPrIsIMEUQXELVg9ggj26b3eN25/ypDpZL6xQe
	 pN4mMjnIGfVvYZO5sanspA6yEbU9PB09n8D2iRz6nF/QuZ/lz7nB0IwKkJgsTjAsqI
	 YbKhGGHkEH3Bnn3UHr/H2mcfseHEMEqwnK6kjzg30a5yd6sszm8ViMk+x6U+45oHwc
	 2Ist9TVbmvwWqJkqYJ84+Ldi17pdK1ln7pB8AUuSoOLIG0w+44OErhv1u4IPjsUDhJ
	 NKhX0TlURlZUw==
Date: Sun, 27 Sep 2026 15:07:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Chengfeng Ye <nicoyip.dev@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal
 <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_tables: serialize offload stats with
 callback unbind
Message-ID: <20260927150704.62c8c919@kernel.org>
In-Reply-To: <20260927071520.3693598-1-nicoyip.dev@gmail.com>
References: <20260927071520.3693598-1-nicoyip.dev@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 27 Sep 2026 15:15:20 +0800 Chengfeng Ye wrote:
> Rule GET and dump requests collect hardware statistics under RCU without
> holding commit_mutex. Callback unbind removes entries from the base
> chain's flow_block.cb_list and frees them immediately while holding
> commit_mutex, so RCU does not protect the statistics iterator.

Slow down. Please do not submit more than 8 patches for networking
at a time. You can revise the already submitted patches but since you
violated community guidelines we ask you not to submit any new fixes
for a month.
-- 
pv-ban: 1mo

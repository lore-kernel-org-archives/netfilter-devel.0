Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794917968;
	b=ioXwakZZMwQb+dHWO7FIbwLImvFa5H6drhjq9Ec18YxUTa9sUQSCy7H7QLfja9wPpfRT
	 IRrFpseBcDnn1Yv25FOoq66PoA0tAwXv6s8XpUIUKvlkJpJc5CTxib0wiAtbts1kjLgR5
	 IpcAcb8b8k6Mq0ocO88TZ2z+yfI9vSwKg3SyPZsYzSmBtcxXibtKUH1q650d2pCeGbaO0
	 2tPq6kZWA86JZhBKWxsAkEYPcgzPHpyGrxN9lWQcscydbciJlepDABYTuyduGAfpVWoz1
	 +nn74VcGg0bd962wF5FkXzcg+VFtCJsjmH3TMW+3hcgyIoMExQ7eiJZVka5hMg+KoMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794917968;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=bAqhpt5SmcNHh18+WgBOwF32RfrRMvxEuACaGU0iKrY=;
	b=QHebkLZKYC+9mP0OmPCaqKYvcvsYKTvhbM7PKl3kgUxsHSA/Y5TPmeWoKz18iOrMr6RM
	 tsK1zj7y8UgNhW++7KTiIuZZwb/lVet7d4Y7fltt/0GcZky2naObnK4tKpSPIEmKUOTyz
	 rT/Hjy+aLSBln+DWpWcwUkbBKTt0VOIu3E+gQB0stYQIk/WJhP3qKig6lVT7V7oTXbCU7
	 N9yEmmjfw/OsIpRvTGpxPhiqAxBniYFPGsBveuEe8XPjDiTlnGW+e+WCEhM2gpWWTy1s9
	 bZWCHpvx+pYJt3WXXQ0xkc00QvE7jhawK1EAxaMRoWu5DrDo4pnZvq6InR6ghcdJJJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=nwjLQsUm;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 11663606A336;
	Tue, 17 Nov 2026 12:19:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11663606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=nwjLQsUm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794917965;
	bh=bAqhpt5SmcNHh18+WgBOwF32RfrRMvxEuACaGU0iKrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nwjLQsUmgkUw2fIMHhptCO+5jj3fZ+oq/FJUSLxNFQUm+QVtj5ut/OWN25rlRmbLo
	 txO87ZSZJm9f37lxaowL+alqPXdrEDj5RH+FPfQl//EmkeDyxEPxaxvaFu1UhfVLp6
	 dM2672IjKXuTm2aHwHvCDJw+uRmHKFttobpuqeEGJ8poVIXbRQVx9hBzA0KQMjjltb
	 H2PB0V29OMzgQLYlJ/rFw5Hfn37YssnzfnYkiekv7D5mL8EHxskqX5oHZvZA6e/y/a
	 FO0SXLyjb8RdwtQbKxadSV436henXMd749tqAHmQy2J8qdMGnXXB1Ky0Gh/eT0cClN
	 JWEB3OfbUUfNg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 65AE860058;
	Tue, 17 Nov 2026 13:19:25 +0100 (CET)
Date: Tue, 17 Nov 2026 13:19:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xue Boyang <fuchen.dust@gmail.com>
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, phil@nwl.cc, sunyiqixm@gmail.com,
	bsdhenrymartin@gmail.com
Subject: Re: [PATCH nf v4] netfilter: ipset: fix double free on kernel-side
 delete during resize
Message-ID: <avxGSmw0DYWUZJrn@chamomile>
References: <20261117101018.523826-1-fuchen.dust@gmail.com>
 <avwswXiJh8HUPa5T@chamomile>
 <20261117114451.608829-1-fuchen.dust@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261117114451.608829-1-fuchen.dust@gmail.com>

On Tue, Nov 17, 2026 at 05:44:51AM -0600, Xue Boyang wrote:
> Thanks for the pointer. I had not taken that series into account when
> preparing v4.
> 
> I have now looked through it. The rhashtable conversion removes the
> ipset-specific table-copy resize path, so it appears to avoid this
> double-free/UAF class at its root rather than fixing the individual
> races in the old resize implementation.
> 
> I will run the reproducer and the related GC/dump tests against v10 and
> report the results.

Thanks.

> Since that series targets nf-next and is a fairly large conversion,
> while this issue also affects existing and stable kernels, would you
> prefer that I replace this v4 synchronization rework with a smaller
> targeted fix for nf/stable, leaving the complete cleanup to the
> rhashtable series?

I think -stable backports of Florian's ipset update for net-next will
be needed.

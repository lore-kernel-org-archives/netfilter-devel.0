Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792534024;
	b=v9rQyRWKPpU5tw4Hp+Y//t87vht8JtQ3wz5PKqQf7odk2Ob0wGqCRB/AL+wqIlgr0KHr
	 wurl/2vJmhtP3FK56Qb7n72haqJrszihqmaZ9FZ41fkiN8k+793hvtsaIxnv4fhxMyOQf
	 Rb8RqJRAdZO6XBKu4FKwyYVOUMj5cZtKooOp5OrU4RTOG5ExrxF5AhcaysnZMiMhmmzla
	 7e6tUaTV19sFocManRtuvu0UQYznD2jDbvpztPCTbTpANjvssyf2+9wgMeyyxqDs/tFI2
	 y0MqrC317nGIAg5hMYvcTOxLA1noiBn5I+6VXQK34YA423RFSK+Xj/eTd6TceGMPorA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792534024;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=HqZa8GOL4ERbtWNaqqEoaaGHmV3+kGIVpIqSE1S9+fg=;
	b=a3kwpkEv12nqxQQbh+3xTOTMIU0VRRJZycz+OifYQZS+Y3zvOeHBmIxKMzPNsxIsl+W7
	 d2ZGQh0tDSCkxWnlFvJxK3Gicwu3eEHbiPIzR1wA+5SvGRLWuTk2rUqzYkbaYfCgloZ1u
	 sjH4BrPOJCRaGsYHFLpy2/9szYjpwGgNzk29r4Z/knIj+c9WGCz93/3nxmM+7Wz02edwL
	 N+7h2kKuGZgzKG9kzYLVp2v8O+nR3S+h0EfS47LjwGZEgrrgQJKvCj/ewcQMqVUH2n41d
	 tEfdKK19Ig5etY7IM93qxQDAJEYlFAUOxCdCzruihzh9YFnQkj13srqDrnp0abHY0hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="r/GGK4kE";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 784E2606A319;
	Tue, 20 Oct 2026 22:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 784E2606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=r/GGK4kE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792534021;
	bh=HqZa8GOL4ERbtWNaqqEoaaGHmV3+kGIVpIqSE1S9+fg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r/GGK4kEnYdfMvy35BWJwx7dqaAtfBtpjYJZ3IgVoE8KQnNDpcyIbA5v0CBQGlu9t
	 5xWXD4ut7NlerUNJfE1EH28qZ7/BsCb/v4LCZLT1XPTUleXYAUgaV7eJ66qTAjw8eI
	 V9kG5W0lTa5AtS0sgSsOBtRESoH/Q4nyHoBzwdU/iQfFt/BqNCy8F9Tb39Ff60KrCv
	 MrhbyDiXA6ka+yErTGGRbo8H/+C4jgpRYhoH/nCufIjmR3h3v5VctkK2gL1C9khDZp
	 peslGW/v2aP/sPZo+I2LTNKbndLfZmQ/XQeQk2FMCvN+WessPRCwd8Hq939tPj1bzb
	 /CRO4FZHNvVKA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2FC1E60074;
	Wed, 21 Oct 2026 00:07:01 +0200 (CEST)
Date: Wed, 21 Oct 2026 00:06:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 03/10] ipvs: fix more races around the overload flag
Message-ID: <atfmA3T8CceTq3CI@chamomile>
References: <20261019150249.1879516-4-pablo@netfilter.org>
 <179251059359.3135.4423672797381402162@kernel.org>
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
Content-Transfer-Encoding: 8bit
In-Reply-To: <179251059359.3135.4423672797381402162@kernel.org>

On Tue, Oct 20, 2026 at 03:36:33PM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 0 (1) · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] A threshold edit that moves a dest into the overloaded state can
>   race with the unbind of its last connection, and the clear is lost.
> - [Low] A new dest created with no thresholds (u_threshold == 0 and
>   l_threshold == 0) is published with u_threshold_val == 0 instead of…
> - [Low] The commit message and the comments do not match what the code
>   now does.
> 
> Pre-existing issues:
> - [Medium] This problem wasn't introduced by this patch, but on a cache
>   hit ip_vs_lblc_schedule() (net/netfilter/ipvs/ip_vs_lblc.c:509-511)…

According to what I discussed with Julian, this improves the
situation. He mentioned that the issues that are popping up in this
area of the code require more follow up fixes.

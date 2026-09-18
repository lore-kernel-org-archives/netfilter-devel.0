Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C734A0EF5;
	Fri, 18 Sep 2026 08:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789720764; cv=none; b=uhDInzKBwRrEW53OI49enzuZHmFwIaKLAb4ADCpuDgJOfhPeWk4MIWABuI7Z8k6WjGNfwHmDAuKAf6jisxSiXB9deiSm0z8b+omaWLxH8bt/glmVZ2NPsHKnxkLT4j/Yzweoq08ajjT8bERbuns0SaJYwOk7+AZXqFUbCj6G2Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789720764; c=relaxed/simple;
	bh=yPxr+P9ZpVJ6LiCnvJMujbahHJk3rIz/vUPWCzxtsmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwbBgBSz87OmLwF53dlOzlAXK9DyBwwXSmMJW9jGmj6AnISgFVgXLcCXWfyCkFs9aaR9uxswl4EYVhc1ALIjSJmEJdvji5QHx1PnKCnuRdEIbaJsi8s+4I5hdFwKvKSNAs+vnB5A1moj54xVibMsnm9zKsG3p5UOUIQD07uKrZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pk6aW5ze; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pk6aW5ze"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789720758;
	bh=wmxqGpZlbhKGXbJR1FGwf5IMNwKJeJOS6YggcclUvU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pk6aW5zeOsm6OJqLTfhu3gnFZna1u7YztbLsQYhekIVNsyVqQ0/aV8gZ1Xgq2ATUV
	 MBVZrtn8c6Sc9y8uYCuhCC8wuCVOeeI9LPpfwE3c0UffG0MNDGZQ9XxyMpPMTi6hq1
	 NhPZmy/B877wrGearYCGii5quBCSFnUPove6EecjCQ43Tm+wp6KW6ITU+32fvv5x75
	 +J3auYebGDyyzdzAoHQxFLe+ove25De9QIOc3U03p8/n9nloYKAOyzKX0GJKlElKd7
	 SmeJFvXGnyQKab0hCgGi9VaX0E703E30WZzVilfZkvPrFuwq9uHJcaDQO/m/dN9v8P
	 Ano1taA4RfvLQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A886260052;
	Fri, 18 Sep 2026 10:39:18 +0200 (CEST)
Date: Fri, 18 Sep 2026 10:39:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 02/10] netfilter: nfnetlink_queue: hold nfnl mutex in
 event notifier
Message-ID: <aqz4tOv88nKh64OA@chamomile>
References: <20260916231652.127456-3-pablo@netfilter.org>
 <20260918020409.3513342-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918020409.3513342-1-kuba@kernel.org>

On Thu, Sep 17, 2026 at 07:04:08PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: nfnetlink_queue: hold nfnl mutex in event notifier
> 
> This takes the NFNL_SUBSYS_QUEUE mutex around the instance destroy loop in
> nfqnl_rcv_nl_event() so that the NETLINK_URELEASE notifier can no longer run
> in parallel with nfqnl_recv_config().  The stale comment in nfqnl_recv_config()
> is updated to describe the new serialization.
> 
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> > index c727668b0c5be..a3bc002800510 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -1593,6 +1593,7 @@ nfqnl_rcv_nl_event(struct notifier_block *this,
> >  	if (event == NETLINK_URELEASE && n->protocol == NETLINK_NETFILTER) {
> >  		int i;
> >  
> > +		nfnl_lock(NFNL_SUBSYS_QUEUE);
> >  		/* destroy all instances for this portid */
> >  		spin_lock(&q->instances_lock);
> >  		for (i = 0; i < INSTANCE_BUCKETS; i++) {
> 
> [Severity: Medium]
> This is a pre-existing issue, not something introduced here, but does waiting
> on the nfnl queue mutex here make it easier to destroy an instance that belongs
> to a different socket?

This patch is fine.

For the theoretical described issue, I posted a patch.

But this is a pre-existing issue. Patch is fine.

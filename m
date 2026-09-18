Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224562D77F7;
	Fri, 18 Sep 2026 08:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789720798; cv=none; b=aF5OQ0vP5GYVc44SHdjf0npzMeHL7+MAPWQq7thFraDlalai1bKm7f+alL7Jx9KxNepQVnjnRc5YDwVqZUc6HvYqr9XfXYGTLjLqr280z8aeq2fiCZbALQBJFEbI+O+MRZf3BXok9bQ19HN9dy8P6ipobQNpvCrkfxcRvndZkSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789720798; c=relaxed/simple;
	bh=cAnn5FmdJC8aTaZSdsVmGcztH1R2Y3ynXcl8BNnH15s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGIxfxVrDuOdTHzmOCeOF+PrZ8ij0xX4YsqRz5Wy5YpVElL21tm2ftUuB8PjW/KD/IyIiE1sHGOQYTrhqzL5Qd9OMZQvxWM4lWeWAJO4rtEHAVZJ5JDbv6qJIe7OaB7tR5TqTkzWUAUH1HtLrKxoQg9FA/dLLACX0sk9ycVQt04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nyPqq3to; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nyPqq3to"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789720793;
	bh=UZ/5oZY6bhJAaWR/3tdCRvpMV1/RQ4HlFZcmLabrw4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nyPqq3to3iX0hSwDaM++Td/goQR52x+UWtO56/wExlivz+bWA4X0UJIIx4ugou/EO
	 Sj1JQEM8AAwQbnO3ddZ0c58aGVT997M8Pr8HK4fPfvo4+EAjLNKqorsbiTdcberHMB
	 ziodTwOOWemic9e9iM9OEqta49dnsJ4Qk2doCseN3gb9Tao+O81/w3d5U4HJhm5s/4
	 3S0ZX7BvmDVLGKu5VmQ0zxCKG2SioT3qmLzMGegqL92HSuyYmVN+wqm/IMfXrVRAp1
	 citHsOA/DCTxigvxI4mPJi84WZfvPJGfcO1IJ9e/Ejb+FTsBl403BisASBi6M6qn8O
	 5ZlTJcNZgj+cA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C9DE260052;
	Fri, 18 Sep 2026 10:39:53 +0200 (CEST)
Date: Fri, 18 Sep 2026 10:39:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 07/10] ipvs: filter some flags received in the backup
 server
Message-ID: <aqz41q27anhvSbed@chamomile>
References: <20260916231652.127456-8-pablo@netfilter.org>
 <20260918020411.3513416-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918020411.3513416-1-kuba@kernel.org>

On Thu, Sep 17, 2026 at 07:04:11PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> ipvs: filter some flags received in the backup server
> 
> This adds ip_vs_sync_validate_flags() to the backup receive path so that
> sync records carrying the NO_CPORT+TEMPLATE combination or ONE_PACKET are
> dropped, and it also applies IP_VS_CONN_F_BACKUP_MASK to the flags taken
> from version 0 messages for consistency with version 1.
> 
> A few questions about the new validation below.

Julian wants to post a v2.

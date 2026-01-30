Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630E234E75E
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 11:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769773889; cv=none; b=co/jJ68e8c1AazUh3cS8PD23EC1aD3SBGEg5rxjAKXAfKgBPOgMfgskhezvCE4Z0Q2ymseqhnOOwdDA1CZyXNCprK4zVkzoSflaa/E++sXvZPxW+xGt7uecvj/MpuB9QcCrh/GaBeStGTiPo1sHDQEMO7vTNom2Frf4pIWjcypg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769773889; c=relaxed/simple;
	bh=7yC5MNVWTUuEqoBW0YP/UokoiViJc/LkTOdGmetmUCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jntSqo7H8NG77T88n7U8GRnutezfSZK80CqcvRMMAypAFCl66iz7cUqEKrjEPyMi06lFn3Gy6MaJToykBjFs/W+zeRspH63TRjwS3HjWmTJTdptYIGhkl6D0d8qJ20QMEZ0YxyZzzviH2DfjZTxItPd2Mw9ntt1GzC50ZyNug6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 457AC60284; Fri, 30 Jan 2026 12:51:25 +0100 (CET)
Date: Fri, 30 Jan 2026 12:51:24 +0100
From: Florian Westphal <fw@strlen.de>
To: Brian Witte <brianwitte@mailfence.com>
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: use dedicated mutex for
 reset operations
Message-ID: <aXybPOcqHlBAdwM_@strlen.de>
References: <aXlTpuk0Z1CeoYwT@strlen.de>
 <20260130015617.42025-1-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130015617.42025-1-brianwitte@mailfence.com>

Brian Witte <brianwitte@mailfence.com> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Maybe its worth investigating if we should instead protect
> > only the reset action itself, i.e. add private reset spinlocks
> > in nft_quota_do_dump() et al?
> 
> Thanks for the suggestion. Implemented per-object spinlocks as proposed.
> Sending inline rather than v2 since I'm not certain about the approach.
> 
> Ran tests/shell/run-tests.sh with PROVE_LOCKING, PROVE_RCU, and
> PROVE_RCU_LIST enabled - no warnings.
> 
> Uses static lock class keys to avoid lockdep exhaustion with many objects.
> 
> Two questions:
> 
> 1. Should this be spin_lock_bh()? I think plain spin_lock() is fine
>    since the packet path doesn't take this lock.

Its fine if we're interrupted while holding this lock, no (soft)irq
grabs it.

> 2. The nf_tables_api.c changes also remove the try_module_get/module_put
>    and rcu_read_unlock/rcu_read_lock dance - that was only needed because
>    mutex_lock can sleep and we couldn't hold RCU across it. Since
>    spin_lock doesn't sleep, we stay under RCU the entire time. Please
>    confirm this is correct.

Yes, this dance isn't needed anymore.

> diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
> index cc7325329496..ae3c339cbcee 100644
> --- a/net/netfilter/nft_counter.c
> +++ b/net/netfilter/nft_counter.c
> @@ -28,10 +28,13 @@ struct nft_counter_tot {
> 
>  struct nft_counter_percpu_priv {
>  	struct nft_counter __percpu *counter;
> +	spinlock_t	reset_lock;	/* protects concurrent reset */
>  };

I don't think we need per-object granularity;
a single spinlock in nft_pernet area is enough for this.

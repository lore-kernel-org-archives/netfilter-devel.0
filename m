Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C215474C
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2025 16:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736958142; cv=none; b=f5Oq6v5IOd8KYANEiGYwOXiJzzmG6PyQXv7QrkSqf1hN5S++YtUeuc27eiUXYqtJDEZuJh6rYGriL7ggTRkHIco3hDUhHtpGJDirP6Hw5aY8XGl1xCcO6RvZtZOvzICVyOXSI5zaTNHkZdNPu2yCnsxBBuPQyF09Xl7iKQcF3pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736958142; c=relaxed/simple;
	bh=wyCI3+mHFvFE+IFwTDC2jYXdMt+cAxXkfOzVA4mr1q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vdl8dlrkxcwTT1LvGNusGpYPjdaXz/KDMoo9bs2tph9UKGgSmiMnX3CJkKdDeSUzRhLc4cYhW4qBjjksEj7OqK6TyQKrDksU9B7mhlknA4+6tRFoTDROwojGl3IVaU838HWjyWyBdKVJDdzGv2RoUl+kLDlM5h093mMBk1oPmzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 15 Jan 2025 17:22:14 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v7 0/6] Dynamic hook interface binding part 1
Message-ID: <Z4fgrx9lX7NahyYg@calendula>
References: <20250109173137.17954-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250109173137.17954-1-phil@nwl.cc>

On Thu, Jan 09, 2025 at 06:31:31PM +0100, Phil Sutter wrote:
> Changes since v6:
> - Rebase onto "netfilter: nf_tables: imbalance in flowtable binding"
>   patch which is in nf-25-01-09 tag but missing in nf-next
> - Drop patch 7 which removed __nft_unregister_flowtable_net_hooks(): The
>   function is no longer a duplicate of nft_netdev_unregister_hooks()
> 
> This series makes netdev hooks store the interface name spec they were
> created for and establishes this stored name as the key identifier. The
> previous one which is the hook's 'ops.dev' pointer is thereby freed to
> vanish, so a vanishing netdev no longer has to drag the hook along with
> it. (Patches 2-4)
> 
> Furthermore, it aligns behaviour of netdev-family chains with that of
> flowtables in situations of vanishing interfaces. When previously a
> chain losing its last interface was torn down and deleted, it may now
> remain in place (albeit with no remaining interfaces). (Patch 5)
> 
> Patch 6 is a cleanup following patch 5, patch 1 is an independent
> code simplification.

Series applied to nf-next, thanks Phil.

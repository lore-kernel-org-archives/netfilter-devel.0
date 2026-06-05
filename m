Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EFE3BB685
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2026 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780670450; cv=none; b=e65t4/6AbosxdQU/yjxMK9t+j+bnb94e923yjaSixji/Zg87z0SWgnpF4+qJ7c5OgUR1KQGhKm1TDaFvtL6hYeT6CGTE30LbbZyq0Yru7d7uediSUdXxgdl6ywO6NzDd7huKelWyHNoXXg5nJUHwmuQS0Ape3ba3bqPzAWdgS/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780670450; c=relaxed/simple;
	bh=jgSqkBg44ONBcw0ms+VJvUkkgo7BVULZPod8TvbshtM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LdlkItWOfA92k4io/L03waB/AbUHYsBGqFmpaqIPHF7dTKs8wP32Uh1oI2kKBzFEWn3sBdkR/7hRaXxHhQPEzP+rZV24norNwZeWTtgCgVFUh8M/We1k+YEVWYOejkZn6ZH1FV8z3bn3NahdIC0KMJLDSUXlqsSmLr+AcBsILrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 33AA160425; Fri, 05 Jun 2026 16:40:46 +0200 (CEST)
Date: Fri, 5 Jun 2026 16:40:43 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4 2/5] netfilter: nf_conncount: use per
 nf_conncount_data spinlocks
Message-ID: <aiLf6wZh7GXBt0cd@strlen.de>
References: <20260605131123.19435-1-fw@strlen.de>
 <20260605131123.19435-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605131123.19435-3-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> -	data = kmalloc_obj(*data);
> +	data = kvzalloc_obj(*data);

AI suggest to add GFP_KERNEL_ACCOUNT here, but I don't plan to send
a new version just for this (it would likely only trigger more
goal-post-change comments).

The other comment in patch 5 is largely academic and not really
and issue.

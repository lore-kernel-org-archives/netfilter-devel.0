Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E5C3A6EEC
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 11:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774005989; cv=none; b=BRnEzfT1IJ3sn2pVEOjTuScxoKf4qqqkziL7n3app3cdiLf/W0jCysfqDidO2Auw4MYkoyCglt0RvyeWo7cc5Dh7rxBWNfzHIuCnTgoScsKD7pnJ0nvR56AD8TFK/2wRhEej4zV0cNNDpxzoMwbhTyTMeQwPTssD3Ek1Wb6JkOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774005989; c=relaxed/simple;
	bh=gA2iq7hJ8JFKfjf78DyeaRjKRhOCn9/vKqY+MW51WII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEru/vL74Q89gtnJnVVmTmvdxz+Is5KrBNSRf4IGcFcplDVEYDErcthlTgpOE7EozQKK+wx7C/2NqdpZX+/lVwoCaZEBhWNLb4BKjEHmHqZRZSDXg+5PElbiz0ptE4lvzIGf4eg1LKJucYyCKZCV2ZtRkYoWQA6P05aMzFyCFi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B6RBiIju; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B6RBiIju"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=U8wzQo4PkWQKNcCu+24EPHaxclGRjjSs9esmWd3kzAU=; b=B6RBiIju5wtLMask76olqhEIrh
	5CYg9LpvZXSAUQpaWztwaHEUre1qAcXl+Bjl0UJDc1TkCNPPTnv/UujaRL0UWyb7c4HIOZbb+x7tP
	JQzN976HHRllQkggmXksRmNHp6MNDwxxVAvf+qvPchqofnLGVlwfRjgAGBXGMgLVw8tQEYm07xNjO
	zx02icHTvYID+9bP9K/LntoA3L2CUv3Yn0brFZ9rhbm5sXgxPrngk3gf4xuEUaF2MLhegwQV6NmTj
	NaV3M7XSHdGNriiFgDIK0kag9OHr8UYQEZC2qx6F5utMK6a4NfuEiEriJ8ygCL/6lhoMfE4OGsl0g
	L7EYlYog==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3Xzk-000000006xo-3ZHk;
	Fri, 20 Mar 2026 12:26:24 +0100
Date: Fri, 20 Mar 2026 12:26:24 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <ab0u4JS4Z7THrP6B@orbyte.nwl.cc>
References: <20260313153220.19662-1-phil@nwl.cc>
 <abwegj2TijkaQVLz@strlen.de>
 <abwraHUuxizN4krg@orbyte.nwl.cc>
 <abwtAkSF8-SmH684@strlen.de>
 <abxlzn7lymOxWUFa@orbyte.nwl.cc>
 <abyTyJBv47f3v9gd@chamomile>
 <ab0enMtOAFiG0mSN@orbyte.nwl.cc>
 <ab0rbTfE7LWIk7f-@orbyte.nwl.cc>
 <ab0tB2o90FukwQxU@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab0tB2o90FukwQxU@strlen.de>

On Fri, Mar 20, 2026 at 12:18:31PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Fri, Mar 20, 2026 at 11:17:00AM +0100, Phil Sutter wrote:
> > [...]
> > > A remark from a practical perspective: Florian's suggestion to dump the
> > > nat-type chains in their order with the dispatcher's priority value is
> > > super-easy to implement (just have to pass the priority value to
> > > nfnl_hook_dump_one() via parameter) and does not require adjustments in
> > > user space.
> > 
> > Famous last words. :(
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index 4893af8322ae..b9efd3cfd3ce 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -2520,7 +2520,7 @@ static void basehook_list_add_tail(struct basehook *b, struct list_head *head)
>                         continue;
>                 if (!basehook_eq(hook, b))
>                         continue;
> -               if (hook->prio < b->prio)
> +               if (hook->prio <= b->prio)
>                         continue;
>  
>                 list_add(&b->list, &hook->list);
> 
> ?

Sure, but <=nftables-1.1.6 will still get it wrong. Can we tolerate
that?

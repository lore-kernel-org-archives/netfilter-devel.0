Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8507D4ACC9A;
	Fri, 18 Sep 2026 08:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789720906; cv=none; b=q2yq+P0elo/koG73ESz2G/ym6yAhnX4iPoYv23YRZGophffyMcApcSr3WTWc2mUoC7/MS5xj+WBGEEHz9uOvMsON02hIeJ+YDQOx/LsAh540uWTimkpT5Z7LvgmS0owflw0QA5knhmlcx0WXh0npR490piX/reNaMq7wyaq+vk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789720906; c=relaxed/simple;
	bh=GVYSUNom1POgP/Sk82oTd1LP02EaxE17oeIHbfRzLpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NFByFVeW+O6qyXXhwFFLyWxjLEsIyhxqLhxNCSvp0VeZworgsco2IlfxUOUviHo1nC9wv6GtPGYeZlD363OlvDXUFjnJxzUMt4Ojydz55bZMEJNA3KKBGnxFBXdqcwQCkb2FlnXlZHOZtr8gHzGofYQLQj574MdMusIB6nv35H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OmB7xTVH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OmB7xTVH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789720902;
	bh=0l48oSRSzotLHGeddhB1onLUzq5S9m/hjAPvhHMilFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OmB7xTVHjK3XsacV8NViuCcuCOFVZR2p/mrEyJjGnKGCxa3HJa8H4CNXc7xFQpK1m
	 DNiX5YdbE9i6rTDIh5I3I5Ewg1PMpysUE83Ypu+s9KJQ+PDvK7ko6Vr74CyYexhaU2
	 8fUxc7NE7uoofOxKQsHBVuRf35GCgVZmqYxuRqCW0Wu+Flq7z6xVTF1Xv4PhVrKATu
	 Xt5nEgzcjJm2Mg+sOAIYJH4BY7KVMf1274uGqneqST9UuDo0lbivcDXmNTaqI0n2jm
	 9ug+vqmPyVGMiQGl4E9kDZbw1l3QmGmcqDHX8kQcrJEpay1CHb4orKLrML0CbWBroU
	 aaCFFiiv9pOAQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5318E60076;
	Fri, 18 Sep 2026 10:41:42 +0200 (CEST)
Date: Fri, 18 Sep 2026 10:41:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 10/10] netfilter: nf_tables: skip expired catchall
 elements on insert and delete
Message-ID: <aqz5Q45wjggB0YBN@chamomile>
References: <20260916231652.127456-11-pablo@netfilter.org>
 <20260918020412.3513453-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918020412.3513453-1-kuba@kernel.org>

On Thu, Sep 17, 2026 at 07:04:12PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: nf_tables: skip expired catchall elements on insert and delete
> 
> This adds an expiry test to the catchall duplicate walk in
> nft_setelem_catchall_insert() and to the delete-candidate walk in
> nft_setelem_catchall_deactivate(), using the per-netns transaction
> timestamp.  The stated goal is to make both control-plane walks agree with
> the lookup and dump predicates.
> 
> A couple of questions on the new predicates and on the commit message.
> 
> > The delete path shows the same drift: nft_setelem_catchall_deactivate()
> > picks the first active-next entry in the catchall list, so with an
> > expired entry still pending GC it retires the stale entry instead of
> > the fresh one, and it deactivates an element that userspace no longer
> > sees instead of failing with -ENOENT.
> 
> [Severity: Low]
> Is the first half of this paragraph reachable before this patch?  The
> "expired entry still pending GC ... instead of the fresh one" wording
> implies a stale active-next entry and a fresh active-next entry can coexist
> in catchall_list.
> 
> Pre-patch nft_setelem_catchall_insert() rejected every entry that was
> active in the next generation, expired or not:
> 
> 	list_for_each_entry(catchall, &set->catchall_list, list) {
> 		ext = nft_set_elem_ext(set, catchall->elem);
> 		if (nft_set_elem_active(ext, genmask)) {
> 			*priv = catchall->elem;
> 			return -EEXIST;
> 		}
> 	}
> 
> The other ways an entry leaves active-next all unlink it from
> catchall_list (nft_trans_gc_catchall_sync(), the async GC completion) or
> happen on an explicit delete, and the non-EXCL add refreshed the existing
> element through nft_trans_elem_update() rather than linking a second one.
> So the "wrong entry retired" state seems to first become reachable because
> of the insert hunk in this same patch.
> 
> The second half (deactivating an element userspace no longer sees instead of
> returning -ENOENT) does look pre-existing.
> 
> Since the two hunks are interdependent, could the message say so explicitly
> so the stable backport is not split?

No need to split this stable backport...

> [Severity: High]
> Should this predicate also test nft_set_elem_is_dead()?

Yes, originally this patch checked for the dead and it is indeed need.

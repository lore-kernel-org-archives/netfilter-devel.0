Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399063F9F26;
	Fri, 11 Sep 2026 11:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789125302; cv=none; b=JiLxdp4ETOKiQioSDy6L/NDOwyAzYDE71Br94dXzEIfce1xQ0lYavdAl5vjx8bFfLjIGGK/Z2RTOSZ5ra7fTpbaBcYa9hPGfTrb45906ScahPRePrDYBr1CipqeF7WOgN+yQuig+awrzyajQWbYMv9Jy+5ujstUTMaYk3rwh5Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789125302; c=relaxed/simple;
	bh=9z3dYgMWb/tOv0KmrTVdDX+ydYolvLmVvBBhL8swSjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ca9Mh2YjHN4aUezgMPex0lwh5FeFWZH/qQSEKf0I3hQ6fIzgK7XN7tKbxOPxRGxGJH+U9amH/Dj+ZsbyN1cmaSW4CYtS0lKuu546LAVOeVBHeKNEzZHYlIyKwK/kn3UmaHVf/vWgIDu3tyBn3vCm3rBdWHp9sG1jDKyj5W5+Y+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b27G4EEq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b27G4EEq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789125297;
	bh=ijpw5B0ALKMOrNr17ZNQ0P4pO6xFuJNivKJm8MC9AMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b27G4EEqPwQF4J8bCvKPoiPiPMl9N9SQL9UlJG43cal+skl0XhMvfncgzQYlizO99
	 Pq1vnxYbctNacDg6q/iq73m7CRTx3HtDXBEMxP3Nr+YjPAKbGNQQAZz3+hUf9mLooO
	 0t8Yc5Od44yede5GjcHlGQZU5GzY1dTxETgn9OA8NInH285guFG3YgzIsKNJ1TnTC7
	 idpC1PP8SdmQGkT+lvz3R/4qoKDloopC+yfaMabTSJTg/YUC+bv6La90tmUY4uNwuc
	 vzm1E6D8osWUuY+JFc3jm8eAwH1YwE0ji76Ura3RKp6c6YTJeGe2HcKVuPqBkkGPR3
	 4lyro2NP7BpDQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 92CD4603DA;
	Fri, 11 Sep 2026 13:14:57 +0200 (CEST)
Date: Fri, 11 Sep 2026 13:14:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Aohan Mei <ljp1205831794@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	coreteam@netfilter.org, Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>, stable@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: nf_tables: skip expired catchall
 elements on insert and delete
Message-ID: <aqPirnuC6Rdebi8y@chamomile>
References: <20260910080324.2663491-1-ljp1205831794@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260910080324.2663491-1-ljp1205831794@gmail.com>

On Thu, Sep 10, 2026 at 04:03:19PM +0800, Aohan Mei wrote:
> From: Aohan Mei <henrymei@tencent.com>
> 
> nft_setelem_catchall_insert() looks up duplicates with
> nft_set_elem_active() only, while nft_set_catchall_lookup() and the
> dump path additionally skip expired elements.
> 
> Once a catchall element with a timeout expires, this predicate drift
> makes it invisible to userspace dumps, yet it still blocks
> re-insertion: with NLM_F_EXCL the request fails with -EEXIST, and
> without it the request reports success but silently inserts nothing.
> The stale entry only goes away when the (user-tunable) gc interval
> elapses, so the catchall rule may silently stop matching for an
> arbitrarily long time after its first expiration.
> 
> The delete path shows the same drift: nft_setelem_catchall_deactivate()
> picks the first active-next entry in the catchall list, so with an
> expired entry still pending GC it retires the stale entry instead of
> the fresh one, and it deactivates an element that userspace no longer
> sees instead of failing with -ENOENT.
> 
> Align both walks with the lookup and dump predicates: only an element
> that is active and not expired counts as a duplicate or delete
> candidate, using a single timestamp snapshot for the expiry checks.
> 
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Cc: stable@vger.kernel.org
> Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
> Assisted-by: CodeBuddy:Kimi-K3
> Signed-off-by: Aohan Mei <henrymei@tencent.com>
> ---
> v2: drop the is_dead check, it does not belong to this dedup walk;
>     use __nft_set_elem_expired() with a single timestamp snapshot;
>     also skip expired catchall elements in the delete path.
> v1: https://lore.kernel.org/netfilter-devel/REPLACE-WITH-V1-MESSAGE-ID
> 
>  net/netfilter/nf_tables_api.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 765a92fa90d6..0f3449cca5d2 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -6991,11 +6991,13 @@ static int nft_setelem_catchall_insert(const struct net *net,
>  {
>  	struct nft_set_elem_catchall *catchall;
>  	u8 genmask = nft_genmask_next(net);
> +	u64 tstamp = get_jiffies_64();

No, this does not work. This must use the tstamp that is stored in the
per-netns area.

>  	struct nft_set_ext *ext;
>  
>  	list_for_each_entry(catchall, &set->catchall_list, list) {
>  		ext = nft_set_elem_ext(set, catchall->elem);
> -		if (nft_set_elem_active(ext, genmask)) {
> +		if (nft_set_elem_active(ext, genmask) &&
> +		    !__nft_set_elem_expired(ext, tstamp)) {
>  			*priv = catchall->elem;
>  			return -EEXIST;
>  		}
> @@ -7088,11 +7090,13 @@ static int nft_setelem_catchall_deactivate(const struct net *net,
>  					   struct nft_set_elem *elem)
>  {
>  	struct nft_set_elem_catchall *catchall;
> +	u64 tstamp = get_jiffies_64();
>  	struct nft_set_ext *ext;
>  
>  	list_for_each_entry(catchall, &set->catchall_list, list) {
>  		ext = nft_set_elem_ext(set, catchall->elem);
> -		if (!nft_is_active_next(net, ext))
> +		if (!nft_is_active_next(net, ext) ||
> +		    __nft_set_elem_expired(ext, tstamp))
>  			continue;
>  
>  		kfree(elem->priv);
> -- 
> 2.43.7
> 

Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E97023E330;
	Tue,  8 Sep 2026 23:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788910282; cv=none; b=Nk+/wr686VXjUPvJnW2TOEneCRPA3Cka31jMVoECMVkAuDqqg2VCyoU7Npg7BpbkWdJDxfIv0k0/XOZR/MxJVXWLKFNVWQx/lgQsHrkgXQ3eAtW19xJhmKbw6qediFJj9c4hd1UYBu4Kfql3XwtsoEfRgNZNynWb+uFNn5FRohM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788910282; c=relaxed/simple;
	bh=Gzzp1+tOAMedx/WT7EyKmZ/QJAXMGM/0He57Va5jaeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUd3O9d0L2M5sOwuhW6Gwh4aT9IRrCcfANsYJJw6FvpN4fpILYqP4TGIjW4qC59gWx0Zwya++/Ti2Y7bPZH9Mk990TTqmMdq+VaizMV+cllWXPfdLMMUeXN1DZJKkz64Ohq7DZ+tlSE3jt54xlSRAi9Jn9naO8fOK37SO1yH5s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TPshBnJh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TPshBnJh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788910278;
	bh=ycnqXGekolSpCntoRVtRaY9Q+hJFbopbDliK1QMDK50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TPshBnJhdFHy6Mt5a9kVL5WptIkTS/LghmyDy5xWgZEEjNd7Qvq/wTyYT87wqfazI
	 LQfOHK6HPGO6mu9vF1PMk+fpzb7s4eaaS/H8potYeDBzKHC/BctmQsML7XgR/nfmUU
	 NN8OWQOIyASsRVfx91Q7mwxlYDv42jx9S8h7JAK4qqVGC2S6CB96qL3u0u9kDmYdB/
	 g/N9duATdqmx3jC8k3CeJHXygT71ZIjYr5uaZRxkYiOh3TMTtsKUCE5ZQ9ILpFHE/3
	 ZPcF4CvKLTuzZpRzNLOj8k2CzxLq2MyMD8yodudY51WmG9PTASrWKQ+p6Er+aPiyy9
	 Qx9sCIH8UdOQg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3D048607C9;
	Wed,  9 Sep 2026 01:31:18 +0200 (CEST)
Date: Wed, 9 Sep 2026 01:31:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Aohan Mei <ljp1205831794@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	coreteam@netfilter.org, Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>, stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: skip expired catchall elements
 in dedup walk
Message-ID: <aqCaw5aXx4B4E2Sm@chamomile>
References: <20260908123252.1162896-1-ljp1205831794@gmail.com>
 <aqCYmZ6_Kc0OqRcR@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqCYmZ6_Kc0OqRcR@chamomile>

On Wed, Sep 09, 2026 at 01:22:04AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 08, 2026 at 08:32:47PM +0800, Aohan Mei wrote:
> > From: Aohan Mei <henrymei@tencent.com>
> > 
> > nft_setelem_catchall_insert() looks up duplicates with
> > nft_set_elem_active() only, while nft_set_catchall_lookup() and the
> > dump path additionally skip expired and dead elements.
> > 
> > Once a catchall element with a timeout expires, this predicate drift
> > makes it invisible to userspace dumps, yet it still blocks
> > re-insertion: with NLM_F_EXCL the request fails with -EEXIST, and
> > without it the request reports success but silently inserts nothing.
> > The stale entry only goes away when the (user-tunable) gc interval
> > elapses, so the catchall rule may silently stop matching for an
> > arbitrarily long time after its first expiration.
> > 
> > Align the dedup walk with the lookup and dump predicates: only an
> > element that is active, not expired and not dead counts as a
> > duplicate.
> > 
> > Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> > Cc: stable@vger.kernel.org
> > Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
> > Assisted-by: CodeBuddy:Kimi-K3
> > Signed-off-by: Aohan Mei <henrymei@tencent.com>
> > ---
> >  net/netfilter/nf_tables_api.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 765a92fa90d6..6458ee26dcd9 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -6995,7 +6995,9 @@ static int nft_setelem_catchall_insert(const struct net *net,
> >  
> >  	list_for_each_entry(catchall, &set->catchall_list, list) {
> >  		ext = nft_set_elem_ext(set, catchall->elem);
> > -		if (nft_set_elem_active(ext, genmask)) {
> > +		if (nft_set_elem_active(ext, genmask) &&
> > +		    !nft_set_elem_expired(ext) &&
> 
> This should be:
>                     __nft_set_elem_expired(ext, tstamp) 

Delete also need this this expired check.

> > +		    !nft_set_elem_is_dead(ext)) {
> 
> I don't think dead flag is set on for catchall elements?

It does indeed use it, but I think this check does not belong here and
the check for expired is sufficient.

> >  			*priv = catchall->elem;
> >  			return -EEXIST;
> >  		}
> > -- 
> > 2.43.7
> > 
> > 

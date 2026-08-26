Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD693C4B6A
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 12:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787746057; cv=none; b=knLXWmqGzY1x8UxRvUX03vqHwGoxTR2pi4ywR1IDVm9tdBGt3BSuqfX/+zaJtPXX6RsgY1RmUcWCbMiNZ6rEiiK6M8/suZjO8vaYdXHwz9OlrE7jbNgJkzTcWluGAEEiAZb/X+bBN/raptzAO1zViW99mSvaEw4tog5/oq42qVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787746057; c=relaxed/simple;
	bh=UnfnELXK6Bzxmo+o24SHY0vgE6mzCg8TYnRederxZhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOfKfbt9Mv1YIouQHcXQgbPyJohUi/NCfEXp9WrVKIZe8vTtNImIBnjTHtInkgQHmL6NVGv6463VSp7ATJoiS++PJ9tyfywKR0TUSbbhoGbtKsgeJSBkwcWqCVKvW/VJOJJkx+ihcxIeOJ5hwLuR1qQ1J6aogxIebd85Xf2VfAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=barJnyRG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="barJnyRG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787746049;
	bh=EIkf152zNUygJWeIL8q8fMXUjacB4SH1WiHXuihX53Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=barJnyRG1Y31rYjMcrlgQP+7juJQ1i6P/y1VjucgvIdm/saMKgO43PGnaGwLij8mn
	 6Tyyxq/44En5c1jWPO7CAidNEirDsY62SrywZMqoERRexSDSwff8nft1dOtCYWPKtR
	 ZPbEYOe/G5i8nZ0TpOYECzILFS+oUB5ie9o3WLOF+JAd12uuoYLgwLgtk1tbVom92t
	 E4wBtCSkEgn89RUTY4nr2wxG4fHJprarKYmlvZqfm4SE5Q76bht/S2Ci0Q1R3XBfqd
	 4zdO1JgZcSQiyRGjgzg2TJk9ibrKou4rToSrlzX+p0awYgLRTDbrM5KM8wxiCK0dY4
	 Y7waQk7cZ6GPw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2466560078;
	Wed, 26 Aug 2026 14:07:29 +0200 (CEST)
Date: Wed, 26 Aug 2026 14:07:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, fw@strlen.de, Wei Fang <void0red@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nf_tables: fix device name and prefix
 match in hook lookup
Message-ID: <ao7W_vGPRUXq4dvp@chamomile>
References: <20260824092805.4940-1-fmancera@suse.de>
 <ao7D-ZH3oN8qrxw9@orbyte.nwl.cc>
 <694e353c-3d03-468c-9001-b2872d8ae9f7@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <694e353c-3d03-468c-9001-b2872d8ae9f7@suse.de>

Hi Fernando,

On Wed, Aug 26, 2026 at 12:55:32PM +0200, Fernando Fernandez Mancera wrote:
> On 8/26/26 12:46 PM, Phil Sutter wrote:
> > On Mon, Aug 24, 2026 at 11:28:05AM +0200, Fernando Fernandez Mancera wrote:
> > > Currently, a netdev chain or flowtable hooked to a device prefix can be
> > > unintentionally deleted by a control-plane request targeting an exact
> > > device name or even a shorter one due to the usage of min() to calculate
> > > the length to match.
> > > 
> > > Fix this by making sure an exact device match never matches a prefix and
> > > that both the target and the candidate have the same length during
> > > delete operation. The add and update paths retain the existing overlap
> > > matching to prevent a single device from matching multiple hooks.
> > > 
> > > Reported-by: Wei Fang <void0red@gmail.com>
> > > Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
> > > Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> > > Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> > > ---
> > >   net/netfilter/nf_tables_api.c | 27 ++++++++++++++++++++++++---
> > >   1 file changed, 24 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > index c112ecc4fca3..3ad9a5e88c5b 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -1978,7 +1978,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
> > >   	return -ENOSPC;
> > >   }
> > > -static bool hook_is_prefix(struct nft_hook *hook)
> > > +static bool hook_is_prefix(const struct nft_hook *hook)
> > >   {
> > >   	return strlen(hook->ifname) >= hook->ifnamelen;
> > >   }
> > > @@ -2457,6 +2457,27 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
> > >   	return NULL;
> > >   }
> > > +static struct nft_hook *nft_hook_list_find_strict(struct list_head *hook_list,
> > > +						  const struct nft_hook *this)
> > > +{
> > > +	struct nft_hook *hook;
> > > +
> > > +	list_for_each_entry(hook, hook_list, list) {
> > > +		if (hook_is_prefix(hook) != hook_is_prefix(this))
> > > +			continue;
> > 
> > I don't think this is necessary: The first ifnamelen chars of both
> > hooks' ifname either contain the NUL-char or not. If both ifnamelen
> > values are identical, the following strncmp will only match if either
> > both are prefixes or both are not.
> > 
> > (I realized my initial approach using max() won't work when comparing
> > "eth0\0" (non-prefix) to "eth0" (prefix) as the latter is followed by
> > NUL-chars as well.)
> > 
> > > +		if (hook->ifnamelen != this->ifnamelen)
> > > +			continue;
> > 
> > Given the above, this could become 'if (strict && hook-ifnamelen !=...)'
> > in nft_hook_list_find with extra parameter, up to you.
> > 
> 
> Hm, that is true. I am sending a v3 following this method as it is simpler.
> 
> Pablo, feel free to pick up either this v2 or the v3 I am sending. Both
> are fine to me.

I can wait for a few hours before the next PR if you'd like to explore
the v3.

Thanks.

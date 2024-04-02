Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08C482893
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Apr 2024 13:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712066123; cv=none; b=cKoZ4nnUaDc4l2U+PreH8HNVr5y2f/pPMDc5dTQcVEGcYlbNPVdfkMbBVDmpkeKV+nABmXxRHNRsiJ91sRbMpH9AncDLWvRWuNR9HxnGZAoWadAaPgDTVNHjRDeqhIINK40jIZ+/7PRPtPactHBMc7t8nLxQBECijUIqIi/BHxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712066123; c=relaxed/simple;
	bh=RddDWiCcYRKyMyLbNnbNhtp1AvxmYO6iSxpybs3Nbcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SnV12UaBEtwuIRtpmPF3DRYiVayLG8szO0VMisi2ULriXf5Th+OqJXvfY7WPPJnc+xSBzLRyL7NxPQNoSbIkRpK2X6krMMpXkaDDC1kvzoeQW5Z9QR8GyYIVCK7XIjiLQvB4V0SkcocvGBKw9XdoJRusJc01V6tWz+eQ1Mg587Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rreba-0006ee-1J; Tue, 02 Apr 2024 15:55:14 +0200
Date: Tue, 2 Apr 2024 15:55:14 +0200
From: Florian Westphal <fw@strlen.de>
To: "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
	kadlec@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] netfilter: nf_tables: Fix pertential data-race in
 __nft_flowtable_type_get()
Message-ID: <20240402135514.GC18301@breakpoint.cc>
References: <20240401133455.1945938-1-william.xuanziyang@huawei.com>
 <20240402105642.GB18301@breakpoint.cc>
 <8393b674-2ad9-404f-8795-4a871240bf1b@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8393b674-2ad9-404f-8795-4a871240bf1b@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Ziyang Xuan (William) <william.xuanziyang@huawei.com> wrote:
> >> Use list_for_each_entry_rcu() with rcu_read_lock() to Iterate over
> >> nf_tables_flowtables list in __nft_flowtable_type_get() to resolve it.
> > 
> > I don't think this resolves the described race.
> > 
> >> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> >> ---
> >>  net/netfilter/nf_tables_api.c | 8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> >> index fd86f2720c9e..fbf38e32f11d 100644
> >> --- a/net/netfilter/nf_tables_api.c
> >> +++ b/net/netfilter/nf_tables_api.c
> >> @@ -8297,10 +8297,14 @@ static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
> >>  {
> >>  	const struct nf_flowtable_type *type;
> >>  
> >> -	list_for_each_entry(type, &nf_tables_flowtables, list) {
> >> -		if (family == type->family)
> >> +	rcu_read_lock()
> >> +	list_for_each_entry_rcu(type, &nf_tables_flowtables, list) {
> >> +		if (family == type->family) {
> >> +			rcu_read_unlock();
> >>  			return type;
> > 
> > This means 'type' can be non-null while module is being unloaded,
> > before refcount increment.
> > 
> > You need acquire rcu_read_lock() in the caller, nft_flowtable_type_get,
> > and release it after refcount on module owner failed or succeeded.
> > .
> In fact, I just want to resolve the potential tear-down problem about list entry here.

cpu1							cpu2
							rmmod
							flowtable_type

nft_flowtable_type_get
     __nft_flowtable_type_get
          finds family == type->family
	     						list_del_rcu(type)

CPU INTERRUPTED
							rmmod completes

nft_flowtable_type_get calls
   if (type != NULL && try_module_get(type->owner))
	   ---> UaF

Skeleton fix:

nft_flowtable_type_get(struct net *net, u8 family)
 {
 	const struct nf_flowtable_type *type;

+       rcu_read_lock();
	type = __nft_flowtable_type_get(family);
	....
 	if (type != NULL && try_module_get(type->owner)) {
		rcu_read_unlock();
 		return type;
	}

	rcu_read_unlock();

This avoids the above UaF, rmmod cannot complete fully until after
rcu read lock section is done.  (There is a synchronize_rcu in module
teardown path before the data section is freed).

> So I think replace with list_for_each_entry_rcu() can resolve the tear-down problem now.

I don't think so.

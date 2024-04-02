Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A6560266
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Apr 2024 11:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712057435; cv=none; b=nxNmVCZByQSuTkAqOBnVAAGx9O+/w3ndQdFVhwYHCDOvb2Bepq+x5CzhKHZLDQ+YQCpXweCAa63FnRKViFr7qMyNXeN+aBrAss7D01dVXy0egNBpoe29NUIfJ+kRNhlhLab31+EEgvf6lTnuj3sv0lf5RLd1H5AQaFgGoklaDaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712057435; c=relaxed/simple;
	bh=cs3N6G1uRoOl2IFucMtRTpR3CvERb3u009Wx1MIbOBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6BGpdmwVzDOXLjeq+8C5D411epltx8plUSokFhfxaRBtIvHinRytVUaaibeQbT7UX6s5gFs+TeW67d9uJfj/lT9iMfFBgthD1vUVEfxridbrUoA8drpIaDmF0Tx8vfvYhtB8HVS/L7eL8JorB/lgCYFcm1XTQP8syFvfgp098w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 2 Apr 2024 13:30:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Ziyang Xuan <william.xuanziyang@huawei.com>, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] netfilter: nf_tables: Fix pertential data-race in
 __nft_flowtable_type_get()
Message-ID: <ZgvsTTsCUay4GCUa@calendula>
References: <20240401133455.1945938-1-william.xuanziyang@huawei.com>
 <20240402105642.GB18301@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240402105642.GB18301@breakpoint.cc>

On Tue, Apr 02, 2024 at 12:56:42PM +0200, Florian Westphal wrote:
> Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
> > nft_unregister_flowtable_type() within nf_flow_inet_module_exit() can
> > concurrent with __nft_flowtable_type_get() within nf_tables_newflowtable().
> > And thhere is not any protection when iterate over nf_tables_flowtables
> > list in __nft_flowtable_type_get(). Therefore, there is pertential
> > data-race of nf_tables_flowtables list entry.
> > 
> > Use list_for_each_entry_rcu() with rcu_read_lock() to Iterate over
> > nf_tables_flowtables list in __nft_flowtable_type_get() to resolve it.
> 
> I don't think this resolves the described race.
> 
> > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> > ---
> >  net/netfilter/nf_tables_api.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index fd86f2720c9e..fbf38e32f11d 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -8297,10 +8297,14 @@ static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
> >  {
> >  	const struct nf_flowtable_type *type;
> >  
> > -	list_for_each_entry(type, &nf_tables_flowtables, list) {
> > -		if (family == type->family)
> > +	rcu_read_lock()
> > +	list_for_each_entry_rcu(type, &nf_tables_flowtables, list) {
> > +		if (family == type->family) {
> > +			rcu_read_unlock();
> >  			return type;
> 
> This means 'type' can be non-null while module is being unloaded,
> before refcount increment.
> 
> You need acquire rcu_read_lock() in the caller, nft_flowtable_type_get,
> and release it after refcount on module owner failed or succeeded.

And these need to be rcu protected:

static LIST_HEAD(nf_tables_expressions);
static LIST_HEAD(nf_tables_objects);
static LIST_HEAD(nf_tables_flowtables);

for a complete fix for:

f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")

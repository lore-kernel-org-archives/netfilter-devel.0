Received: from mail.netfilter.org (unknown [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58AE1F7577;
	Fri, 17 Jan 2025 11:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737112388; cv=none; b=KX7GyF51JSO22NhgVUhtBkSg+8eVbPzyg/CPKSfDZ60u6F34dcYM1V8dXaLj8R3rTiapzsXrUAFam8vKss94XJs/9jUt2OjaYmTK7L44FUxWwcyQmiPNwAEvXXV7a2Gi2onP1SsYqwL4wkz11FzsK60ZgG7fXt74sMSSQy57lw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737112388; c=relaxed/simple;
	bh=XUX+55rtMQoeYlACZI4MM+XpjNlzl2KjWCDqK2xitTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P6DlWYdhAMTwPksi9R3itA/B8lDhEVooPblxWECqbcR4BVMQu3q7xV583r+qDVZXpw46ZaxZdKUpn4Z1yWKktt3pdsWfKr7ZJx2GpYLFZbSl8/Ys418LustUXlyi66AvXKXvhrbH412uinh7/37Zeby7lmerVWdThXatJsreVus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Fri, 17 Jan 2025 12:12:49 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net-next 01/14] netfilter: nf_tables: fix set size with
 rbtree backend
Message-ID: <Z4o6-xme3AbmzrYW@calendula>
References: <20250116171902.1783620-1-pablo@netfilter.org>
 <20250116171902.1783620-2-pablo@netfilter.org>
 <20250117104957.GK6206@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250117104957.GK6206@kernel.org>

Hi Simon,

On Fri, Jan 17, 2025 at 10:49:57AM +0000, Simon Horman wrote:
> On Thu, Jan 16, 2025 at 06:18:49PM +0100, Pablo Neira Ayuso wrote:
> > The existing rbtree implementation uses singleton elements to represent
> > ranges, however, userspace provides a set size according to the number
> > of ranges in the set.
> > 
> > Adjust provided userspace set size to the number of singleton elements
> > in the kernel by multiplying the range by two.
> > 
> > Check if the no-match all-zero element is already in the set, in such
> > case release one slot in the set size.
> > 
> > Fixes: 0ed6389c483d ("netfilter: nf_tables: rename set implementations")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  include/net/netfilter/nf_tables.h |  3 ++
> >  net/netfilter/nf_tables_api.c     | 49 +++++++++++++++++++++++++++++--
> >  net/netfilter/nft_set_rbtree.c    | 43 +++++++++++++++++++++++++++
> >  3 files changed, 93 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> > index 0027beca5cd5..7dcea247f853 100644
> > --- a/include/net/netfilter/nf_tables.h
> > +++ b/include/net/netfilter/nf_tables.h
> > @@ -495,6 +495,9 @@ struct nft_set_ops {
> >  					       const struct nft_set *set,
> >  					       const struct nft_set_elem *elem,
> >  					       unsigned int flags);
> > +	u32				(*ksize)(u32 size);
> > +	u32				(*usize)(u32 size);
> > +	u32				(*adjust_maxsize)(const struct nft_set *set);
> >  	void				(*commit)(struct nft_set *set);
> >  	void				(*abort)(const struct nft_set *set);
> >  	u64				(*privsize)(const struct nlattr * const nla[],
> 
> Hi Pablo,
> 
> As a follow-up could these new fields be added to
> the Kernel doc for nft_set_ops?

Sure, I can do that.

I can also send a v2 for this pull request if more comments accumulate.

Thanks.

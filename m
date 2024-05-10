Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2614C21340
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 10:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715338322; cv=none; b=W3jlqVxSPxmmBIGGnqx/e6Lmq4nkzBhmEeybtexVzUmX9EbHpqtCjO6LNzkjwxvdoDRSy6DfVtYwcCH8iJIA1uSASxcojB9oIO6FeNqJibLs1YUNHKDjiRh0CCDr2/azE67/b8w605n4s8ozc6lAMLSxq5/0p8BmPyuSTTKs9Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715338322; c=relaxed/simple;
	bh=Tk9HvgGnZV8xwh6fIPlAAKJ+C239r6Qg5qsPEL4qq40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gv3zC4y0zeNLsFsOkO2auiDsBX4dPoCQybTfXzSHknZmvUaWkqjVqUPXlyI9q+4zmBE+bWahOeDypqYHKF1y477Ftermhro0sVch0FW9jwqP6Ikd3/16m481VEgYpas7UJ801W1DOFlX+Fw88dSgfrRzfr2F9MlspNMI+Z9GCMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Fri, 10 May 2024 12:51:53 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: Could not process rule: Cannot allocate memory
Message-ID: <Zj38SZbf2EfzmTpC@calendula>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
 <20240508140820.GB28190@breakpoint.cc>
 <20240510090629.GD16079@breakpoint.cc>
 <qhjlvlrbtoxmlmowgkku3gqqgczzdyvvm4urz3322qbzxwqbc3@ns35urbmwknj>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <qhjlvlrbtoxmlmowgkku3gqqgczzdyvvm4urz3322qbzxwqbc3@ns35urbmwknj>

On Fri, May 10, 2024 at 12:45:15PM +0200, Sven Auhagen wrote:
> On Fri, May 10, 2024 at 11:06:29AM +0200, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > > > When the sets are larger I now always get an error:
> > > > ./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
> > > > destroy table inet filter
> > > > ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > along with the kernel message
> > > > percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left
> > > 
> > > This specific pcpu allocation failure aside, I think we need to reduce
> > > memory waste with flush op.

Agreed.

One more question below.

> > Plan is:
> > 
> > 1. Get rid of ->data[] in struct nft_trans.
> >    All nft_trans_xxx will add struct nft_trans as first
> >    member instead.
> > 
> > 2. Add nft_trans_binding.  Move binding_list head from
> >    nft_trans to nft_trans_binding.
> >    nft_trans_set and nft_trans_chain use nft_trans_binding
> >    as first member.
> >    This gets rid of struct list_head for all other types.
> > 
> > 3. Get rid of struct nft_ctx from nft_trans.
> >    As far as I can see a lot of data here is redundant,
> >    We can likely stash only struct net, u16 flags,
> >    bool report.
> >    nft_chain can be moved to the appropriate sub-trans type
> >    struct.
> 
> Here is also a minimal example to trigger the problem.

Can you still see this after Florian's patch?

> I left out the ip addresses:
> 
> destroy table inet filter
> 
> table inet filter {
> 
>     set SET1_FW_V4 {
>         type ipv4_addr;
>         flags interval;
>         counter;
>         elements = { }
>     }
> 
>     set SET2_FW_V4 {
>         type ipv4_addr;
>         flags interval;
>         counter;
>         elements = { }
>     }
> 
>     set SET3_FW_V4 {
>         type ipv4_addr;
>         flags interval;
>         counter;
>         elements = { }
>     }
> 
>     set SET4_FW_V4 {
>         type ipv4_addr;
>         flags interval;
>         counter;
>         elements = { }
>     }
> 
>     chain input {
>         type filter hook input priority 0;
>         policy accept;
> 
>         ip saddr @SET1_FW_V4 drop
>         ip saddr @SET2_FW_V4 drop
>         ip saddr @SET3_FW_V4 drop
>         ip saddr @SET4_FW_V4 drop
>     }
> }
> 

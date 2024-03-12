Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228714DA10
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 12:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710247782; cv=none; b=ay1z2DPecHLhLSNwMb6YjF0pOurrSZl1XLilG3c319QYNSO/Eok7nwCzbXUcYHIZUuaifZdVPuwWmBnTBGoLh6NQDuZA6LoeLp+gg+mcAI9AGT7f5+iJT8rFiTydoyDw6etk3vO+Tjminos6Lp0D/pHsGt11IAvFHE+PBYVguqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710247782; c=relaxed/simple;
	bh=Rzl8NgPWBGNGuO92JuySIeFU1P4BI4VWyTMJ3sZ0TpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uySwMlyb6KvR08Q6lQaEWukPMaTi5K9WbytIKrmSYwO9X0Xgb731OLD1wMzFpKjjyscngPqLdQ+mtJKX/VbtJyfWj/RJBgPzEhhvTpHaFTtaQdbVrfPaT+JQHSpHRFjY7PgV8VBHLbjNI2/HcnlHbzOTyGgjolMSYLkpPQlipIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 12 Mar 2024 13:49:27 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Quan Tian <tianquan23@gmail.com>, netfilter-devel@vger.kernel.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <ZfBO8JSzsdeDpLrR@calendula>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
 <20240312122758.GB2899@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240312122758.GB2899@breakpoint.cc>

On Tue, Mar 12, 2024 at 01:27:58PM +0100, Florian Westphal wrote:
> Quan Tian <tianquan23@gmail.com> wrote:
> > The NFTA_TABLE_USERDATA attribute was ignored on updates. The patch adds
> > handling for it to support table comment updates.
> 
> One generic API question below.  Pablo, please look at this too.
> 
> >  		case NFT_MSG_NEWTABLE:
> >  			if (nft_trans_table_update(trans)) {
> > -				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
> > -					nft_trans_destroy(trans);
> > -					break;
> > +				if (trans->ctx.table->flags & __NFT_TABLE_F_UPDATE) {
> > +					if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
> > +						nf_tables_table_disable(net, trans->ctx.table);
> > +					trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
> >  				}
> > -				if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
> > -					nf_tables_table_disable(net, trans->ctx.table);
> > -
> > -				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
> > +				swap(trans->ctx.table->udata, nft_trans_table_udata(trans));
> > +				nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE
> 
> AFAICS this means that if the table as udata attached, and userspace
> makes an update request without a UDATA netlink attribute, we will
> delete the existing udata.
> 
> Is that right?
> 
> My question is, should we instead leave the existing udata as-is and not
> support removal, only replace?

I would leave it in place too if no _USERDATA is specified.

One more question is if the memcmp() with old and new udata makes
sense considering two consecutive requests for _USERDATA update in one
batch.

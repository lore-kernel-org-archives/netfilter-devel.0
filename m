Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3DA1E865
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254199; cv=none; b=O17cfJjoqiIvATUkcFPYXXHhjNTIcb+LW3TZXcYx/w6OJvT8cRsotcEZG/3toWES56nZ3U5zTiwdj8SMs38j8nR4jP6bFhcPPuvaHziK6dWiRGNUGBepo7ANgcEi9+r5FWjfiSC5UhsBaFdJROEUUGwGXWqgu5NqllB0LfYuSXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254199; c=relaxed/simple;
	bh=rjy64Hh/nKnzXF4euC9Qctae+VnB2YXA32g4quePsWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxW93QabUQ46E/Y1xnUhS5tgMKkZ6GYhknrVhzk6Y4F5/k+3ZGa0GpiV4iA5xmCMco45LVMyRek6+guw+S4HP7ktLH7aD2sIjOjJHGB0eFHi8S1kX+8l0kI6B2slgEFA08yrWplczIJNZmPmrvOdxZgCGydocrAX3E7BUCp5WrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 12 Mar 2024 15:36:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Quan Tian <tianquan23@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <ZfBocE3NmADQnnJT@calendula>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
 <20240312122758.GB2899@breakpoint.cc>
 <ZfBO8JSzsdeDpLrR@calendula>
 <20240312130134.GC2899@breakpoint.cc>
 <ZfBmCbGamurxXE5U@ubuntu-1-2>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZfBmCbGamurxXE5U@ubuntu-1-2>

On Tue, Mar 12, 2024 at 10:26:17PM +0800, Quan Tian wrote:
> On Tue, Mar 12, 2024 at 02:01:34PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > AFAICS this means that if the table as udata attached, and userspace
> > > > makes an update request without a UDATA netlink attribute, we will
> > > > delete the existing udata.
> > > > 
> > > > Is that right?
> > > > 
> > > > My question is, should we instead leave the existing udata as-is and not
> > > > support removal, only replace?
> > > 
> > > I would leave it in place too if no _USERDATA is specified.
> > > 
> 
> Sure, I will change it in the proposed way.
> 
> > > One more question is if the memcmp() with old and new udata makes
> > > sense considering two consecutive requests for _USERDATA update in one
> > > batch.
> > 
> > Great point, any second udata change request in the same batch must fail.
> > 
> > We learned this the hard way with flag updates :(
> 
> Is it the same as two consectutive requests for chain name update and
> chain stats update? 
> 
> In nf_tables_commit():
> The 1st trans swaps old udata with 1st new udata;
> The 2nd trans swaps 1st new udata with 2nd new udata.
>
> In nft_commit_release():
> The 1st trans frees old udata;
> The 2nd trans frees 1st new udata.

And abort path simply releases the transaction objects, since udata
was left intact in place.

> So multiple udata requests in a batch could work?

Yes, if rcu is used correctly, that should work fine. But memcmp()
needs to be removed.

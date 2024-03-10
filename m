Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C66EEAB
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 22:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710109988; cv=none; b=XOnv0eAfXKQvTFIgI66P+NTPQgM71Shn+oYO8Zr5JuMJ5pkhfKSnaoBCkk/Pphn5yiSf6CfBC8I7GFOyDztRpXmeFkBmJYWfyqwHP0+3m0qVktgZYKRiEbesvqY4tb0B9yzXj8lYCpsxkLoWfTO8vka13WdZlFmbTX2VHiPeQXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710109988; c=relaxed/simple;
	bh=bbkf2JzZedzifGTpY15Nz6+lZb52Y7eDN1fPkhA2TZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuIquBMEFluzW/lCFTG+h0TYuaSWqHGupmvlEFpeeruvhaDqi5hmwili0XlhswO9p77juQ/DdjPKo/l3Cx1jE9SHagcjJDmgzChRxY4Hw2mkgNyEGa0LxF8mqnTTgF+mhzS4GKmfeyP+1Ppz0JgvQdbMGSj8blelq99h5vU/YVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.33.11] (port=40062 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rjRj0-0054bJ-W4; Sun, 10 Mar 2024 23:33:00 +0100
Date: Sun, 10 Mar 2024 23:32:58 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: fix updating/deleting devices
 in an existing netdev chain
Message-ID: <Ze41GvbmjkJbEtAj@calendula>
References: <20240310205008.117707-1-pablo@netfilter.org>
 <20240310220340.GC16724@breakpoint.cc>
 <Ze403GkKKZ9IhQd9@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ze403GkKKZ9IhQd9@calendula>
X-Spam-Score: -1.9 (-)

On Sun, Mar 10, 2024 at 11:31:59PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Mar 10, 2024 at 11:03:40PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Updating netdev basechain is broken in many ways.
> > > 
> > > Keeping a list of pending hooks to be added/deleted in the transaction
> > > object does not mix well with table flag updates (ie. setting dormant
> > > flag in table) which operate on the existing basechain hook list.
> > > Instead, add/delete hook to/from the basechain hook list and allocate
> > > one transaction object per new device to refers to the hook to
> > > add/delete.
> > > 
> > > Add an 'inactive' flag that is set on to identify devices that has been
> > > already deleted, so double deletion in one batch is not possible.
> > 
> > Do you think it makes sense to remove dormant flag support
> > for the netdev family?
> > 
> > It would avoid the register/unregister entanglements and might
> > reduce headaches down the road.
> > 
> > IOW, do you think dormant flag toggling is useful for netdev family?
> 
> I would disable it for the netdev family, yes.

As a side note, the flowtable already does not support for the dormant flag.

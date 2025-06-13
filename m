Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439752C1583
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 10:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749809753; cv=none; b=l9LyU2rOuzsbpYvUMLGuEQorNs3PwS1Avsj1ebtTBLC5a9keYzImLYDeRz0hjjAUbYqmqPZ9wQOE+j2NEYJXPYc3YEatGL1ez/Gq6CMZeJxNjZ1aVgNMMYeLv4ELKnKq0KG5uN+o3ACAM/HdDfU6Kv/ncl8EdXSY2a0vB2tzbWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749809753; c=relaxed/simple;
	bh=2lvArcGGHHbvFKitO/pLLo0FI/tSwW3Z8ShmAT1QnPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5rVljwAU8Qswi2olIzzAlV8RDpohh6T/JO+gparwaT1kl6rODAK+F9ey3aIQUvyyxPRgiJdrm8Yb+b+fymCpqhGvvhpvhnPzFVEBqyjyaNTaamQc0k4PKAnd1Sy3TzoErTPxeMnUufvu7UR30q/3x4RmB5OoyBfXPXPC6FsSYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eKkvWZcQ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eKkvWZcQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LYw4l9+j1y0/tHxOjcY1mhaSKX7nJjkrRUhICNEhJXI=; b=eKkvWZcQzDLAyK1hToHY7zF2BL
	znBnhGKc7Bp1lApzV9pcTekGeDYJx7OzskKq5mZ0W42naUMh21Z0P4nBwLAfQc91Rz30QdeVo9pje
	x+xS8g0dTqUSWSbewBwwZQUyyNXo+IE1yD/keTV3fjHRoGgj511CwuYsZyfhLSxjR70GLlxavm7o3
	Zm/eNuvH8ZTQ60Vf+r+9g5scmA8pKV8ihV1FcbxUEKmvQc2dARtVMXaEZsyKCD1jQikTSi9y0KqDW
	2QK1O6PviVIYiwXk1MSDA709YLxr8/xPj04sxo0lbDSqpWksoHu4Xen4pR2x7WNeWjSq79b7BanDX
	eqqYso+w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uQ1Rs-000000000c4-0CSD;
	Fri, 13 Jun 2025 12:15:48 +0200
Date: Fri, 13 Jun 2025 12:15:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Fix for extra data in
 delete notifications
Message-ID: <aEv6Ux5N-IgQAX3A@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250612183024.1867-1-phil@nwl.cc>
 <aEtXyu1FD6cxDeRf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEtXyu1FD6cxDeRf@calendula>

On Fri, Jun 13, 2025 at 12:42:18AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 12, 2025 at 08:30:24PM +0200, Phil Sutter wrote:
> > All routines modified in this patch conditionally return early depending
> > on event value (and other criteria, i.e., chain/flowtable updates).
> > These checks were defeated by an upfront modification of that variable
> > for use in nfnl_msg_put(). Restore functionality by avoiding the
> > modification.
> 
> Thanks for fixing this.

Took me more than a moment to notice! I guess 'var = func(var)' is
convenient, but also bad practice. :)

> > This change is particularly important for user space to distinguish
> > between a chain/flowtable update removing a hook and full deletion.
> > 
> > Fixes: 28339b21a365 ("netfilter: nf_tables: do not send complete notification of deletions")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Channeling this through -next despite it being a fix since unpatched
> > nft monitor chokes on the shortened delete flowtable notifications.
> 
> I am afraid this patch will end up in -stable, breaking userspace, how
> bad is the choking? Maybe 28339b21a365 needs to be reverted, then fix
> userspace to prepare for it and re-add it in nf-next?

Oh right, the Fixes: tag will probably cause that. User space segfaults
dereferencing a NULL-ptr. Happens in netlink_delinearize_{obj,flowtable}
which are called during cache population, ergo all users affected.

> Not sure what path to follow with this.

If dropping the Fixes: tag was sufficient, there remains a risk that
someone else notices the bug and fixes it. If we do treat the revert of
28339b21a365 as a "fix", can we legally tag it as fixing itself? :D

If so, I'd do that and reintroduce the feature in bug-free form.

Thanks, Phil

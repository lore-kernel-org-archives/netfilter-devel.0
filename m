Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20BD1D5175
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 21:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741815593; cv=none; b=sXbP/02IYfBrhDbhHrFbSGXvvCIMATy1wJ7H455fuMpaS0l6hAenAGNaGGKchSHXbEf4IMpR0THmylNu8k67AahHaEkKQKWfGSBKAWC0mYpxJ6pYguI/CDt8kLncjXhUzWxwY2VBi/cxH1vQwKEx7TvIMZ3dmkWtx4Mk/2c/XTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741815593; c=relaxed/simple;
	bh=K3BhpzoZKx3kKjdwXbeQLK3bpeWPg6HWdB+19B/75ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g90UDkk3w7V2zhTvP6VBSB/zLc5gAisNxD88sfu7Mig7dktCb4IsLt0om9eHYPB2RIZWTRRGNNq/OP+5w88EV05hy1PWrjK8hI7ybUsuGHsSiAacQdZPR308ngo4np0WkVkAxOOjyT5anMdEGBPLtAYd/ygCt8omBOQgT0+VpQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsTno-0002hi-WF; Wed, 12 Mar 2025 22:39:49 +0100
Date: Wed, 12 Mar 2025 22:39:48 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_conntrack: speed up reads from
 nf_conntrack proc file
Message-ID: <20250312213948.GC4233@breakpoint.cc>
References: <20250211130313.31433-1-fw@strlen.de>
 <Z9G8TcHOTdn7LBsj@calendula>
 <20250312182838.GB3007@breakpoint.cc>
 <Z9HkUgJgQBHXrR6Z@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9HkUgJgQBHXrR6Z@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 2. skip to next and miss an entry
> 
> I think we can still display duplicates in 2. too since nulls check if
> the iteration finished on another bucket? Then 2. means skipped
> entries and duplicates.

Yes, but its not a change in behaviour, this was never a stable walk.

> > I'm not sure whats worse/better.
> 
> Skipping looks simpler, it is less code. But if entries are duplicated
> then userspace has a chance to deduplicate?

Lets just give up and nuke the entire functionality, i.e. /proc
interface removal.

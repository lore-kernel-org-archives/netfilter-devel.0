Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76165317162;
	Tue, 11 Aug 2026 20:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786479818; cv=none; b=U7YS7jTrMr70tDTQtdbwbYyeL71UawLiOUKgvoBFp63MK865LE3+ka6sPhDcx4xWaEFaUtezUyPoX/zXW/Hz4GXnL+0VGhwTRYPnoze9ol0Xv46JZ6IwCIjbM4iJIvG1vx1L21RSmk/g0QEej+Cw4nU3srUmLFtEKjtHWH7vfBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786479818; c=relaxed/simple;
	bh=rFuFtSTnSBdb7eBzCn6bcuwS2zhAQklee4DbQNkhdTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qu8hijge4zTeaX9rbw7355Qss9aGv5YOXotkEkSkWrredHAVvpbcY/6dbI7aRjnoOvhCWe4chO9maXJ4/6bWkRxpTenGsR1WvZJjvGr2KDLj0FiP7uZJSEIkLebeTkbLUeogLscEsr5zb2P5ThMQwwiLkF5mTNRwQl6bDUv52Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B9AF560455; Tue, 11 Aug 2026 22:23:33 +0200 (CEST)
Date: Tue, 11 Aug 2026 22:23:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net 00/13] Netfilter/IPVS fixes for net
Message-ID: <anuEqSHXJtF9bqTi@strlen.de>
References: <20260810190621.894119-1-pablo@netfilter.org>
 <20260811124434.76ab55d9@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811124434.76ab55d9@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 10 Aug 2026 21:06:08 +0200 Pablo Neira Ayuso wrote:
> > The following patchset contains Netfilter/IPVS fixes for net. Still
> > large batch for this late -rc cycle but at least have of these fixes in
> > this batch have been cooking for several weeks before:
> 
> Does any of the AI-detected issues seem concerning?
> 
> https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260810190621.894119-4-pablo@netfilter.org

Only commenting on those patches that I worked on or commented during
review:

Patch 6: [PATCH net 06/13] netfilter: nf_conntrack: defer invalid log until after unlock

Its fine.  This is for debugging.  We could restore the removed info if
anyone needs it, I even was about to suggest to original author to
simply remove the invalid logging but decided against it (since you can
log the packet to userspace via nfnetlink).  I prefer the simpler
version that doesn't snapshot data while under lock.

Patch 7: [PATCH net 07/13] netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state

Yes, one could have added this Fixes tag or Cc stable to the patch.
Don't think this warrants a respin by itself.

Patch 12: [PATCH net 12/13] netfilter: ipset: fix list type element drift bug

Even if the ordering is "wrong", the patch that
added it is ancient (even in RHEL7) so its long established behaviour.

ipset test suite also has test for this and those tests pass, so
changing kernel behaviour will need to adjust (old..) test cases as
well.

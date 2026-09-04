Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00663BCD0A;
	Fri,  4 Sep 2026 05:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501410; cv=none; b=EUw28tVyywqMj3QFCc+zvhst2waUdJTDzUWeiK6M6h0Xc/OzW51ptuhDZubzKLclbGHHEFARN9NgPve7knNl4+eYIvzroEyDIujrMeWx4WNA3QGONuOxih0O8wYWEbOc3m94j+SaCr1kzimKgOrXQaAmhUaeOix5vi+vm96hIYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501410; c=relaxed/simple;
	bh=jl/f8qzumCxc9YU8Drrzlu4LmKpr/CmDTCzrByQb1T8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZHYKkLi2kUTqvQuL9OA0IsN6W/hiCjuxYF8yIYX/X0G7Gl7Ohj3x37tdYrttut3gF45ErL3URgT3TYiIS9WEpl4Wr7664lbLOBLTWDDiuLdZkisckxY1PuxyXQbEbp+Ux/JLuZhWXo5Lqpx3MovyqfNNEuKkwV+SPJ29xE5Isg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A89C460405; Fri, 04 Sep 2026 07:56:46 +0200 (CEST)
Date: Fri, 4 Sep 2026 07:56:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net 09/12] netfilter: nfnetlink_queue: hold nfnl mutex in
 event notifier
Message-ID: <appdnj0GxYLk2Amr@strlen.de>
References: <20260903004149.1037028-10-pablo@netfilter.org>
 <20260904020149.3549947-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904020149.3549947-1-kuba@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: nfnetlink_queue: hold nfnl mutex in event notifier
> 
> The NETLINK_URELEASE notifier now takes the NFNL_SUBSYS_QUEUE mutex around
> the instance teardown loop, so it can no longer run concurrently with
> nfqnl_recv_config().  The comment in nfqnl_recv_config() is updated to
> explain that the notifier blocks on the subsystem mutex held by the caller.
> 
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> > index c727668b0c5b..a3bc00280051 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -1593,6 +1593,7 @@ nfqnl_rcv_nl_event(struct notifier_block *this,
> >  	if (event == NETLINK_URELEASE && n->protocol == NETLINK_NETFILTER) {
> >  		int i;
> >  
> > +		nfnl_lock(NFNL_SUBSYS_QUEUE);
> >  		/* destroy all instances for this portid */
> >  		spin_lock(&q->instances_lock);
> >  		for (i = 0; i < INSTANCE_BUCKETS; i++) {
> 
> [Severity: Medium]
> The new mutex gives mutual exclusion, but does it give any ordering
> against the socket unhash?  In netlink_release() the socket is removed
> from the hash table before the notifier chain is invoked:

I'm useless.  I don't even know what this is trying to tell me.

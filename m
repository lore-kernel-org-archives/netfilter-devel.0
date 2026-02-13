Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3E032D0CE;
	Fri, 13 Feb 2026 11:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770982263; cv=none; b=EEU2UZ5jDGernlNj2D9w1Z6FnzmVBMbXUxpR95AQKwMAOmwTGjoP5p1Htem96KD+3KdoOHzAZSM7EzFXw2e22cVJoIxl9ttODgztV/0hS1+nBMjYuW5uBGJLKqnN5zl6YPu9o4o4eGAJKyEdiqIdzsVcJaYnrX+aiC7GlPOfkwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770982263; c=relaxed/simple;
	bh=6WceRIQBnFnlOfoUKkxmUbp1JYMmyPzhKmOhdic/RMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C85EPQp4uvshhfwc3fveZ2Unsep1I4eNiU2PRk3dId6u/eFfFlw/kZBgpYmqWg7bcWQH/LqlZWvrRX42cPRRhV0R1IBEjL4cPWMLpV5BT+YeIoh9dZex7LqsUXcb7m5do1EekFnI9cmF/inVWQnbX+j6h5XMpY8rl8LPm5kvJUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3D08C608AD; Fri, 13 Feb 2026 12:30:59 +0100 (CET)
Date: Fri, 13 Feb 2026 12:30:58 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Shigeru Yoshida <syoshida@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	syzbot+5a66db916cdde0dbcc1c@syzkaller.appspotmail.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net] net: flow_offload: protect driver_block_list in
 flow_block_cb_setup_simple()
Message-ID: <aY8LcgPsoYYGEH5s@strlen.de>
References: <20260208110054.2525262-1-syoshida@redhat.com>
 <aYxw2CpxOKLh1wOz@strlen.de>
 <20260212183447.2d577f5b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212183447.2d577f5b@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 11 Feb 2026 13:06:48 +0100 Florian Westphal wrote:
> > Shigeru Yoshida <syoshida@redhat.com> wrote:
> > > syzbot reported a list_del corruption in flow_block_cb_setup_simple(). [0]
> > > 
> > > flow_block_cb_setup_simple() accesses the driver_block_list (e.g.,
> > > netdevsim's nsim_block_cb_list) without any synchronization. The
> > > nftables offload path calls into this function via ndo_setup_tc while
> > > holding the per-netns commit_mutex, but this mutex does not prevent
> > > concurrent access from tasks in different network namespaces that
> > > share the same driver_block_list, leading to list corruption:
> > > 
> > > - Task A (FLOW_BLOCK_BIND) calls list_add_tail() to insert a new
> > >   flow_block_cb into driver_block_list.
> > > 
> > > - Task B (FLOW_BLOCK_UNBIND) concurrently calls list_del() on another
> > >   flow_block_cb from the same list.  
> > 
> > Looking at the *upper layer*, I don't think it expected drivers to use
> > a single global list for this bit something that is scoped to the
> > net_device.
> 
> Maybe subjective but the fix seems a little off to me.
> Isn't flow_block_cb_setup_simple() just a "simple" implementation 
> for reuse in drivers locking in there doesn't really guarantee much?

Not sure what you mean.  I see the same pattern as netdevsim in all
drivers using this API.  Random example:

static LIST_HEAD(ice_repr_block_cb_list);

[..]
   return flow_block_cb_setup_simple((struct flow_block_offload *)
                                     type_data,
                                     &ice_repr_block_cb_list,
                                     ice_repr_setup_tc_block_cb,
                                     np, np, true);

This is safe only as long as all ice_repr_setup_tc() calls happen
in same net namespace.  I don't think we can rely on this.

> If we think netdevsim is doing something odd, let's make it work
> like real drivers.

I fear fixing netdevsim to not use single list will resolve the
syzbot report but AFAICS this pattern is in many drivers.

> TBH I thought block setup was always under rtnl_lock.

netdevices.rst says:
"``TC_SETUP_BLOCK`` and ``TC_SETUP_FT`` are running under NFT locks
        (i.e. no ``rtnl_lock`` and no device instance lock)."

I don't think it will be possible to change it.

nf_tables_netdev_event is called with rtnl_lock and it can then
take the pernet nf_tables transaction mutex.

Maybe it would be possible to rework flow_block_cb_setup_simple()
to not depend on an external list_head argument, but its not easy to
test such a patch nor do I think its going to be -net material let
alone something that -stable likes to digest.

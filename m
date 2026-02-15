Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751CFE571;
	Sun, 15 Feb 2026 13:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771160808; cv=none; b=r0m5Melt411yavl1nQqueSmfv8P0RcAqr+v4bDsOW3oKMxhjXH1YmQ/Q9c/xcv/+Ay6gpBE9b8+X3wXiagd+7veQcT0JVZvFIUENxru5Z4tKz5Nl1UbadNt0Yne6jBrAyn/wgSNw2Knve7U96sHZcZhGYujh0SboX5od2Nthyco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771160808; c=relaxed/simple;
	bh=Ez17805DvVJAxopmP2LRlw7R4OGZ7ZhkD2NeUWMnc+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G3+9iteC9/4mzjxOlXcobjAK2quU2NzP1HsD9WiOtME1xChDrGdrG3tHdb9Us9n1TN6YTtoyQQ1isvPK7pogFxR3WhLQ7+7JdD0KNhXuIM510OkK1GPo/eRQclZ0OJNgXXGz5l260xkXUoIevyJ77HxIS5LvSWULs9esCB+A3mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D45EB60218; Sun, 15 Feb 2026 14:06:43 +0100 (CET)
Date: Sun, 15 Feb 2026 14:06:42 +0100
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
Message-ID: <aZHE4r18hkxdITD-@strlen.de>
References: <20260208110054.2525262-1-syoshida@redhat.com>
 <aYxw2CpxOKLh1wOz@strlen.de>
 <20260212183447.2d577f5b@kernel.org>
 <aY8LcgPsoYYGEH5s@strlen.de>
 <20260213081749.3b3ede9c@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213081749.3b3ede9c@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 13 Feb 2026 12:30:58 +0100 Florian Westphal wrote:
> > > > Looking at the *upper layer*, I don't think it expected drivers to use
> > > > a single global list for this bit something that is scoped to the
> > > > net_device.  
> > > 
> > > Maybe subjective but the fix seems a little off to me.
> > > Isn't flow_block_cb_setup_simple() just a "simple" implementation 
> > > for reuse in drivers locking in there doesn't really guarantee much?  
> > 
> > Not sure what you mean.  I see the same pattern as netdevsim in all
> > drivers using this API. 
> 
> Grep for flow_block_cb_add(). Not all drivers use

static int
mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
{
        struct mtk_mac *mac = netdev_priv(dev);
        struct mtk_eth *eth = mac->hw;
        static LIST_HEAD(block_cb_list);
	~~~~~~
I have a question.

[..]
        f->driver_block_list = &block_cb_list;

Now I have many questions!

How is this supposed to work?
How is ownership handled, what locks protect, or what locks are supposed
to protect this?

> the flow_block_cb_setup_simple() helper, it's just a convenience helper,
> not a mandatory part of the flow. We should probably add a helper for
> add like the one added for  flow_block_cb_remove_driver() instead of
> taking the lock directly in flow_block_cb_setup_simple()?

No idea, I don't understand how any of this is supposed to work.

I will try to play with this next week but I'm not sure I will send
patches.  AFAICS there are not even netdevsim based tests for this
feature anywhere.

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] ipset fixes
Date: Mon, 24 Sep 2012 00:26:01 +0200
Message-ID: <20120923222601.GA5624@1984>
References: <1348259901-16369-1-git-send-email-kadlec@blackhole.kfki.hu>
 <20120922103433.GA26572@1984>
 <alpine.DEB.2.00.1209221705440.18018@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53541 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab2IWW0F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Sep 2012 18:26:05 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209221705440.18018@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 22, 2012 at 09:22:08PM +0200, Jozsef Kadlecsik wrote:
[...]
> > Please, could you develop how critical are these above? We're fairly
> > late in the release cycle, I'd prefer if we pass only really critical
> > fixes.
> 
> > >   netfilter: ipset: Check and reject crazy /0 input parameters
> 
> This one is easy to trigger: bitmap:ip sets are allowed to be created from 
> range 0/0, but with /16 subnets as elements:
> 
> ipset new foo bitmap:ip range 0/0 netmask 16
> 
> However if "netmask 16" is left out accidentally, the kernel does not 
> reject it but creates a broken set and the system will crash when the 
> first element is added.

I see, this crash seems to be triggered in really rare situation.

> If we are quite late in the release cycle, maybe it can wait and be added 
> to nf-next only.

We can still push fixes, but at this stage we should focus on fixes
that really happen in normal cases / typical usage IMO.

> > >   netfilter: ipset: Fix cidr book keeping for hash:*net* types
> 
> You asked to check how critical the bug is, and it was just the perfect 
> question :-). I have re-checked and I was mistaken. The new case (zero 
> cidr size), which was not handled by the old code, somehow misled me. So 
> the patch description should be rewritten - I'm going to send a new batch 
> of the patches against nf-next tomorrow. Thanks!

Will check tomorrow, thanks again!

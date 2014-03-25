From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] src: check if the set name is too long
Date: Tue, 25 Mar 2014 09:47:09 +0100
Message-ID: <20140325084709.GA4046@localhost>
References: <1395423541-5098-1-git-send-email-giuseppelng@gmail.com>
 <20140324145738.GB32472@localhost>
 <53313234.6050602@linux.intel.com>
 <20140325084131.GA3857@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34544 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbaCYIrO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:47:14 -0400
Content-Disposition: inline
In-Reply-To: <20140325084131.GA3857@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 25, 2014 at 09:41:31AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 25, 2014 at 09:37:24AM +0200, Tomasz Bursztyka wrote:
> > Hi Pablo,
> > 
> > >I sent you a patch, I think it's better if we fix this from
> > >kernel-space.
> > 
> > I think it's also good if we check the length when parsing, as Giuseppe did.
> > Then it reduce the overhead: the error is detected way before we
> > process anything through netlink.
> 
> This is an error case, I don't think we should focus on reducing
> overhead in those scenarios.

Just to extend this. I prefer this limit is also set in kernelspace so
in case we ever remove it, we won't have to wait until a new nft
userspace tool version is released.

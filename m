From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: Add SKPID and SKSID meta keys
Date: Thu, 19 Jun 2014 12:19:59 +0200
Message-ID: <20140619101959.GA4431@localhost>
References: <1401977956-15500-1-git-send-email-yshuiv7@gmail.com>
 <1401977956-15500-3-git-send-email-yshuiv7@gmail.com>
 <20140610110115.GA9240@localhost>
 <53A2B897.8080501@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yuxuan Shui <yshuiv7@gmail.com>, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38484 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbaFSKUF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:20:05 -0400
Content-Disposition: inline
In-Reply-To: <53A2B897.8080501@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 19, 2014 at 01:16:55PM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >>Add SKPID and SKSID meta keys so we can implement PID and SID matching
> >>>rules in userspace nft tool.
> >I would like to have some use case in the patch description that
> >justifies how this can be useful to everyone.
> >
> >I don't want add more selectors just because we can make it, they
> >should allow to perform some useful action.
> 
> To mimic xtables libxt_owner extension, would that be sufficient?

That is already achieved through skuid and skgid.

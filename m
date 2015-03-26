From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Thu, 26 Mar 2015 12:26:12 +0100
Message-ID: <20150326112552.GA3881@salvia>
References: <2984705.dCFJb2qqrb@tuxracer>
 <14722035.jXe0WcxyPC@tuxracer>
 <20150325160536.GA4360@salvia>
 <7893986.4pVhdOQPzb@tuxracer>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52841 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbbCZLWR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 07:22:17 -0400
Content-Disposition: inline
In-Reply-To: <7893986.4pVhdOQPzb@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 25, 2015 at 06:11:26PM +0200, Sergey Popovich wrote:
> > On Wed, Mar 25, 2015 at 04:54:54PM +0200, Sergey Popovich wrote:
> 
> > Could please send small batch (not more than 10 patches in one go,
> > please) to the mailing list so everyone can help in reviewing this?
> 
> Not a problem.
> 
> My series of patches for nf-next, while Jozsef would like to receive
> patches against ipset git tree and rebase may take a while.
> 
> Main problem with rebase is that my series implementing RCU, but
> this implementation differs from one found in the current ipset git
> tree.
> 
> This causes excessive number of conflicts, requiring lot of porting
> to ipset git tree.
> 
> As option I could send only bugfixes to the current nf-next, of course
> if Jozsef acknowledges them.

Jozsef wants that you route the patches through the ipset tree, so
please use that tree as reference.

Sending bugfixes in first place make sense to me, Cc'ing
netfilter-devel as inline patches (eg. git-send-mail) so everyone here
can help reviewing them.

Thanks.

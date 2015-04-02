From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/5] netfilter: nf_tables: set timeout support
Date: Thu, 2 Apr 2015 10:52:00 +0200
Message-ID: <20150402085200.GA18386@salvia>
References: <1427373580-19310-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43945 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbbDBIr6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2015 04:47:58 -0400
Content-Disposition: inline
In-Reply-To: <1427373580-19310-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 26, 2015 at 12:39:35PM +0000, Patrick McHardy wrote:
> These patches add support for set timeouts. Sets can have a default
> timeout value that can be overriden by element specific timeouts.
> 
> Removal of expired elements will usually be performed by a garbage
> collector for two reasons: avoiding an excessive number of timers
> and because data deinit has to happen in process context.
> 
> The first two patches add the required netlink attributes, parsing,
> dump etc. A set of GC helper functions for batched RCU element
> destruction is added in patch three, some synchronization helpers
> to avoid races between async GC and netlink insertion and removal
> of elements are added in patch four.
> 
> Following patches will use this infrastrucure to support set updates
> from the packet classification path for dynamic sets and dynamic
> flow state maintenance.
> 
> Please apply, thanks!

Series applied, thanks Patrick.

BTW, what's your plan with the rbtree and timeouts?

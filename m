From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] parser: allow to reorder chain options
Date: Tue, 17 Mar 2015 13:29:32 +0100
Message-ID: <20150317122932.GA16527@salvia>
References: <1426594385-24063-1-git-send-email-pablo@netfilter.org>
 <1426594385-24063-2-git-send-email-pablo@netfilter.org>
 <20150317121514.GM21401@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41583 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbbCQMZo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 08:25:44 -0400
Content-Disposition: inline
In-Reply-To: <20150317121514.GM21401@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 17, 2015 at 12:15:14PM +0000, Patrick McHardy wrote:
> On 17.03, Pablo Neira Ayuso wrote:
> > This allows all possible combinations to work:
> > 
> >  nft add chain filter input { type filter hook input priority 0 \; }
> >  nft add chain filter input { priority 0 type filter hook input \; }
> 
> 
> I don't object to being able to change the order of type and hook,
> but priority logically belongs to the hook keyword, why change this?

When displaying the chain configuration, this shows in order.

But we're humans and I don't see a good reason why we should force
humans to order things in some specific way.

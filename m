From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/7] netfilter: nf_tables: remove hook definitions from
 struct nft_af_info
Date: Thu, 10 Jan 2013 17:19:44 +0100
Message-ID: <20130110161944.GA4296@1984>
References: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
 <1357831721-10182-3-git-send-email-pablo@netfilter.org>
 <20130110160409.GB2178@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tomasz.bursztyka@linux.intel.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46038 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab3AJQTv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:19:51 -0500
Content-Disposition: inline
In-Reply-To: <20130110160409.GB2178@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 10, 2013 at 05:04:18PM +0100, Patrick McHardy wrote:
> On Thu, Jan 10, 2013 at 04:28:37PM +0100, pablo@netfilter.org wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > They are now included in the filter chain definition.
> > 
> 
> Ok should have looked at the entire series before responding.
> I do still need the table hooks for the multi family tables,
> so I'd suggest to keep the current state until I've come up
> with a scheme that accomodates all our needs.

OK, I'll rework this patch to fix the output path of filter. I will
keep the table hooks so you can still use it.

Thanks Patrick.

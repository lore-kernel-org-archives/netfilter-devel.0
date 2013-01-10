From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/7] netfilter: nf_tables: move specific layer 3 compat
 code to nf_tables_ipv[4|6]
Date: Thu, 10 Jan 2013 17:20:31 +0100
Message-ID: <20130110162031.GB4296@1984>
References: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
 <1357831721-10182-4-git-send-email-pablo@netfilter.org>
 <20130110160910.GC2178@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tomasz.bursztyka@linux.intel.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46170 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab3AJQUh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:20:37 -0500
Content-Disposition: inline
In-Reply-To: <20130110160910.GC2178@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 10, 2013 at 05:09:13PM +0100, Patrick McHardy wrote:
> On Thu, Jan 10, 2013 at 04:28:38PM +0100, pablo@netfilter.org wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > This patch moves the struct xt_action_param to struct nft_pktinfo
> > and that structure is filled at the beginning of the every chain.
> > 
> > The specific code to handle IPv4 and IPv6 now resides in
> > nf_tables_ipv[4|6].
> > 
> > +extern unsigned int nft_do_chain_pktinfo(struct nft_pktinfo *pkt,
> > +					 const struct nf_hook_ops *ops);
> 
> Passing the pktinfo is something I also need to fix the transport layer
> parsing. I don't like that function name at all though, just keep
> nft_do_chain()?

Will change it back to use nft_do_chain.

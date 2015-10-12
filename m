From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: ipt_rpfilter: remove the nh_scope test in
 rpfilter_lookup_reverse
Date: Mon, 12 Oct 2015 17:15:03 +0200
Message-ID: <20151012151503.GA11015@salvia>
References: <e4382c194620c20c80991d4a32618266da4c71df.1444136587.git.lucien.xin@gmail.com>
 <20151006131022.GA25207@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xin Long <lucien.xin@gmail.com>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51744 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbbJLPPn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Oct 2015 11:15:43 -0400
Content-Disposition: inline
In-Reply-To: <20151006131022.GA25207@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 06, 2015 at 03:10:22PM +0200, Florian Westphal wrote:
> Xin Long <lucien.xin@gmail.com> wrote:
> > --accept-local  option works for res.type == RTN_LOCAL, which should be from
> > the local table, but there, the fib_info's nh->nh_scope = RT_SCOPE_NOWHERE
> > ( > RT_SCOPE_HOST). in fib_create_info().
> > 
> > 	if (cfg->fc_scope == RT_SCOPE_HOST) {
>  
> > but in our rpfilter_lookup_reverse():
> > 
> > 	if (dev_match || flags & XT_RPFILTER_LOOSE)
> > 		return FIB_RES_NH(res).nh_scope <= RT_SCOPE_HOST;
> > 
> > if nh->nh_scope > RT_SCOPE_HOST, it will fail. --accept-local option will never
> > be passed.
> > 
> > it seems the test is bogus and can be removed to fix this issue.
> 
> Yes, you might want to consider submitting a followup patch that cleans
> up the ipv4 route handling against net-next tree.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Applied to nf, thanks.

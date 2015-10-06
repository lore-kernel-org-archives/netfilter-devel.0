From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net] netfilter: ipt_rpfilter: remove the nh_scope test in
 rpfilter_lookup_reverse
Date: Tue, 6 Oct 2015 15:10:22 +0200
Message-ID: <20151006131022.GA25207@breakpoint.cc>
References: <e4382c194620c20c80991d4a32618266da4c71df.1444136587.git.lucien.xin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Xin Long <lucien.xin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58180 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbbJFNKY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Oct 2015 09:10:24 -0400
Content-Disposition: inline
In-Reply-To: <e4382c194620c20c80991d4a32618266da4c71df.1444136587.git.lucien.xin@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Xin Long <lucien.xin@gmail.com> wrote:
> --accept-local  option works for res.type == RTN_LOCAL, which should be from
> the local table, but there, the fib_info's nh->nh_scope = RT_SCOPE_NOWHERE
> ( > RT_SCOPE_HOST). in fib_create_info().
> 
> 	if (cfg->fc_scope == RT_SCOPE_HOST) {
 
> but in our rpfilter_lookup_reverse():
> 
> 	if (dev_match || flags & XT_RPFILTER_LOOSE)
> 		return FIB_RES_NH(res).nh_scope <= RT_SCOPE_HOST;
> 
> if nh->nh_scope > RT_SCOPE_HOST, it will fail. --accept-local option will never
> be passed.
> 
> it seems the test is bogus and can be removed to fix this issue.

Yes, you might want to consider submitting a followup patch that cleans
up the ipv4 route handling against net-next tree.

Acked-by: Florian Westphal <fw@strlen.de>

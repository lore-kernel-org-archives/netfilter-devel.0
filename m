From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 0/6] ruleset tracing
Date: Mon, 25 Apr 2016 11:28:01 +0100
Message-ID: <20160425102801.GA29560@macbook.localdomain>
References: <1461533440-10605-1-git-send-email-kaber@trash.net>
 <20160424222213.GA28797@breakpoint.cc>
 <20160424225718.GA14306@macbook.localdomain>
 <20160425002357.GA18237@macbook.localdomain>
 <20160425094929.GB28797@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54957 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbcDYK2M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 06:28:12 -0400
Content-Disposition: inline
In-Reply-To: <20160425094929.GB28797@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.04, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > On 24.04, Patrick McHardy wrote:
> > > On 25.04, Florian Westphal wrote:
> > > > Patrick McHardy <kaber@trash.net> wrote:
> > > > > The following patches contain the latest version of the ruleset tracing
> > > > > functionality.
> > > > > I consider this patchset complete. Testing and comments welcome.
> > > > 
> > > > Seems it doesn't work with inet table, I get segfault in expr_print
> > > > (EXPR_VALUE expr with expr->dtype == NULL).
> > > > 
> > > > Callchain that produces this expression is:
> > > > 
> > > > trace_gen_stmts -> payload_expr_expand -> payload_expr_alloc
> > > > 
> > > > desc argument to payload_expr_alloc is the inet one, which
> > > > has no template for types != 0, so tmpl->dtype that gets passed
> > > > to expr_alloc is NULL.
> > > 
> > > Thanks, I'll look into that.
> > > 
> > > > Works fine without inet table. Only "problem" I found is that
> > > > nft displays the ether addr reversed vs. what 'ip link' shows,
> > > > i.e. if ip link says 1:2:3:4:5:6 nft shows 6:5:4:3:2:1.
> > > > 
> > > > I'll do more tests tomorrow and will double check that its not
> > > > a kernel bug.
> > > 
> > > That's just a missing byte order conversion, I've fixed it locally.
> > 
> > This patch should fix both issues.
> 
> It does, thanks!

Thanks, I've pushed out the patches.

> Seems to work fine now, only missing enhancement would be to add new
> rules to the cache; currently when nft monitor is running it
> will print out a added rules, but they are not printed out in new trace
> events (restarting the nft monitor process works fine).

Yes, that would be good to have. Looks like a bit more effort though, we
also need to keep all other objects in sync.

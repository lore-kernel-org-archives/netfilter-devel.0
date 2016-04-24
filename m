From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 0/6] ruleset tracing
Date: Mon, 25 Apr 2016 00:22:13 +0200
Message-ID: <20160424222213.GA28797@breakpoint.cc>
References: <1461533440-10605-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59304 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036AbcDXWWR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 18:22:17 -0400
Content-Disposition: inline
In-Reply-To: <1461533440-10605-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> The following patches contain the latest version of the ruleset tracing
> functionality.
> I consider this patchset complete. Testing and comments welcome.

Seems it doesn't work with inet table, I get segfault in expr_print
(EXPR_VALUE expr with expr->dtype == NULL).

Callchain that produces this expression is:

trace_gen_stmts -> payload_expr_expand -> payload_expr_alloc

desc argument to payload_expr_alloc is the inet one, which
has no template for types != 0, so tmpl->dtype that gets passed
to expr_alloc is NULL.

Works fine without inet table. Only "problem" I found is that
nft displays the ether addr reversed vs. what 'ip link' shows,
i.e. if ip link says 1:2:3:4:5:6 nft shows 6:5:4:3:2:1.

I'll do more tests tomorrow and will double check that its not
a kernel bug.

Thanks for working on this!

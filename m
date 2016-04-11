From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: ebtables: Fix extension lookup with identical
 name
Date: Tue, 12 Apr 2016 01:36:34 +0200
Message-ID: <20160411233634.GA15916@breakpoint.cc>
References: <1460417474-8899-1-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35819 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755583AbcDKXgk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Apr 2016 19:36:40 -0400
Content-Disposition: inline
In-Reply-To: <1460417474-8899-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter <phil@nwl.cc> wrote:
> If a requested extension exists as module and is not loaded,
> ebt_check_match() might accidentally use an NFPROTO_UNSPEC one with same
> name and fail.
> 
> Reproduced with limit match: Given xt_limit and ebt_limit both built as
> module, the following would fail:
> 
>   modprobe xt_limit
>   ebtables -I INPUT --limit 1/s -j ACCEPT
> 
> The fix is to make ebt_check_match() distrust a found NFPROTO_UNSPEC
> extension and retry after requesting an appropriate module.
> 
> Cc: Florian Westphal <fw@strlen.de>

Acked-by: Florian Westphal <fw@strlen.de>

Thanks for handling this.

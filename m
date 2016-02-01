From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] netlink_delinearize: prune implicit binop before
 payload_match_postprocess()
Date: Mon, 1 Feb 2016 14:50:07 +0100
Message-ID: <20160201135007.GA15817@breakpoint.cc>
References: <1454333565-2108-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33897 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932244AbcBANuJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 08:50:09 -0500
Content-Disposition: inline
In-Reply-To: <1454333565-2108-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> payload_match_postprocess() expects a relational with payload of his lhs
> and value on the rhs.
> 
> Moreover, payload_match_expand() releases the previous expression so
> valgrind reports an use-after-free when pruning the implicit binop.

Right, my bad.  Please push this fix, thanks!

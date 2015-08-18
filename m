From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/2] tests: redirect: fix payload display
Date: Tue, 18 Aug 2015 10:43:38 +0200
Message-ID: <20150818084338.GE31357@breakpoint.cc>
References: <1439874496-4852-1-git-send-email-pablo@netfilter.org>
 <1439874496-4852-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37529 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950AbbHRInk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 04:43:40 -0400
Content-Disposition: inline
In-Reply-To: <1439874496-4852-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This has to be related to libnftnl's 0edeb667a2cf ("expr: redir: fix snprintf
> to return the number of bytes printed").
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Florian: After this patch, I pass all payload tests here that we have :).

Great.  Please push this :-)

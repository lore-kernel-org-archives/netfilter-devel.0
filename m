From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] parser_bison: initializer_expr must use rhs_expr
Date: Tue, 12 Jan 2016 14:05:13 +0100
Message-ID: <20160112130513.GA1798@breakpoint.cc>
References: <1452602913-18352-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com,
	fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57175 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbcALNFQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 08:05:16 -0500
Content-Disposition: inline
In-Reply-To: <1452602913-18352-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Use rhs_expr and list_rhs_expr as possible occurrences of
> initializer_expr since we may only find constant expressions on the
> right hand side of the assignment.
> 
> Fixes: 2a5d44d8b3c (parser: get rid of multiton_expr from lhs relational expression)
> Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Works for me, thus:
Tested-by: Florian Westphal <fw@strlen.de>


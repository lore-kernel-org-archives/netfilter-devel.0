From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/3 nft] tests/py: don't test log statement from protocol
 match
Date: Wed, 13 Jan 2016 11:13:36 +0100
Message-ID: <20160113101336.GA27674@breakpoint.cc>
References: <1452638438-19193-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60069 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490AbcAMKNi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 05:13:38 -0500
Content-Disposition: inline
In-Reply-To: <1452638438-19193-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[ zap log rules from family matches ]

I assume thats because you deem tests/py/any/log.t
sufficient?

When you push it can you add one-liner summary in this direction?

Thanks!

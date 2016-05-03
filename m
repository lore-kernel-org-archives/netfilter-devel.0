From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC nf-next] netfilter: ip_tables: get rid of old
 debugging instrumentation
Date: Tue, 3 May 2016 16:31:26 +0200
Message-ID: <20160503143126.GE2395@breakpoint.cc>
References: <1462278279-11019-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49699 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932867AbcECObe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 10:31:34 -0400
Content-Disposition: inline
In-Reply-To: <1462278279-11019-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The dprintf() and duprintf() functions are enabled at compile time,
> these days we have better runtime debugging through pr_debug() and
> static keys.
> 
> On top of this, this debugging is so old that I don't expect anyone
> using this anymore, so let's get rid of this.

Acked-by: Florian Westphal <fw@strlen.de>

> Is anyone here using this stuff these days? If not, I will be happy to
> get rid of these old stuff.

I'm for removing it.

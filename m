From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: nfqueue: don't use prev pointer
Date: Tue, 13 Oct 2015 12:04:24 +0200
Message-ID: <20151013100424.GA1986@salvia>
References: <1444389037-17285-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38766 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbbJMJ5W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Oct 2015 05:57:22 -0400
Content-Disposition: inline
In-Reply-To: <1444389037-17285-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 09, 2015 at 01:10:37PM +0200, Florian Westphal wrote:
> Usage of -prev seems buggy.  While packet was out our hook cannot be
> removed but we have no way to know if the previous one is still valid.
> 
> So better not use ->prev at all.  Since NF_REPEAT just asks to invoke
> same hook function again, just do so, and continue with nf_interate
> if we get an ACCEPT verdict.
> 
> A side effect of this change is that if nf_reinject(NF_REPEAT) causes
> another REPEAT we will now drop the skb instead of a kernel loop.
> 
> However, NF_REPEAT loops would be a bug so this should not happen anyway.

Good catch. Applied, thanks Florian.

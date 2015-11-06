From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/2] src: allow filtering on L2 header in inet family
Date: Fri, 6 Nov 2015 14:31:41 +0100
Message-ID: <20151106133141.GA6142@salvia>
References: <1443237243-4571-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47009 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883AbbKFNYW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 08:24:22 -0500
Content-Disposition: inline
In-Reply-To: <1443237243-4571-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 26, 2015 at 05:14:02AM +0200, Florian Westphal wrote:
> Error: conflicting protocols specified: inet vs. ether
> tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4
>                                    ^^^^^^^^^^^
> 
> This allows the implicit inet proto dependency to get replaced
> by an ethernet one.
> 
> This is possible since by the time we detect the conflict the
> meta dependency for the network protocol has already been added.
> 
> So we only need to add another dependency on the Linklayer frame type.
> 
> Closes: http://bugzilla.netfilter.org/show_bug.cgi?id=981
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

P.S: You push this Florian, thanks.

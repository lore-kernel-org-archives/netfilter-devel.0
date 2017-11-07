From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nf_defrag_ipv4: Add sysctl to disable
 per interface
Date: Tue, 7 Nov 2017 11:30:13 +0100
Message-ID: <20171107103013.GA5512@breakpoint.cc>
References: <1509762520-17873-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, steffen.klassert@secunet.com,
        pablo@netfilter.org
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50042 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750917AbdKGKat (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2017 05:30:49 -0500
Content-Disposition: inline
In-Reply-To: <1509762520-17873-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org> wrote:
> Add a sysctl nf_ipv4_defrag_skip to skip defragmentation per
> interface. This is set 0 to preserve existing behavior (always
> defrag per interface).
> 
> This is useful for pure ipv4 forwarding scenarios (without NAT)
> in conjunction with xfrm. It appears that network stack defrags
> the packets and then forwards them to xfrm which then encrypts
> and then later fragments them on a different boundary compared
> to the source.

This breaks connection tracking for packets coming in via such
interfaces.

Nowadays we only enable defrag in a network namespace if the ip/nftables
ruleset requires it, so this setting would be counter-productive.

> An example of this usage is for fixing wifi calling on networks
> where certain routers are configured to drop fragments explicitly.

Yay...  does that happen for all frags or is this related to df bit
somehow?


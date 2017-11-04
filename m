From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH nf-next] netfilter: nf_defrag_ipv4: Add sysctl to disable
 per interface
Date: Sat, 4 Nov 2017 10:07:12 +0100
Message-ID: <20171104090712.GB23855@secunet.com>
References: <1509762520-17873-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <netfilter-devel@vger.kernel.org>, <pablo@netfilter.org>
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:59934 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756478AbdKDJHP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Nov 2017 05:07:15 -0400
Content-Disposition: inline
In-Reply-To: <1509762520-17873-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 03, 2017 at 08:28:40PM -0600, Subash Abhinov Kasiviswanathan wrote:
> Add a sysctl nf_ipv4_defrag_skip to skip defragmentation per
> interface. This is set 0 to preserve existing behavior (always
> defrag per interface).
> 
> This is useful for pure ipv4 forwarding scenarios (without NAT)
> in conjunction with xfrm. It appears that network stack defrags
> the packets and then forwards them to xfrm which then encrypts
> and then later fragments them on a different boundary compared
> to the source.

The reassembling happens because of conntrack, right?
In this case, I'd recommend to do it like IPv6 does.
I.e. reassembling the fragments, inspect the reassembled
packet and if OK, send the chain of fragments instead of
the reassembled packet back to the stack.


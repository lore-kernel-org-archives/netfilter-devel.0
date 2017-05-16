From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 03/10] src: treat ip6 nexthdr as a protocol
Date: Tue, 16 May 2017 12:28:18 +0200
Message-ID: <20170516102818.GB19858@salvia>
References: <20170509155122.26356-1-fw@strlen.de>
 <20170509155122.26356-4-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:33682 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbdEPK2X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 06:28:23 -0400
Content-Disposition: inline
In-Reply-To: <20170509155122.26356-4-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 09, 2017 at 05:51:15PM +0200, Florian Westphal wrote:
> ip6 nexthdr tcp tcp dport 22
> will now inject a (useless) meta l4 dependency as ip6 nexthdr is no
> longer flagged as EXPR_F_PROTOCOL.
> 
> Avoid this if user really specified a test for ip6hdr->nexthdr.

But ipv6_find_hdr() is actually fetching the layer 4 protocol number
from the fragment.

Shouldn't we do the same with ip4h->protocol to keep things
consistent? I mean, no meta l4 dependency but just real check for this
header field if specified.

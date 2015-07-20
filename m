From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] fix wrong headername in ipv6header for protocols
Date: Mon, 20 Jul 2015 17:42:12 +0200
Message-ID: <20150720154212.GA19471@salvia>
References: <1437054859-15824-1-git-send-email-andi@geekosphere.org>
 <20150720072126.GA4136@salvia>
 <20150720142934.GA21348@kvmbude>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48674 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbbGTPgb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 11:36:31 -0400
Content-Disposition: inline
In-Reply-To: <20150720142934.GA21348@kvmbude>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 20, 2015 at 04:29:34PM +0200, Andreas Herz wrote:
> On 20/07/15 at 09:21, Pablo Neira Ayuso wrote:
[...]
> > I can read this from the code:
> > 
> > static const struct pprot chain_protos[] = {
> >         { "protocol", IPPROTO_RAW },
> > ...
> >         { "prot", IPPROTO_RAW },
> > 
> > Could you clarify what you're seeing there? Thanks.
> 
> It's exactly the issue :) as you can see "protocol" and "prot" (without
> _o_ at the end) but the manpage and the help from iptables say
> "protocol" and "proto" (with _o_ at the end).

I see, thanks for explaining. Applied.


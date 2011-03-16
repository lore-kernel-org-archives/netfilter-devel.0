From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 2/2] netfilter: xt_addrtype: ipv6 support
Date: Wed, 16 Mar 2011 15:19:48 +0100
Message-ID: <20110316141948.GA13371@Chamillionaire.breakpoint.cc>
References: <1300214971-20345-1-git-send-email-fw@strlen.de>
 <1300214971-20345-2-git-send-email-fw@strlen.de>
 <4D80C12E.4010107@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43986 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929Ab1CPOTt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:19:49 -0400
Content-Disposition: inline
In-Reply-To: <4D80C12E.4010107@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > +		rt = rt6_lookup(net, addr, NULL, ifindex, !!dev);
> 
> Florian, I just noticed that this will pull in the IPv6 module just
> by loading the xt_addrtype module.

Yes...

> Can we convert this to use
> nf_ip6_afinfo->route() instead?

I agree that it would be much nicer, thanks for the
suggestion.

I'll look into this on Saturday.

Thanks,
Florian

From: Florian Westphal <fw@strlen.de>
Subject: Re: Allow DNPT target from raw table?
Date: Mon, 6 May 2013 21:30:52 +0200
Message-ID: <20130506193052.GE19796@breakpoint.cc>
References: <2531686.RPhsabGAWo@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47259 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755232Ab3EFTaz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 May 2013 15:30:55 -0400
Content-Disposition: inline
In-Reply-To: <2531686.RPhsabGAWo@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> wrote:
> Currently, the DNPT target is restricted to the mangle table; this means that 
> it is effectively impossible to utilise NPT in tandem with conntrack since it's 
> impossible to rewrite the destination prefix prior to conntrack taking a look 
> at the skb.

Could you please elaborate?
Shouldn't conntrack rather be disabled for such flows?

Where do you put the SNPT rules?

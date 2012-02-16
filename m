From: Florian Westphal <fw@strlen.de>
Subject: Re: Question about nfnl_handle_packet/nfnl_process error handling
Date: Thu, 16 Feb 2012 22:41:27 +0100
Message-ID: <20120216214127.GD11798@Chamillionaire.breakpoint.cc>
References: <20120216141546.GC11798@Chamillionaire.breakpoint.cc>
 <20120216174142.GA5591@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45705 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244Ab2BPVl2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:41:28 -0500
Content-Disposition: inline
In-Reply-To: <20120216174142.GA5591@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > When an error occurs, for example because a verdict for a bogus packet id was
> > sent, nfq_handle_packet/nfnl_handle_packet returns -1 with errno == 0.
> > 
> > Using nfnl_process() instead of nfq_handle_packet() sets errno to the expected
> > ENOENT.
> > 
> > Does anyone know if nfq_handle_packet() "errno 0" behaviour is intentional?
> 
> The initial libnfnetlink API did not set errno, nfnl_handle_packet is
> part of that old API.
> 
> nfnl_process was added later to try to resolve some limitations by
> 2006 IIRC.

Ah.  That explains it, thanks.

> > Should I just ignore nfq_handle_packet() return value?
> > What about deprecating nfnl_handle_packet() and using nfnl_process()
> > instead?
> 
> I have ported libnetfilter_queue to libmnl, I need some spare time to
> push the new API to the repository. I'll be happy if you spend some
> time looking at it to find some possible issues, the idea is that the
> new API resolves the existing API limitations.

Nice work. I'd be happy to test and review it.

Thanks, Florian

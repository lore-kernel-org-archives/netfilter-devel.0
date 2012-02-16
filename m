From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Question about nfnl_handle_packet/nfnl_process error handling
Date: Thu, 16 Feb 2012 18:41:42 +0100
Message-ID: <20120216174142.GA5591@1984>
References: <20120216141546.GC11798@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47422 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab2BPRly (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Feb 2012 12:41:54 -0500
Content-Disposition: inline
In-Reply-To: <20120216141546.GC11798@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, Feb 16, 2012 at 03:15:46PM +0100, Florian Westphal wrote:
> libnetfilter_queue has:
> 
> int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
> {
>    return nfnl_handle_packet(h->nfnlh, buf, len);
> }
> 
> When an error occurs, for example because a verdict for a bogus packet id was
> sent, nfq_handle_packet/nfnl_handle_packet returns -1 with errno == 0.
> 
> Using nfnl_process() instead of nfq_handle_packet() sets errno to the expected
> ENOENT.
> 
> Does anyone know if nfq_handle_packet() "errno 0" behaviour is intentional?

The initial libnfnetlink API did not set errno, nfnl_handle_packet is
part of that old API.

nfnl_process was added later to try to resolve some limitations by
2006 IIRC.

libmnl provide a neat new API. We have to move to it.

> Should I just ignore nfq_handle_packet() return value?
> What about deprecating nfnl_handle_packet() and using nfnl_process()
> instead?

I have ported libnetfilter_queue to libmnl, I need some spare time to
push the new API to the repository. I'll be happy if you spend some
time looking at it to find some possible issues, the idea is that the
new API resolves the existing API limitations.

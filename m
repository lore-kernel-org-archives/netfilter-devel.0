From: Florian Westphal <fw@strlen.de>
Subject: Question about nfnl_handle_packet/nfnl_process error handling
Date: Thu, 16 Feb 2012 15:15:46 +0100
Message-ID: <20120216141546.GC11798@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46635 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133Ab2BPOPs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:15:48 -0500
Received: id: fw by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1Ry27e-0000Ys-Vp
	for netfilter-devel@vger.kernel.org; Thu, 16 Feb 2012 15:15:47 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libnetfilter_queue has:

int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
{
   return nfnl_handle_packet(h->nfnlh, buf, len);
}

When an error occurs, for example because a verdict for a bogus packet id was
sent, nfq_handle_packet/nfnl_handle_packet returns -1 with errno == 0.

Using nfnl_process() instead of nfq_handle_packet() sets errno to the expected
ENOENT.

Does anyone know if nfq_handle_packet() "errno 0" behaviour is intentional?
Should I just ignore nfq_handle_packet() return value?
What about deprecating nfnl_handle_packet() and using nfnl_process()
instead?

Thanks,
Florian

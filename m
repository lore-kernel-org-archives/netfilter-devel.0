From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH next] netfilter: nfqueue: batch verdict support
Date: Tue, 5 Jul 2011 17:52:09 +0200
Message-ID: <20110705155209.GW16021@Chamillionaire.breakpoint.cc>
References: <1307657659-30266-1-git-send-email-fw@strlen.de>
 <4E1310EC.1030401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52896 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124Ab1GEPwK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:52:10 -0400
Content-Disposition: inline
In-Reply-To: <4E1310EC.1030401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 10.06.2011 00:14, Florian Westphal wrote:
> > Introduces a new nfnetlink type that applies a given
> > verdict to all queued packets with an id <= the id in the verdict
> > message.
> > 
> > If a mark is provided it is applied to all matched packets.
> > 
> > This reduces the number of verdicts that have to be sent.
> > Applications that make use of this feature need to maintain
> > a timeout to send a batchverdict periodically to avoid starvation.
> 
> Thanks Florian. Do you have any throughput numbers with this patch?

Sorry, not off the top of my head, but I'll post numbers
once I am back in the office.

(I should also re-run my tests with Erics patch applied anyway...)

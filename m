From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf] netfilter: x_tables: speed up jump target
 validation
Date: Thu, 14 Jul 2016 17:36:35 +0200
Message-ID: <20160714153635.GA27719@breakpoint.cc>
References: <1468400017-10146-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45712 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113AbcGNPgm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2016 11:36:42 -0400
Content-Disposition: inline
In-Reply-To: <1468400017-10146-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> The dummy ruleset I used to test the original validation change was broken,
> most rules were unreachable and were not tested by mark_source_chains().

...

I will send a v3 to also include arptables.
I thought arptables was irrelevant since arptable rulesets are usually
very small but I forgot about DoS angle (we use single mutext for all
net nsamespaces).

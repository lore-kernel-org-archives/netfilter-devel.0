From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH ipset] kernel: uapi: fix MARKMASK attr ABI breakage
Date: Thu, 13 Feb 2014 12:51:26 +0100
Message-ID: <20140213115126.GH25153@breakpoint.cc>
References: <1392291659-27444-1-git-send-email-fw@strlen.de>
 <20140213114725.GA8016@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43006 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479AbaBMLv1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:51:27 -0500
Content-Disposition: inline
In-Reply-To: <20140213114725.GA8016@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Feb 13, 2014 at 12:40:59PM +0100, Florian Westphal wrote:
> > commit 2dfb973c0dcc6d2211 (add markmask for hash:ip,mark data type)
> 
> I don't find that commit in the tree:
> 
> $ git show 2dfb973c0dcc6d2211
> fatal: ambiguous argument '2dfb973c0dcc6d2211': unknown revision or
> path not in the working tree.
> Use '--' to separate paths from revisions

its in ipset.git, not in kernel.  Sorry if that was not clear.

I did not find any references to MARKMASK in nf-next.git.

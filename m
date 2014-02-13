From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH ipset] kernel: uapi: fix MARKMASK attr ABI breakage
Date: Thu, 13 Feb 2014 12:55:43 +0100
Message-ID: <20140213115543.GA8226@localhost>
References: <1392291659-27444-1-git-send-email-fw@strlen.de>
 <20140213114725.GA8016@localhost>
 <20140213115126.GH25153@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50040 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbaBML4B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:56:01 -0500
Content-Disposition: inline
In-Reply-To: <20140213115126.GH25153@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 13, 2014 at 12:51:26PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Feb 13, 2014 at 12:40:59PM +0100, Florian Westphal wrote:
> > > commit 2dfb973c0dcc6d2211 (add markmask for hash:ip,mark data type)
> > 
> > I don't find that commit in the tree:
> > 
> > $ git show 2dfb973c0dcc6d2211
> > fatal: ambiguous argument '2dfb973c0dcc6d2211': unknown revision or
> > path not in the working tree.
> > Use '--' to separate paths from revisions
> 
> its in ipset.git, not in kernel.  Sorry if that was not clear.

Ah, I see.

> I did not find any references to MARKMASK in nf-next.git.

I think this is still in Jozsef's tree.

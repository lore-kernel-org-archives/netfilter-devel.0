From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH ipset] kernel: uapi: fix MARKMASK attr ABI breakage
Date: Thu, 13 Feb 2014 12:47:25 +0100
Message-ID: <20140213114725.GA8016@localhost>
References: <1392291659-27444-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45863 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaBMLr3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:47:29 -0500
Content-Disposition: inline
In-Reply-To: <1392291659-27444-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 13, 2014 at 12:40:59PM +0100, Florian Westphal wrote:
> commit 2dfb973c0dcc6d2211 (add markmask for hash:ip,mark data type)

I don't find that commit in the tree:

$ git show 2dfb973c0dcc6d2211
fatal: ambiguous argument '2dfb973c0dcc6d2211': unknown revision or
path not in the working tree.
Use '--' to separate paths from revisions

> inserted IPSET_ATTR_MARKMASK in-between other enum values, i.e.
> changing values of all further attributes.  This causes 'ipset list'
> segfault on existing kernels since ipset no longer finds
> IPSET_ATTR_MEMSIZE (it has a different value on kernel side).
> 
> Jozsef points out it should be moved below IPSET_ATTR_MARK which
> works since there is some extra reserved space after that value.

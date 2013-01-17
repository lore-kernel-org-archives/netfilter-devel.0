From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to modify
 labels
Date: Fri, 18 Jan 2013 00:39:35 +0100
Message-ID: <20130117233935.GC15996@1984>
References: <1357921846-29650-1-git-send-email-fw@strlen.de>
 <1357921846-29650-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35624 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab3AQXji (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:39:38 -0500
Content-Disposition: inline
In-Reply-To: <1357921846-29650-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 11, 2013 at 05:30:46PM +0100, Florian Westphal wrote:
> Add the ability to set/clear labels assigned to a conntrack
> via ctnetlink.
> 
> To allow userspace to only alter specific bits, Pablo suggested to add
> a new CTA_LABELS_MASK attribute:
> 
> The new set of active labels is then determined via
> 
> active = (active & ~mask) ^ changeset
> 
> i.e., the mask selects those bits in the existing set that should be
> changed.
> 
> This follows the same method already used by MARK and CONNMARK targets.
> 
> Omitting CTA_LABELS_MASK is the same as setting all bits in CTA_LABELS_MASK
> to 1: The existing set is replaced by the one from userspace.

And this also applied, thanks Florian.

You can push the user-space changes for this into some new -next
branch of each tree. Then merge it to master by when 3.9-rc1 is
released.

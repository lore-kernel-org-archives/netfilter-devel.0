From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] netfilter: add connlabel conntrack extension
Date: Fri, 18 Jan 2013 00:37:51 +0100
Message-ID: <20130117233751.GA15996@1984>
References: <1357921846-29650-1-git-send-email-fw@strlen.de>
 <1357921846-29650-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35524 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab3AQXh6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:37:58 -0500
Content-Disposition: inline
In-Reply-To: <1357921846-29650-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 11, 2013 at 05:30:44PM +0100, Florian Westphal wrote:
> similar to connmarks, except labels are bit-based; i.e.
> all labels may be attached to a flow at the same time.
> 
> Up to 128 labels are supported.  Supporting more labels
> is possible, but requires increasing the ct offset delta
> from u8 to u16 type due to increased extension sizes.
> 
> Mapping of bit-identifier to label name is done in userspace.
> 
> The extension is enabled at run-time once "-m connlabel" netfilter
> rules are added.

Applied, thanks.

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/5] netfilter: nf_tables: fix potential oops when
 dumping sets
Date: Thu, 6 Feb 2014 00:23:49 +0100
Message-ID: <20140205232349.GA5674@localhost>
References: <1391612619-30347-1-git-send-email-kaber@trash.net>
 <1391612619-30347-2-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51285 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbaBEXYt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:24:49 -0500
Content-Disposition: inline
In-Reply-To: <1391612619-30347-2-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 05, 2014 at 03:03:35PM +0000, Patrick McHardy wrote:
> Commit c9c8e48597 (netfilter: nf_tables: dump sets in all existing families)
> changed nft_ctx_init_from_setattr() to only look up the address family if it
> is not NFPROTO_UNSPEC. However if it is NFPROTO_UNSPEC and a table attribute
> is given, nftables_afinfo_lookup() will dereference the NULL afi pointer.
> 
> Fix by checking for non-NULL afi and also move a check added by that commit
> to the proper position.

Applied, thanks.

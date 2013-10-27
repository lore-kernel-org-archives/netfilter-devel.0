From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft: nft_set_attr_get_u32 null pointer deref
Date: Sun, 27 Oct 2013 21:34:26 +0100
Message-ID: <20131027203426.GA9466@localhost>
References: <20131025165531.GA18336@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60503 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab3J0Uek (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 16:34:40 -0400
Content-Disposition: inline
In-Reply-To: <20131025165531.GA18336@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 25, 2013 at 09:55:31AM -0700, Phil Oester wrote:
> As reported by John Sager, nft_set_attr_get_u32 can cause a segfault because
> nft_set_attr_get can return NULL.  Check for a non-NULL pointer before
> dereferencing.
> 
> This closes netfilter bugzilla #868.

I have mangled this patch to include possible null dereferences in get
operations with rule objects (similar case). Let me know if you see
any issue with my change.

Applied, thanks.

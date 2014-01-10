From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 00/13] netfilter: nf_tables: bug fixes and minor cleanups
Date: Fri, 10 Jan 2014 01:25:18 +0100
Message-ID: <20140110002518.GA17802@localhost>
References: <1389292963-4089-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50054 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbaAJAZZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:25:25 -0500
Content-Disposition: inline
In-Reply-To: <1389292963-4089-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 09, 2014 at 06:42:30PM +0000, Patrick McHardy wrote:
> The following patches fix a couple of bugs related to chain types module
> references, chain modification atomicity, chain type module loading
> and unloading of modules that are still in use. Detailed descriptions
> are in the individual changelogs.
> 
> The patches obviously also affect the current -rc, but I think its a bit
> late in the release cycle for bigger fixes like this, so I based them
> on your nftables.git tree.

We can pass part of this several of these bugfixes to -stable if we
think it's worth at some point, let's see how things go.

Series applied, thanks a lot.

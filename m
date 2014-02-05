From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] netfilter: nf_tables: add AF specific expression
 support
Date: Thu, 6 Feb 2014 00:24:19 +0100
Message-ID: <20140205232419.GC5674@localhost>
References: <1391612619-30347-1-git-send-email-kaber@trash.net>
 <1391612619-30347-4-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51267 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbaBEXYq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:24:46 -0500
Content-Disposition: inline
In-Reply-To: <1391612619-30347-4-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 05, 2014 at 03:03:37PM +0000, Patrick McHardy wrote:
> For the reject module, we need to add AF-specific implementations to
> get rid of incorrect module dependencies. Try to load an AF-specific
> module first and fall back to generic modules.

Applied, thanks Patrick.

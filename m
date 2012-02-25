From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] bridge: netfilter: fix module autoload in compat case
Date: Sat, 25 Feb 2012 14:30:12 +0100
Message-ID: <20120225133012.GD15774@1984>
References: <1329923672-20054-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58501 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2BYNaO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Feb 2012 08:30:14 -0500
Content-Disposition: inline
In-Reply-To: <1329923672-20054-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 22, 2012 at 04:14:32PM +0100, Florian Westphal wrote:
> We expected 0 if module doesn't exist, which is no longer the case
> (42046e2e45c109ba703993c510401a11f716c8df,
> netfilter: x_tables: return -ENOENT for non-existant matches/targets).

Applied, thanks Florian.

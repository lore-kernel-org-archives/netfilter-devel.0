From: Florian Westphal <fw@strlen.de>
Subject: Re: nft: meta l4proto range printing broken on 32bit
Date: Thu, 16 Jul 2015 15:42:29 +0200
Message-ID: <20150716134229.GL25674@breakpoint.cc>
References: <20150716133929.GK25674@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55625 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbbGPNmb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jul 2015 09:42:31 -0400
Content-Disposition: inline
In-Reply-To: <20150716133929.GK25674@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:

[ nft crashes on 32bit when trying to print meta l4proto 23-42 ]

> The problem is that meta_expr_pctx_update() assumes that
> right is a value, but after this change it can also be a value.

Grrr, seems I need a break.  Meant "... can now also be EXPR_RANGE."

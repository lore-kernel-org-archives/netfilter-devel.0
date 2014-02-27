From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] netfilter: nf_tables: add optional user data area to
 rules
Date: Thu, 27 Feb 2014 11:18:34 +0000
Message-ID: <20140227111834.GA5431@macbook.localnet>
References: <1393419861-6442-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56762 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaB0LSh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:18:37 -0500
Content-Disposition: inline
In-Reply-To: <1393419861-6442-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 26, 2014 at 02:04:21PM +0100, Pablo Neira Ayuso wrote:
> This allows us to store user comment strings, but it could be also
> used to store any kind of information that the user application needs
> to link to the rule.
> 
> Scratch 8 bits for the new ulen field that indicates the length the
> user data area. 4 bits from the handle (so it's 42 bits long, according
> to Patrick, it would last 139 years with 1000 new rules per second)
> and 4 bits from dlen (so the expression data area is 4K, which seems
> sufficient by now even considering the compatibility layer).
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Looks good to me.

Acked-by: Patrick McHardy <kaber@trash.net>

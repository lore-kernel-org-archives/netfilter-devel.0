From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: x_tables: ensure e->next_offset consistency
 with table size
Date: Mon, 21 Mar 2016 01:36:32 +0100
Message-ID: <20160321003632.GA1105@breakpoint.cc>
References: <1458338325-1456-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, mkubecek@suse.cz,
	hawkes@google.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36030 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbcCUAgg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Mar 2016 20:36:36 -0400
Content-Disposition: inline
In-Reply-To: <1458338325-1456-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patch introduces the generic __xt_entry_foreach() that includes a
> new parameter to account for remaining entry bytes in the table that we
> didn't walk so far. If the amount of remaining bytes is zero, then we
> keep validating this table, otherwise for < 0 we just reject this.
> 
> Reported-by: Ben Hawkes <hawkes@google.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Slightly tested here, will be spinning on this again with more testing
> tomorrow morning. I'll appreciate any extra hand on testing this
> further.

I have a patch queued (not yet sent) that makes this patch obsolete.

Basically UBSAN reports further bugs because we fail to test
e + e->next_offset <= limit.

Since e->next_offset not only is the next offset but (implicitly) also
the size of this rule check_entry_size_and_hooks() should check that
the alleged rule size is at least the limit (end-of-blob).

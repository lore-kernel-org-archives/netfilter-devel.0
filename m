From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/4] netfilter: x_tables: don't move to non-existent next
 rule
Date: Mon, 21 Mar 2016 01:34:48 +0100
Message-ID: <20160321003448.GA29493@breakpoint.cc>
References: <1458424294-8678-1-git-send-email-fw@strlen.de>
 <1458424294-8678-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36027 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbcCUAev (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Mar 2016 20:34:51 -0400
Content-Disposition: inline
In-Reply-To: <1458424294-8678-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Ben Hawkes says:
> 
>  In the mark_source_chains function (net/ipv4/netfilter/ip_tables.c) it
>  is possible for a user-supplied ipt_entry structure to have a large
>  next_offset field. This field is not bounds checked prior to writing a
>  counter value at the supplied offset.
> 
> Problem is that xt_entry_foreach() macro stops iterating once
> e->next_offset is out of bounds, assuming this is the last entry that
> will be used.
> 
> However, if the blob is malformed its possible that mark_source_chains
> function attempts to move past the last entry iff this last entry
> doesn't have a verdict/jump (i.e. evaluation continues with next rule).

Problem is that the underflow check thinks the last rule is terminal
but mark_source_chains sees that its in fact a conditional rule.

So we should fix the underflow detection instead to catch this, I'll send
a different patch tomorrow.

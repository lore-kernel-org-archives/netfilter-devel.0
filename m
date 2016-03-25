From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/5] netfilter: x_tables: add and use
 xt_check_entry_target
Date: Fri, 25 Mar 2016 12:45:53 +0100
Message-ID: <20160325114553.GA9738@breakpoint.cc>
References: <1458666173-24318-1-git-send-email-fw@strlen.de>
 <1458666173-24318-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40317 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbcCYLp5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Mar 2016 07:45:57 -0400
Content-Disposition: inline
In-Reply-To: <1458666173-24318-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> +	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
> +	    target_offset + sizeof(struct xt_standard_target) > next_offset)
> +		return -EINVAL;

The last hunk broke CONFIG_COMPAT, it calls into check_entry() and
casts compat_Xt_entry to Xt_entry, but for compat case
xt_standard_target is larger than what a 32bit userspace sends us.

For now I'd suggest to not pass this to stable, I'll  rework
the compat handlers next week to fix this properly.

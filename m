From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 03/10] netfilter: bridge: kill
 NF_HOOK_THRESH() and state->tresh
Date: Thu, 13 Oct 2016 14:25:45 +0200
Message-ID: <20161013122545.GB14002@breakpoint.cc>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
 <1476360171-2991-4-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38760 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753343AbcJMM1H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 08:27:07 -0400
Content-Disposition: inline
In-Reply-To: <1476360171-2991-4-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Patch c5136b15ea36 ("netfilter: bridge: add and use br_nf_hook_thresh")
> introduced br_nf_hook_thresh().
> 
> Replace NF_HOOK_THRESH() by br_nf_hook_thresh from
> br_nf_forward_finish(), so we have no more callers for this macro.
> 
> As a result, state->thresh and explicit thresh parameter in the hook
> state structure is not required anymore.
> 
> And we can get rid of fast forward code in nf_iterate() in the core path
> that is only used by br_netfilter to search for the filter hook.

Note that you will need to move more parts of nf_hook_slow() into
br_nf_hook_thresh(); the bridge netfilter does need to thresh feature
that we have in nf_iterate().


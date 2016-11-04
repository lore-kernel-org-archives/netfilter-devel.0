From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf v2] netfilter: conntrack: refine gc worker heuristics
Date: Fri, 4 Nov 2016 10:07:26 +0100
Message-ID: <20161104090726.GA16482@breakpoint.cc>
References: <1478127895-32540-1-git-send-email-fw@strlen.de>
 <9b8a1258-1ecd-daf8-ffd2-1acc70e2ebbb@6wind.com>
 <20161103163133.GA26355@breakpoint.cc>
 <8aad7dbf-da86-9afc-805c-879833aa2883@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59506 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758630AbcKDJJR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Nov 2016 05:09:17 -0400
Content-Disposition: inline
In-Reply-To: <8aad7dbf-da86-9afc-805c-879833aa2883@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> > However, I will not send a new iteration of this change since I don't
> > know how to test this.  Its easy to make the delay low, but it will come
> > at additonal cpu cost.  I have no idea where to make the tradeoff.
> For me, the priority is to deliver events with a reasonnable delay (and I think
> Pablo also asks for this in a previous email). I understand that the cpu cost
> need to be taken into account, but it's a tradeoff of the new design I think.

I sent one last iteration.  Other than exporting max time as a sysctl
like in your proposal I am out of ideas.

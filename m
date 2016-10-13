From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 08/10] netfilter: move NF_QUEUE handling away
 from core
Date: Thu, 13 Oct 2016 17:09:46 +0200
Message-ID: <20161013150946.GA20580@breakpoint.cc>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
 <1476360171-2991-9-git-send-email-pablo@netfilter.org>
 <20161013123821.GC14002@breakpoint.cc>
 <20161013150423.GB1301@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39394 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755900AbcJMPKm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 11:10:42 -0400
Content-Disposition: inline
In-Reply-To: <20161013150423.GB1301@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Any reason why this is needed?
> > AFAICS xt_NFQUEUE will never return NF_QUEUE after this patch.
> 
> -j QUEUE uses the standard target to return NF_QUEUE. This is very
> primitive way to queue packets to userspace queue 0 via nf_queue, but
> still may break. I can place this under unlikely() as these days
> people should be using NFQUEUE instead.

No need, just add a comment that this handles legacy standard target
QUEUE (i forgot we still have this).

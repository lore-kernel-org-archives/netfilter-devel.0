From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC nft] src: ct: add connection counting support
Date: Mon, 15 Jan 2018 13:42:37 +0100
Message-ID: <20180115124237.GD27085@breakpoint.cc>
References: <20180112134111.19132-1-fw@strlen.de>
 <20180115104639.6x55lm4tjrnz5nk6@salvia>
 <20180115105947.GC27085@breakpoint.cc>
 <20180115110833.upp7legzjiirc5ww@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40808 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966534AbeAOMpF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 07:45:05 -0500
Content-Disposition: inline
In-Reply-To: <20180115110833.upp7legzjiirc5ww@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Basically the rbtree is a kludge because we can't store it in the
> > conntrack table and on-demand counting of the conntrack table would
> > be way too expensive.
> 
> I see, actually we could even place this in a hashtable instead,
> right? Not asking you to do this, just thinking aloud here.

Yes.  rbtree was only chosen due to deterministic behaviour and
ability to do gc lookups while traversing nodes.


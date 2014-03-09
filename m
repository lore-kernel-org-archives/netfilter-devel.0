From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 7/7] netfilter: connlimit: use rbtree for per-host
 conntrack obj storage
Date: Sun, 9 Mar 2014 19:43:57 +0100
Message-ID: <20140309184357.GC14012@breakpoint.cc>
References: <1394199435-14395-1-git-send-email-fw@strlen.de>
 <1394199435-14395-8-git-send-email-fw@strlen.de>
 <1394203677.20149.18.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140307161512.GF17526@breakpoint.cc>
 <1394390520.20149.108.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51256 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbaCISn6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2014 14:43:58 -0400
Content-Disposition: inline
In-Reply-To: <1394390520.20149.108.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Hmm, that would be nice.  I need to think about it again,
> > problem is that moving it at this time could result in
> > freeing the would-be parent of the new node.
> 
> Yeah, thats why fq_gc() is followed by a full lookup.
> 
> In practice, the lookup done in fq_gc() brings in cpu cache all the
> cache lines, and second lookup is very fast.

I had wondered about this.  Ok, that makes sense.
I'll change it to be more like fq.

Thanks for explaining this.

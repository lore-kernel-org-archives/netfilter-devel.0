From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 7/7] netfilter: connlimit: use rbtree for per-host
 conntrack obj storage
Date: Sun, 09 Mar 2014 11:42:00 -0700
Message-ID: <1394390520.20149.108.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1394199435-14395-1-git-send-email-fw@strlen.de>
	 <1394199435-14395-8-git-send-email-fw@strlen.de>
	 <1394203677.20149.18.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140307161512.GF17526@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:60735 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaCISmB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2014 14:42:01 -0400
Received: by mail-pb0-f53.google.com with SMTP id rp16so6305158pbb.12
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Mar 2014 11:42:01 -0700 (PDT)
In-Reply-To: <20140307161512.GF17526@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2014-03-07 at 17:15 +0100, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > I would call tree_nodes_free() _before_ attempting the
> > kmem_cache_alloc(), so that the allocation can reuse a hot object that
> > you freed right before allocation.
> 
> Hmm, that would be nice.  I need to think about it again,
> problem is that moving it at this time could result in
> freeing the would-be parent of the new node.

Yeah, thats why fq_gc() is followed by a full lookup.

In practice, the lookup done in fq_gc() brings in cpu cache all the
cache lines, and second lookup is very fast.




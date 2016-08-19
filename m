From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next 2/6] netfilter: conntrack: get rid of conntrack
 timer
Date: Fri, 19 Aug 2016 08:24:23 -0700
Message-ID: <1471620263.29842.107.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1471606575-2197-1-git-send-email-fw@strlen.de>
         <1471606575-2197-3-git-send-email-fw@strlen.de>
         <1471617465.29842.102.camel@edumazet-glaptop3.roam.corp.google.com>
         <20160819151642.GA11049@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35757 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752784AbcHSPiF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Aug 2016 11:38:05 -0400
Received: by mail-pf0-f193.google.com with SMTP id h186so1638724pfg.2
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Aug 2016 08:38:05 -0700 (PDT)
In-Reply-To: <20160819151642.GA11049@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2016-08-19 at 17:16 +0200, Florian Westphal wrote:

> Hmm, ____nf_conntrack_find caller needs to hold rcu_read_lock,
> in case object is free'd SLAB_DESTROY_BY_RCU should delay actual release
> of the page.

Well, point is that SLAB_DESTROY_BY_RCU means that we have no grace
period, and object can be immediately reused and recycled.

@next pointer can definitely be overwritten.

> 
> Should be same as (old) 'death_by_timeout' timer firing during
> hlist_nulls_for_each_entry_rcu walk.
> 
> Thanks for looking at this Eric!



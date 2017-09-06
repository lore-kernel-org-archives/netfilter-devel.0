From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 1/2] netfilter: nat: Revert "netfilter: nat: convert
 nat bysrc hash to rhashtable"
Date: Wed, 6 Sep 2017 15:07:50 +0200
Message-ID: <20170906130750.GE11551@breakpoint.cc>
References: <20170906123952.12555-1-fw@strlen.de>
 <20170906123952.12555-2-fw@strlen.de>
 <CAFoGUiyjXxgYBU+POj2_x3H9BXPW=FUGr3LS3KNUDdxDL0vbng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Dao Quang Minh <dqminh89@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35076 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750739AbdIFNKq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 09:10:46 -0400
Content-Disposition: inline
In-Reply-To: <CAFoGUiyjXxgYBU+POj2_x3H9BXPW=FUGr3LS3KNUDdxDL0vbng@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dao Quang Minh <dqminh89@gmail.com> wrote:
> Thanks for the patch !
> 
> > rhlist removal however requires a rhlist walk.
> We can have thousands of entries in such a list if source port/addresses
> are reused for multiple flows, if this happens removal requests are so
> expensive that deletions of a few thousand flows can take several
> seconds(!).
> 
> Do you think rhlist can use double linked list instead of single linked so
> removal doesn't need to walk the whole chain ?

Yes, but:

> > I tried to add hlist_node to rhlist to speed up rhltable_remove but this
> > isn't doable without changing semantics.  rhltable_remove_fast will
> > check that the to-be-deleted object is part of the table and that
> > requires a list walk that we want to avoid.
> >
> > Furthermore, using hlist_node increases size of struct rhlist_head, which
> > in turn increases nf_conn size.

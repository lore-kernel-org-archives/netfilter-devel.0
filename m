From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 nf-next 3/3] netfilter: x_tables: pack percpu counter
 allocations
Date: Mon, 21 Nov 2016 14:41:55 -0800
Message-ID: <1479768115.8455.425.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1479766036-1307-1-git-send-email-fw@strlen.de>
         <1479766036-1307-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34985 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754072AbcKUWl5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2016 17:41:57 -0500
Received: by mail-pg0-f66.google.com with SMTP id p66so10352pga.2
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2016 14:41:57 -0800 (PST)
In-Reply-To: <1479766036-1307-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2016-11-21 at 23:07 +0100, Florian Westphal wrote:
> instead of allocating each xt_counter individually, allocate 4k chunks
> and then use these for counter allocation requests.
> 
> This should speed up rule evaluation by increasing data locality,
> also speeds up ruleset loading because we reduce calls to the percpu
> allocator.
> 
> As Eric points out we can't use PAGE_SIZE, page_allocator would fail on
> arches with 64k page size.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

Acked-by: Eric Dumazet <edumazet@google.com>

Very cool, thanks a lot !



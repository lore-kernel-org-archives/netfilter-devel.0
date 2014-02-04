From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack: don't release a conntrack with
 non-zero refcnt
Date: Mon, 03 Feb 2014 16:39:22 -0800
Message-ID: <1391474362.28432.112.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1391465397-3856-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, avagin@parallels.com, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51880 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaBDAjX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Feb 2014 19:39:23 -0500
Received: by mail-pb0-f49.google.com with SMTP id up15so7700279pbc.22
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Feb 2014 16:39:23 -0800 (PST)
In-Reply-To: <1391465397-3856-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2014-02-03 at 23:09 +0100, Pablo Neira Ayuso wrote:
> With this patch, the conntrack refcount is initially set to zero and
> it is bumped once it is added to any of the list, so we fulfill
> Eric's golden rule which is that all released objects always have a
> refcount that equals zero.
> 
> Andrey Vagin reports that nf_conntrack_free can't be called for a
> conntrack with non-zero ref-counter, because it can race with
> nf_conntrack_find_get().
> 
> A conntrack slab is created with SLAB_DESTROY_BY_RCU. Non-zero
> ref-counter says that this conntrack is used. So when we release
> a conntrack with non-zero counter, we break this assumption.
...
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Andrew Vagin <avagin@parallels.com>
> Reported-by: Andrew Vagin <avagin@parallels.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

SGTM !

Reviewed-by: Eric Dumazet <edumazet@google.com>



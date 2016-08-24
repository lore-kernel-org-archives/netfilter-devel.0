From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next 7/7] netfilter: restart search if moved to other
 chain
Date: Wed, 24 Aug 2016 06:20:48 -0700
Message-ID: <1472044848.14381.75.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1472039755-14267-1-git-send-email-fw@strlen.de>
         <1472039755-14267-8-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34829 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755239AbcHXNUv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 09:20:51 -0400
Received: by mail-pa0-f65.google.com with SMTP id cf3so1202068pad.2
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 06:20:50 -0700 (PDT)
In-Reply-To: <1472039755-14267-8-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2016-08-24 at 13:55 +0200, Florian Westphal wrote:
> In case nf_conntrack_tuple_taken did not find a conflicting entry
> check that all entries in this hash slot were tested and restart
> in case an entry was moved to another chain.
> 
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

Fixes: ea781f197d6a ("netfilter: nf_conntrack: use SLAB_DESTROY_BY_RCU and get rid of call_rcu()")
Acked-by: Eric Dumazet <edumazet@google.com>

Thanks !



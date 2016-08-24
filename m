From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 nf-next 3/7] netfilter: evict stale entries on
 netlink dumps
Date: Wed, 24 Aug 2016 10:33:11 -0700
Message-ID: <1472059991.14381.104.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1472039755-14267-1-git-send-email-fw@strlen.de>
         <1472039755-14267-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32974 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbcHXRdN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 13:33:13 -0400
Received: by mail-pf0-f194.google.com with SMTP id i6so1585765pfe.0
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 10:33:13 -0700 (PDT)
In-Reply-To: <1472039755-14267-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2016-08-24 at 13:55 +0200, Florian Westphal wrote:
> When dumping we already have to look at the entire table, so we might
> as well toss those entries whose timeout value is in the past.
> 
> We also look at every entry during resize operations.
> However, eviction there is not as simple because we hold the
> global resize lock so we can't evict without adding a 'expired' list
> to drop from later.  Considering that resizes are very rare it doesn't
> seem worth doing it.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
Acked-by: Eric Dumazet <edumazet@google.com>



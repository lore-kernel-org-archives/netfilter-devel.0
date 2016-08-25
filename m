From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v3 nf-next 6/7] netfilter: conntrack: resched gc again
 if eviction rate is high
Date: Thu, 25 Aug 2016 09:07:39 -0700
Message-ID: <1472141259.14381.138.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1472132015-10264-1-git-send-email-fw@strlen.de>
         <1472132015-10264-7-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33081 "EHLO
        mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbcHYQIu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 12:08:50 -0400
Received: by mail-pa0-f66.google.com with SMTP id vy10so3329854pac.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 09:07:41 -0700 (PDT)
In-Reply-To: <1472132015-10264-7-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2016-08-25 at 15:33 +0200, Florian Westphal wrote:
> If we evicted a large fraction of the scanned conntrack entries re-schedule
> the next gc cycle for immediate execution.
> 
> This triggers during tests where load is high, then drops to zero and
> many connections will be in TW/CLOSE state with < 30 second timeouts.
> 
> Without this change it will take several minutes until conntrack count
> comes back to normal.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

Acked-by: Eric Dumazet <edumazet@google.com>



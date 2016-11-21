From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next 1/3] netfilter: x_tables: pass xt_counters
 struct instead of packet counter
Date: Mon, 21 Nov 2016 07:49:16 -0800
Message-ID: <1479743356.8455.406.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1479736654-2359-1-git-send-email-fw@strlen.de>
         <1479736654-2359-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:32915 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754775AbcKUPtS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2016 10:49:18 -0500
Received: by mail-pg0-f66.google.com with SMTP id 3so28925384pgd.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2016 07:49:18 -0800 (PST)
In-Reply-To: <1479736654-2359-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2016-11-21 at 14:57 +0100, Florian Westphal wrote:
> On SMP we overload the packet counter (unsigned long) to contain
> percpu offset.  Hide this from callers and pass xt_counters address
> instead.
> 
> Preparation patch to allocate the percpu counters in page-sized batch
> chunks.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

Acked-by: Eric Dumazet <edumazet@google.com>




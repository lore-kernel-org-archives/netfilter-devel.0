From: Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH nf] netfilter: x_tables: ensure readers see new ->private value
Date: Wed, 11 Oct 2017 11:04:57 -0700
Message-ID: <CANn89i+V9TXVujaCB_6ev5JUAQDM7NqJ3oVksf1siccUG24B7g@mail.gmail.com>
References: <20171011180324.15638-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:50129 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932627AbdJKSE7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 14:04:59 -0400
Received: by mail-ua0-f181.google.com with SMTP id h34so1603007uaa.6
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2017 11:04:58 -0700 (PDT)
In-Reply-To: <20171011180324.15638-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 11, 2017 at 11:03 AM, Florian Westphal <fw@strlen.de> wrote:
> Eric Dumazet wrote:
>  But it seems we need an extra smp_wmb() after
>       smp_wmb();
>       table->private = newinfo;
>
> Otherwise we have no guarantee other cpus actually see the new
> ->private value.
>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

I do not believe this change is needed in net (or nf) tree.
See my other reply.

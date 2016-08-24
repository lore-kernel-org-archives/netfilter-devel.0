From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 nf-next 2/7] netfilter: conntrack: get rid of
 conntrack timer
Date: Wed, 24 Aug 2016 10:11:26 -0700
Message-ID: <1472058686.14381.98.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1472039755-14267-1-git-send-email-fw@strlen.de>
         <1472039755-14267-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36458 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933010AbcHXRL2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 13:11:28 -0400
Received: by mail-pf0-f195.google.com with SMTP id y134so1549370pfg.3
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2016 10:11:28 -0700 (PDT)
In-Reply-To: <1472039755-14267-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2016-08-24 at 13:55 +0200, Florian Westphal wrote:
> With stats enabled this eats 80 bytes on x86_64 per nf_conn entry, as
> Eric Dumazet pointed out during netfilter workshop 2016.

Another reason was the fact that Thomas was about to change max timer
range : 

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=500462a9de657f86edaa102f8ab6bff7f7e43fc2

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks !



From: Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH nf] netfilter: xtables: add scheduling opportunity in get_counters
Date: Fri, 1 Sep 2017 13:51:46 -0700
Message-ID: <CANn89iKrYpNRm567yPCkaQtRmBHqhyROhP7grfPhfyMw80-C6g@mail.gmail.com>
References: <20170901204103.16129-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:34510 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752393AbdIAUvs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2017 16:51:48 -0400
Received: by mail-yw0-f172.google.com with SMTP id t188so6283331ywb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Sep 2017 13:51:48 -0700 (PDT)
In-Reply-To: <20170901204103.16129-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 1, 2017 at 1:41 PM, Florian Westphal <fw@strlen.de> wrote:
> There are reports about spurious softlockups during iptables-restore, a
> backtrace i saw points at get_counters -- it uses a sequence lock and also
> has unbounded restart loop.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/netfilter/arp_tables.c | 1 +
>  net/ipv4/netfilter/ip_tables.c  | 1 +
>  net/ipv6/netfilter/ip6_tables.c | 1 +
>  3 files changed, 3 insertions(+)

SGTM, thanks Florian !

Acked-by: Eric Dumazet <edumazet@google.com>

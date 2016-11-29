From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf] netfilter: ipv6: nf_defrag: drop mangled skb on ream
 error
Date: Mon, 28 Nov 2016 18:55:09 -0800
Message-ID: <1480388109.18162.110.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1480382254-13277-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, andreyknvl@google.com,
        dvyukov@google.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35307 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752046AbcK2CzM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 21:55:12 -0500
Received: by mail-pf0-f194.google.com with SMTP id i88so7342063pfk.2
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 18:55:12 -0800 (PST)
In-Reply-To: <1480382254-13277-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2016-11-29 at 02:17 +0100, Florian Westphal wrote:
> Dmitry Vyukov reported GPF in network stack that Andrey traced down to
> negative nh offset in nf_ct_frag6_queue().
> 
> Problem is that all network headers before fragment header are pulled.
> Normal ipv6 reassembly will drop the skb when errors occur further down
> the line.
> 
> netfilter doesn't do this, and instead passed the original fragment
> along.  That was also fine back when netfilter ipv6 defrag worked with
> cloned fragments, as the original, pristine fragment was passed on.
> 
> So we either have to undo the pull op, or discard such fragments.
> Since they're malformed after all (e.g. overlapping fragment) it seems
> preferrable to just drop them.
> 
> Same for temporary errors -- it doesn't make sense to accept (and
> perhaps forward!) only some fragments of same datagram.
> 
> Fixes: 029f7f3b8701cc7ac ("netfilter: ipv6: nf_defrag: avoid/free clone operations")
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Debugged-by: Andrey Konovalov <andreyknvl@google.com>
> Diagnosed-by: Eric Dumazet <Eric Dumazet <edumazet@google.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  KASAN no longer complains, ping6 -s $bignum still works and gets picked up
>  by ipv6 conntrack.
> 
>  Eric, I did think about changing nf_ct_frag6_gather but since its not a
>  netfilter hook a hook retval doesn't seem to be appropriate (and also
>  increases patch size).

Right, I guess nf_ prefix in its name is a bit misleading ;)

> 
>  This doesn't conflict with recent
>  'openvswitch: Fix skb leak in IPv6 reassembly' patch.

Seems fine to me, thanks !

Acked-by: Eric Dumazet <edumazet@google.com>



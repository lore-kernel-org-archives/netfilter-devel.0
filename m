From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ipv6: nf_defrag: drop mangled skb on ream
 error
Date: Tue, 29 Nov 2016 20:25:04 +0100
Message-ID: <20161129192504.GA2597@salvia>
References: <1480382254-13277-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, andreyknvl@google.com,
        dvyukov@google.com, eric.dumazet@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39624 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751726AbcK2TZQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 14:25:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CE2BA174D19
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 20:25:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BBC98A7D50
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 20:25:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5FB0EA7E2E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 20:25:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1480382254-13277-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 29, 2016 at 02:17:34AM +0100, Florian Westphal wrote:
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

Applied, thanks!

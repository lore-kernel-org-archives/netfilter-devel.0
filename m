From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2] netfilter: x_tables: Fix use-after-free in
 ipt_do_table.
Date: Wed, 26 Jul 2017 13:06:27 +0200
Message-ID: <20170726110627.GC1607@salvia>
References: <20170726091648.20639-1-ap420073@gmail.com>
 <20170726092716.GB28392@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51860 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750867AbdGZLGk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2017 07:06:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C6E617D431
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 13:06:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E703DA57F
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 13:06:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56617D1CCC
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 13:06:24 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170726092716.GB28392@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 26, 2017 at 11:27:16AM +0200, Florian Westphal wrote:
> Taehee Yoo <ap420073@gmail.com> wrote:
> > If verdict is NF_STOLEN in the SYNPROXY target,
> > the skb is consumed.
> > However, ipt_do_table() always tries to get ip header from the skb.
> > So that, KASAN triggers the use-after-free message.
> 
> In case anyone wonders, ip6tables doesn't have this problem
> because we pass *skb, not ip6hdr to ip6_packet_match().

I think it would be good to make these code converge to what ip6tables
is doing while fixing up this?

> arptables has the same bug, it seems (no target returns STOLEN,
> but I think we should fix it there as well).

Yes, even if no target returns what triggers the problem, it's good if
we fix this now so we make sure whatever new extension gets in in the
future works accordingly.

Thanks!

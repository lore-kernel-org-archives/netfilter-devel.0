From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2] netfilter: x_tables: Fix use-after-free in
 ipt_do_table.
Date: Wed, 26 Jul 2017 11:27:16 +0200
Message-ID: <20170726092716.GB28392@breakpoint.cc>
References: <20170726091648.20639-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57858 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750816AbdGZJ3F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2017 05:29:05 -0400
Content-Disposition: inline
In-Reply-To: <20170726091648.20639-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Taehee Yoo <ap420073@gmail.com> wrote:
> If verdict is NF_STOLEN in the SYNPROXY target,
> the skb is consumed.
> However, ipt_do_table() always tries to get ip header from the skb.
> So that, KASAN triggers the use-after-free message.

In case anyone wonders, ip6tables doesn't have this problem
because we pass *skb, not ip6hdr to ip6_packet_match().

arptables has the same bug, it seems (no target returns STOLEN,
but I think we should fix it there as well).


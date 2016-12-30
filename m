From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] net/bridge: Fix dropping packets that moving through
 bridge interface
Date: Fri, 30 Dec 2016 17:58:11 +0100
Message-ID: <20161230165811.GA1403@breakpoint.cc>
References: <947bdfc8-07f1-f909-2328-85af084de741@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Artur Molchanov <arturmolchanov@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58016 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751581AbcL3Q66 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Dec 2016 11:58:58 -0500
Content-Disposition: inline
In-Reply-To: <947bdfc8-07f1-f909-2328-85af084de741@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Artur Molchanov <arturmolchanov@gmail.com> wrote:
> From: Artur Molchanov <artur.molchanov@synesis.ru>
> 
> Fixes: c5136b15ea36 ("netfilter: bridge: add and use br_nf_hook_thresh")
> 
> Problem:
> br_nf_pre_routing_finish() calls itself instead of
> br_nf_pre_routing_finish_bridge().
> Due to this bug reverse path filter drops packets that moving through
> bridge interface.

Indeed, thanks for fixing this!

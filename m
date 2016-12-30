From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] net/bridge: Fix dropping packets that moving through
 bridge interface
Date: Fri, 30 Dec 2016 18:22:07 +0100
Message-ID: <20161230172207.GA22162@salvia>
References: <947bdfc8-07f1-f909-2328-85af084de741@gmail.com>
 <20161230165811.GA1403@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Artur Molchanov <arturmolchanov@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59314 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750962AbcL3RWO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Dec 2016 12:22:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 54B0C8AC2
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Dec 2016 18:22:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45461179E3B
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Dec 2016 18:22:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31B8B1B300E
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Dec 2016 18:22:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161230165811.GA1403@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 30, 2016 at 05:58:11PM +0100, Florian Westphal wrote:
> Artur Molchanov <arturmolchanov@gmail.com> wrote:
> > From: Artur Molchanov <artur.molchanov@synesis.ru>
> > 
> > Fixes: c5136b15ea36 ("netfilter: bridge: add and use br_nf_hook_thresh")
> > 
> > Problem:
> > br_nf_pre_routing_finish() calls itself instead of
> > br_nf_pre_routing_finish_bridge().
> > Due to this bug reverse path filter drops packets that moving through
> > bridge interface.
> 
> Indeed, thanks for fixing this!

Applied, thanks everyone.

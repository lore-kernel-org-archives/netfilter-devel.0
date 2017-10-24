From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 nf-next 0/2] netfilter: x_tables: speed up
 iptables-restore
Date: Tue, 24 Oct 2017 18:04:17 +0200
Message-ID: <20171024160417.GA12134@salvia>
References: <20171011231351.8517-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57274 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdJXQEV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 12:04:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E3DA0E9773
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:04:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3D0ADA877
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:04:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171011231351.8517-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 12, 2017 at 01:13:49AM +0200, Florian Westphal wrote:
> iptables-restore can take quite a long time when sytem is busy, in order
> of half a minute or more.
> 
> The main reason for this is the way ip(6)tables performs table swap:
> 
> When xt_replace_table assigns the new ruleset pointer, it does
> not wait for other processors to finish with old ruleset.
> 
> Instead it relies on the counter sequence lock in get_counters().
> 
> This works but this is costly if system is busy as each counter read
> operation can possibly be restarted indefinitely.
> 
> Instead, make xt_replace_table wait until all processors are known to not
> use the old ruleset anymore.
> 
> This allows to read the old counters without any locking, no cpu is
> using the ruleset anymore so counters can't change either.

Series applied, thanks.

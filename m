From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: get rid of per-object conntrack timers
Date: Tue, 30 Aug 2016 11:43:58 +0200
Message-ID: <20160830094358.GA19195@salvia>
References: <1472132015-10264-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752238AbcH3JoI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 05:44:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8DC4311E585
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:44:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E0F1D1DBB
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:44:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4158100A6C
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:43:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472132015-10264-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 25, 2016 at 03:33:28PM +0200, Florian Westphal wrote:
> During NFWS 2016 it was mentioned that per-conntrack timers have
> two drawbacks:
>  - the 5-day default established timeout is very large and brings
>    extra constraints for the timer subsystem.
>  - most distros enable timer stats so timer struct eats 80 bytes
>    in each conntrack object.
> 
> This series replaces the per-object struct timer with a u32 jiffie
> stamp and one global delayed work queue for conntrack eviction.
> Size of nf_conn struct is reduced to 256 bytes on x86_64.
> 
> Eviction is performed from the packet path when doing
> table lookup, for cases where we have idle periods the work
> queue is used.

Series applied, thanks Florian!

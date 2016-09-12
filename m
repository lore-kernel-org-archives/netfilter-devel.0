From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: remove packet hotpath stats
Date: Mon, 12 Sep 2016 20:09:34 +0200
Message-ID: <20160912180934.GA2471@salvia>
References: <1473627353-27981-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55840 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753318AbcILSJj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 14:09:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 02C051324F4
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:09:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4F8B100A5F
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:09:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0E68100A5F
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:09:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473627353-27981-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 11, 2016 at 10:55:53PM +0200, Florian Westphal wrote:
> These counters sit in hot path and do show up in perf, this is especially
> true for 'found' and 'searched' which get incremented for every packet
> processed.
> 
> Information like
> 
> searched=212030105
> new=623431
> found=333613
> delete=623327
> 
> does not seem too helpful nowadays:
> 
> - on busy systems found and searched will overflow every few hours
> (these are 32bit integers), other more busy ones every few days.
> 
> - for debugging there are better methods, such as iptables' trace target,
> the conntrack log sysctls.  Nowadays we also have perf tool.
> 
> This removes packet path stat counters except those that
> are expected to be 0 (or close to 0) on a normal system, e.g.
> 'insert_failed' (race happened) or 'invalid' (proto tracker rejects).
> 
> The insert stat is retained for the ctnetlink case.
> The found stat is retained for the tuple-is-taken check when NAT has to
> determine if it needs to pick a different source address.

Applied, thanks.

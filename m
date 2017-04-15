From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] netfilter: ecache: Refine the
 nf_ct_deliver_cached_events
Date: Sat, 15 Apr 2017 11:29:09 +0200
Message-ID: <20170415092909.GA5278@salvia>
References: <1492047349-99130-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36462 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751893AbdDOJ3O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 05:29:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C3FCEE04BA
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:29:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B29CCDA729
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:29:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57054DA7F7
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:29:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492047349-99130-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 13, 2017 at 09:35:49AM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> 1. Remove single !events condition check to deliver the missed event
> even though there is no new event happened.
> 
> Consider this case:
> 1) nf_ct_deliver_cached_events is invoked at the first time, the
> event is failed to deliver, then the missed is set.
> 2) nf_ct_deliver_cached_events is invoked again, but there is no
> any new event happened.
> The missed event is lost really.
> 
> It would try to send the missed event again after remove this check.
> And it is ok if there is no missed event because the latter check
> !((events | missed) & e->ctmask) could avoid it.
> 
> 2. Correct the return value check of notify->fcn.
> When send the event successfully, it returns 0, not postive value.

Applied, thanks.

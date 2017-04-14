From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: cttimeout: Fix one possible
 use-after-free issue
Date: Fri, 14 Apr 2017 03:28:26 +0200
Message-ID: <20170414012826.GA30669@salvia>
References: <1492132420-70400-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42518 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751255AbdDNB2n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 21:28:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1C8B3E0443
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 03:28:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C9DAFB461
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 03:28:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6420CFB462
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 03:28:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492132420-70400-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 14, 2017 at 09:13:40AM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The function ctnl_untimeout is used to untimeout every conntrack
> which is using the timeout. But it is necessary to add one barrier
> synchronize_rcu because of racing. Maybe one conntrack has already
> owned this timeout, but it is not inserted into unconfirmed list or
> the hash list, when ctnl_untimeout untimeout the conntracks
> 
> Let me describe it with a call path
> CPU1				CPU2
> alloc new conn
> add timeout ext
> 				ctnl_timeout_try_del
> 				untimeout all conns in list
> 				kfree_rcu.
> conn is confirmed.

Then this confirmed conn gets a timeout_ext->timeout == NULL since
ctnl_untimeout() is called first.

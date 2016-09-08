From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: xt_TEE: Add the missed return value
 check in tee_tg_check
Date: Thu, 8 Sep 2016 10:34:22 +0200
Message-ID: <20160908083422.GA1967@salvia>
References: <1473304976-9899-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38842 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965220AbcIHIea (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2016 04:34:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 041A72E784E
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2016 10:34:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E20B8114D68
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2016 10:34:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7498A114D65
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2016 10:34:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473304976-9899-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 08, 2016 at 11:22:56AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The original codes didn't check the return value of function
> register_netdevice_notifier.

net/netfilter/nf_tables_netdev.c: register_netdevice_notifier(&nf_tables_netdev_notifier);
net/netfilter/nfnetlink_queue.c: register_netdevice_notifier(&nfqnl_dev_notifier);

I can track a few more calls in the netfilter tree, I'd suggest you
fix them in one go given they are part of the same logical change
(they fit very weel into one single patch description).

Thanks!

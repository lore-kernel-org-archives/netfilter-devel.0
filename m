From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 1/2 nf-next] netfilter: ftp: Remove the useless
 dlen==0 condition check in find_pattern
Date: Wed, 7 Sep 2016 10:48:43 +0200
Message-ID: <20160907084843.GA3906@salvia>
References: <1472727509-1025-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39434 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754707AbcIGIst (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 04:48:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8963411E58B
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:48:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 702F01153FD
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:48:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DBA2F100A5F
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:48:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472727509-1025-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 01, 2016 at 06:58:29PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The caller function "help" has already make sure the datalen could not be zero
> before invoke find_pattern as a parameter by the following codes
> 
>         if (dataoff >= skb->len) {
>                 pr_debug("ftp: dataoff(%u) >= skblen(%u)\n", dataoff,
>                          skb->len);
>                 return NF_ACCEPT;
>         }
>         datalen = skb->len - dataoff;
> 
> And the latter codes "ends_in_nl = (fb_ptr[datalen - 1] == '\n');" use datalen
> directly without checking if it is zero.
>
> So it is unneccessary to check it in find_pattern too.

Applied, thanks.

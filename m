From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: xt_TCPMSS: Refactor the codes to
 decrease one condition check and more readable
Date: Sat, 24 Sep 2016 21:14:27 +0200
Message-ID: <20160924191427.GA2525@salvia>
References: <1473216024-7824-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48222 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934991AbcIXTOk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Sep 2016 15:14:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72C9EE6645
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Sep 2016 21:14:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61991DA846
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Sep 2016 21:14:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87781DA842
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Sep 2016 21:14:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473216024-7824-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 07, 2016 at 10:40:24AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The origin codes perform two condition checks with dst_mtu(skb_dst(skb))
> and in_mtu. And the last statement is "min(dst_mtu(skb_dst(skb)),
> in_mtu) - minlen". It may let reader think about how about the result.
> Would it be negative.
> 
> Now assign the result of min(dst_mtu(skb_dst(skb)), in_mtu) to a new
> variable, then only perform one condition check, and it is more readable.

Applied, thanks.

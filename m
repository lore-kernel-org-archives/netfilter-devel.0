From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 1/1] netfilter: SYNPROXY: Return NF_STOLEN
 instead of NF_DROP during handshaking
Date: Thu, 13 Apr 2017 23:57:49 +0200
Message-ID: <20170413215749.GA4208@salvia>
References: <1491963290-84377-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45502 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbdDMV6H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 17:58:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8C7D2BA6E8
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:58:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6806DA865
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:58:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29166DA804
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:58:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491963290-84377-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 12, 2017 at 10:14:50AM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Current SYNPROXY codes return NF_DROP during normal TCP handshaking,
> it is not friendly to caller. Because the nf_hook_slow would treat
> the NF_DROP as an error, and return -EPERM.
> As a result, it may cause the top caller think it meets one error.
> 
> So use NF_STOLEN instead of NF_DROP now because there is no error
> happened indeed, and free the skb directly.

Is this really addressing a real problem? How did you reproduce it?

BTW, your patch title is wrong.

[PATCH nf-next v2 1/1]
                  ^^^

This 1/1 is completely useless, please remove it in your follow up
patches.

Moreover, you should be more careful, *really*, this is not a speed
coding contest. You tend to send me follow up patch version just hours
afterwards because you rush too much.

Be more careful, use the same email address to send your patches. Drop
quote the full email in your replies...

Other than that, I may start ignoring your patches, it's too hard to
keep up with this.

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2 1/1] netfilter: expect: Make sure the max_expected
 limit is effective
Date: Thu, 6 Apr 2017 18:30:46 +0200
Message-ID: <20170406163046.GA5955@salvia>
References: <1490362339-2313-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36712 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751877AbdDFQbA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 12:31:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 559D111ADC8
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:30:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 453A2BAAB0
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:30:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF890BAAB0
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:30:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490362339-2313-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 24, 2017 at 09:32:19PM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Because the type of expecting, the member of nf_conn_help, is u8, it
> would overflow after reach U8_MAX(255). So it doesn't work when we
> configure the max_expected exceeds 255 with expect policy.
> 
> Now add the check for max_expected. Return the -EINVAL when it exceeds
> the limit.

Applied to nf-next.

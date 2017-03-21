From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_cthelper] examples: fix double free in
 nftc-helper-add
Date: Tue, 21 Mar 2017 11:41:08 +0100
Message-ID: <20170321104108.GA3034@salvia>
References: <1489932070-57299-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41920 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756305AbdCUKlV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 06:41:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DFDF0EBAC0
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:41:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D50BFDA86F
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:41:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E761DA87C
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:41:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489932070-57299-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 19, 2017 at 10:01:10PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> After inputting the following test command, core dump happened:
>   # ./examples/nfct-helper-add test 1
>   *** Error in
>  `.../libnetfilter_cthelper/examples/.libs/lt-nfct-helper-add':
>   double free or corruption (fasttop): 0x0000000001f3c070 ***
>   ======= Backtrace: =========
>   /lib64/libc.so.6(+0x77de5)[0x7fd9ebe88de5]
>   /lib64/libc.so.6(+0x8022a)[0x7fd9ebe9122a]
>   /lib64/libc.so.6(cfree+0x4c)[0x7fd9ebe9478c]
>   [...]
> 
> Because "struct nfct_helper_policy *p" had been freed by nfct_helper_free,
> so there's no need to invoke nfct_helper_policy_free again, otherwise
> dobule free error will happen.

Applied, thanks.

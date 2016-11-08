From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] net/netfilter: Fix use uninitialized warn in
 nft_range_eval()
Date: Wed, 9 Nov 2016 00:13:13 +0100
Message-ID: <20161108231313.GA6329@salvia>
References: <20161107154114.26803-1-shuahkh@osg.samsung.com>
 <20161107154114.26803-4-shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751012AbcKHXNz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 18:13:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 586A0392E1D
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:13:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47D70DA849
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:13:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12438DA809
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2016 00:13:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161107154114.26803-4-shuahkh@osg.samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 07, 2016 at 08:41:14AM -0700, Shuah Khan wrote:
> Fix the following warn:
> 
>    CC [M]  net/netfilter/nft_range.o
> 8601,8605c9105
>  net/netfilter/nft_range.c: In function ‘nft_range_eval’:
>  net/netfilter/nft_range.c:45:5: warning: ‘mismatch’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    if (mismatch)
>       ^

You probably using an old tree snapshot? This was already fixed by:

commit d2e4d593516e877f1f6fb40031eb495f36606e16
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Oct 18 00:05:30 2016 +0200

    netfilter: nf_tables: avoid uninitialized variable warning

    The newly added nft_range_eval() function handles the two possible
    nft range operations, but as the compiler warning points out,
    any unexpected value would lead to the 'mismatch' variable being
    used without being initialized:


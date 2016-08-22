From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: nft_hash: fix non static symbol warning
Date: Mon, 22 Aug 2016 11:45:32 +0200
Message-ID: <20160822094532.GA10159@salvia>
References: <1471792870-16895-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52308 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754085AbcHVJpk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 05:45:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31939164198
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:45:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 234C3FF2FC
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:45:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D757100A5D
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:45:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471792870-16895-1-git-send-email-weiyj.lk@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 21, 2016 at 03:21:10PM +0000, Wei Yongjun wrote:
> Fixes the following sparse warning:
> 
> net/netfilter/nft_hash.c:40:25: warning:
>  symbol 'nft_hash_policy' was not declared. Should it be static?

Applied, thanks.

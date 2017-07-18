From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix netfilter_net_init() return
Date: Tue, 18 Jul 2017 23:30:42 +0200
Message-ID: <20170718213042.GA7083@salvia>
References: <20170718193856.yh2qd2j5bloiuq5r@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56012 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751647AbdGRVar (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 17:30:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 254C6137BAB
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 23:30:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 162CCA0AC5
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 23:30:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0650ECE5FF
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 23:30:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170718193856.yh2qd2j5bloiuq5r@mwanda>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David,

Please if you can manually take this into your net tree to expedite
things.

On Tue, Jul 18, 2017 at 10:38:56PM +0300, Dan Carpenter wrote:
> We accidentally return an uninitialized variable.
> 
> Fixes: cf56c2f892a8 ("netfilter: remove old pre-netns era hook api")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks!

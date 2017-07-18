From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netfilter: fix netfilter_net_init() return
Date: Tue, 18 Jul 2017 14:51:06 -0700 (PDT)
Message-ID: <20170718.145106.286676766217250687.davem@davemloft.net>
References: <20170718193856.yh2qd2j5bloiuq5r@mwanda>
        <20170718213042.GA7083@salvia>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: dan.carpenter@oracle.com, fw@strlen.de, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:56716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752823AbdGRVvK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 17:51:10 -0400
In-Reply-To: <20170718213042.GA7083@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 18 Jul 2017 23:30:42 +0200

> David,
> 
> Please if you can manually take this into your net tree to expedite
> things.
> 
> On Tue, Jul 18, 2017 at 10:38:56PM +0300, Dan Carpenter wrote:
>> We accidentally return an uninitialized variable.
>> 
>> Fixes: cf56c2f892a8 ("netfilter: remove old pre-netns era hook api")
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Ok, applied, thanks.

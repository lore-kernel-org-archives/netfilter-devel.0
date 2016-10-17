From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch v2] netfilter: nf_tables: underflow in
 nft_parse_u32_check()
Date: Mon, 17 Oct 2016 17:40:09 +0200
Message-ID: <20161017154009.GA15655@salvia>
References: <CAML_gOedjw6uJqp13YkGfXoLQTd_ikOC8OoUA4oXv15RYsgoUg@mail.gmail.com>
 <20161012091429.GA27317@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura Garcia Liebana <nevola@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758074AbcJQPkO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 11:40:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 391191022A6
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:40:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A3BEDA84A
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:40:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7918DA84A
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:40:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20161012091429.GA27317@mwanda>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 12, 2016 at 12:14:29PM +0300, Dan Carpenter wrote:
> We don't want to allow negatives here.

Applied, thanks.

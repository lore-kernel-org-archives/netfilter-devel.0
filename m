From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 2/2 nf-next] netfilter: Add the missed return value
 check of nft_register_chain_type
Date: Mon, 12 Sep 2016 19:40:20 +0200
Message-ID: <20160912174020.GA30541@salvia>
References: <1473473070-7062-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40694 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753093AbcILRkb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 13:40:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5527311D8E2
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:40:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 461651150D2
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:40:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10F71FF2C7
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:40:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473473070-7062-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 10, 2016 at 10:04:30AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are some codes of netfilter module which did not check the return
> value of nft_register_chain_type. Add the checks now.

Applied.

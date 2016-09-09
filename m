From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 2/2 nf-next] netfilter: Add the missed return value
 check of nft_register_chain_type
Date: Fri, 9 Sep 2016 19:22:05 +0200
Message-ID: <20160909172205.GA1436@salvia>
References: <1473434736-4479-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44494 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751830AbcIIRWQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 13:22:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6525CB6C86
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 19:22:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5379E114D75
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 19:22:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 319EF114D61
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 19:22:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473434736-4479-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 09, 2016 at 11:25:36PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are some codes of netfilter module which did not check the return
> value of nft_register_chain_type. Add the checks now.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  v3: Split return value check of nft_register_chain_type as second patch
>  v2: Add all return value checks in netfilter module
>  v1: Initial patch
> 
>  net/netfilter/nf_tables_inet.c   | 13 ++++++++++---
>  net/netfilter/nf_tables_netdev.c | 14 +++++++++-----
>  2 files changed, 19 insertions(+), 8 deletions(-)

Missing bridge chunk:

# git grep nft_register_chain_type net/bridge/
net/bridge/netfilter/nf_tables_bridge.c: nft_register_chain_type(&filter_bridge);

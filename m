From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next] netfilter: Add the missed return value check
 of register_netdevice_notifier
Date: Fri, 9 Sep 2016 16:16:39 +0200
Message-ID: <20160909141639.GA26129@salvia>
References: <1473328438-5371-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44952 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbcIIOQp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 10:16:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 34AC02273E8
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 16:16:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2487C114D6C
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 16:16:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39F941150D7
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 16:16:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473328438-5371-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 08, 2016 at 05:53:58PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are some codes of netfilter module which did not check the return
> value of register_netdevice_notifier. Add the checks now.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  v2: Add all return value checks in netfilter module
>  v1: Initial patch
> 
>  net/netfilter/nf_tables_netdev.c | 24 ++++++++++++++++++------
>  net/netfilter/nfnetlink_queue.c  |  9 ++++++++-
>  net/netfilter/xt_TEE.c           |  8 +++++++-
>  3 files changed, 33 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
> index 5eefe4a..2c2a17e 100644
> --- a/net/netfilter/nf_tables_netdev.c
> +++ b/net/netfilter/nf_tables_netdev.c
> @@ -222,14 +222,26 @@ static int __init nf_tables_netdev_init(void)
>  {
>  	int ret;
>  
> -	nft_register_chain_type(&nft_filter_chain_netdev);
> +	ret = nft_register_chain_type(&nft_filter_chain_netdev);
> +	if (ret)
> +		goto err1;
> +

Ah good, nft_register_chain_type() is already not checked.

So I'd appreciate if you fix all callsites in the Netfilter tree.

I propose you two patches, one to fix nft_register_chain_type() and
another to fix register_netdevice_notifier() all over the netfilter
tree.

Thanks!

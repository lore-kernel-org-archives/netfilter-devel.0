From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: check duplicate config when initializing
 in ipt_CLUSTERIP
Date: Tue, 20 Dec 2016 01:48:03 +0100
Message-ID: <20161220004803.GA14656@salvia>
References: <9b3e1f76b5670d33727e63b6e166ae416b0d65af.1481776300.git.lucien.xin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48230 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbcLTAsM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2016 19:48:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C138335B5
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 01:48:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2489A7E2A
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 01:48:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7724EA7E1E
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 01:48:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <9b3e1f76b5670d33727e63b6e166ae416b0d65af.1481776300.git.lucien.xin@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 15, 2016 at 12:31:40PM +0800, Xin Long wrote:
> @@ -185,6 +186,17 @@ clusterip_config_init(const struct ipt_clusterip_tgt_info *i, __be32 ip,
>  	atomic_set(&c->refcount, 1);
>  	atomic_set(&c->entries, 1);
>  
> +	spin_lock_bh(&cn->lock);
> +	if (__clusterip_config_find(net, ip)) {
> +		spin_unlock_bh(&cn->lock);
> +		kfree(c);
> +
> +		return NULL;
> +	}

This is going to result in ENOMEM error report to userspace on race,
which can be confusing. Time for clusterip_config_init() to return
PTR_ERR()?

> +
> +	list_add_rcu(&c->list, &cn->configs);
> +	spin_unlock_bh(&cn->lock);
> +
>  #ifdef CONFIG_PROC_FS
>  	{
>  		char buffer[16];

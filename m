Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A85C001DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Aug 2023 02:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbjHOCyC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Aug 2023 22:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbjHOCxu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2023 22:53:50 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A436B1986
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Aug 2023 19:53:49 -0700 (PDT)
Received: from mg.bb.i.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id 4A972AF2C
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Aug 2023 05:53:48 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id 32E77AF2B
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Aug 2023 05:53:48 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
        by ink.ssi.bg (Postfix) with ESMTPSA id 659DF3C0441;
        Tue, 15 Aug 2023 05:53:45 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ssi.bg; s=ink;
        t=1692068026; bh=W+Z0WTspsdbpobGPJx4v2/IEO37df2Pimxz6FZTRsNE=;
        h=Date:From:To:cc:Subject:In-Reply-To:References;
        b=TxeJO+ezb/1Wg1XWK+Ukj/7m27bcaURRNEeMnmJPVOkj2TNxLakBZs35qdLh0Yq0o
         KkCIiZa2vVNK47+s7XUCZCUbfgJ7hXKgufxg0HhnJyM+MspOxpt6k/AwfLPNb26xo4
         /SFxFbRVCj4TYu8jmeL6Aa2iJgeDnFhnGNlJnzPQ=
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.17.1) with ESMTP id 37F2rhLv026279;
        Tue, 15 Aug 2023 05:53:44 +0300
Date:   Tue, 15 Aug 2023 05:53:43 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Sishuai Gong <sishuai.system@gmail.com>
cc:     Simon Horman <horms@verge.net.au>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] ipvs: fix racy memcpy in proc_do_sync_threshold
In-Reply-To: <B556FD7B-3190-4C8F-BA83-FC5C147FEAE1@gmail.com>
Message-ID: <359e4898-01fe-775f-d6a5-753caa585642@ssi.bg>
References: <B556FD7B-3190-4C8F-BA83-FC5C147FEAE1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Thu, 10 Aug 2023, Sishuai Gong wrote:

> When two threads run proc_do_sync_threshold() in parallel,
> data races could happen between the two memcpy():
> 
> Thread-1			Thread-2
> memcpy(val, valp, sizeof(val));
> 				memcpy(valp, val, sizeof(val));
> 
> This race might mess up the (struct ctl_table *) table->data,
> so we add a mutex lock to serilize them, as discussed in [1].
> 
> [1] https://archive.linuxvirtualserver.org/html/lvs-devel/2023-08/msg00031.html
> 
> Signed-off-by: Sishuai Gong <sishuai.system@gmail.com>

	Looks good to me for net/nf, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_ctl.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 62606fb44d02..4bb0d90eca1c 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -1876,6 +1876,7 @@ static int
>  proc_do_sync_threshold(struct ctl_table *table, int write,
>  		       void *buffer, size_t *lenp, loff_t *ppos)
>  {
> +	struct netns_ipvs *ipvs = table->extra2;
>  	int *valp = table->data;
>  	int val[2];
>  	int rc;
> @@ -1885,6 +1886,7 @@ proc_do_sync_threshold(struct ctl_table *table, int write,
>  		.mode = table->mode,
>  	};
>  
> +	mutex_lock(&ipvs->sync_mutex);
>  	memcpy(val, valp, sizeof(val));
>  	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
>  	if (write) {
> @@ -1894,6 +1896,7 @@ proc_do_sync_threshold(struct ctl_table *table, int write,
>  		else
>  			memcpy(valp, val, sizeof(val));
>  	}
> +	mutex_unlock(&ipvs->sync_mutex);
>  	return rc;
>  }
>  
> @@ -4321,6 +4324,7 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
>  	ipvs->sysctl_sync_threshold[0] = DEFAULT_SYNC_THRESHOLD;
>  	ipvs->sysctl_sync_threshold[1] = DEFAULT_SYNC_PERIOD;
>  	tbl[idx].data = &ipvs->sysctl_sync_threshold;
> +	tbl[idx].extra2 = ipvs;
>  	tbl[idx++].maxlen = sizeof(ipvs->sysctl_sync_threshold);
>  	ipvs->sysctl_sync_refresh_period = DEFAULT_SYNC_REFRESH_PERIOD;
>  	tbl[idx++].data = &ipvs->sysctl_sync_refresh_period;
> -- 
> 2.39.2 (Apple Git-143)

Regards

--
Julian Anastasov <ja@ssi.bg>


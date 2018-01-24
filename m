From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: Add extra bits for object handles
Date: Wed, 24 Jan 2018 16:57:24 +0100
Message-ID: <20180124155724.lahondvctsj5ah6n@salvia>
References: <20180123233722.7388-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38080 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933953AbeAXP5a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jan 2018 10:57:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 49FBF4FFE04
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2018 16:57:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30A42DA7E0
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2018 16:57:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180123233722.7388-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 24, 2018 at 05:07:22AM +0530, Harsha Sharma wrote:
> Add extra bits for table, chain, sets and object handle.
> 
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  net/netfilter/nf_tables_trace.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
> index e1dc527a493b..f804c3924d32 100644
> --- a/net/netfilter/nf_tables_trace.c
> +++ b/net/netfilter/nf_tables_trace.c
> @@ -212,7 +212,11 @@ void nft_trace_notify(struct nft_traceinfo *info)
>  		nla_total_size(sizeof(__be16)) +	/* oiftype */
>  		nla_total_size(sizeof(u32)) +		/* mark */
>  		nla_total_size(sizeof(u32)) +		/* nfproto */
> -		nla_total_size(sizeof(u32));		/* policy */
> +		nla_total_size(sizeof(u32)); +		/* policy */
> +		nla_total_size_64bit(sizeof(__be64)) +	/* table handle */
> +		nla_total_size_64bit(sizeof(__be64)) +	/* chain handle */
> +		nla_total_size_64bit(sizeof(__be64)) +	/* set handle */
> +		nla_total_size_64bit(sizeof(__be64))	/* object handle */

I think just two of this should be fine. Is nla_total_size_64bit()
accounting for padding too?

I would like to see the userspace patches in place too, to test this.

Thanks!

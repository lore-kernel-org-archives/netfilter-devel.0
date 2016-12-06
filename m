From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: avoid warn and OOM killer on vmalloc call
Date: Tue, 6 Dec 2016 13:21:44 +0100
Message-ID: <20161206122144.GA2127@salvia>
References: <e10fd8b5206bfde5526e3bbf2b5ff9af584b0a6f.1480671893.git.marcelo.leitner@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: andreyknvl@google.com, fw@strlen.de, nhorman@tuxdriver.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51102 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752630AbcLFMVx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 07:21:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B2CE68CD7F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 13:21:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3E57DA861
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 13:21:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9EEF9DA85F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 13:21:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <e10fd8b5206bfde5526e3bbf2b5ff9af584b0a6f.1480671893.git.marcelo.leitner@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 02, 2016 at 07:46:38AM -0200, Marcelo Ricardo Leitner wrote:
> Andrey Konovalov reported that this vmalloc call is based on an
> userspace request and that it's spewing traces, which may flood the logs
> and cause DoS if abused.
> 
> Florian Westphal also mentioned that this call should not trigger OOM
> killer.
> 
> This patch brings the vmalloc call in sync to kmalloc and disables the
> warn trace on allocation failure and also disable OOM killer invocation.
> 
> Note, however, that under such stress situation, other places may
> trigger OOM killer invocation.

Unless anyone has an objection, I'm going to place this in nf-next.

Thanks.

> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Cc: Florian Westphal <fw@strlen.de>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/netfilter/x_tables.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index fc4977456c30e098197b4f987b758072c9cf60d9..dece525bf83a0098dad607fce665cd0bde228362 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -958,7 +958,9 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
>  	if (sz <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
>  		info = kmalloc(sz, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
>  	if (!info) {
> -		info = vmalloc(sz);
> +		info = __vmalloc(sz, GFP_KERNEL | __GFP_NOWARN |
> +				     __GFP_NORETRY | __GFP_HIGHMEM,
> +				 PAGE_KERNEL);
>  		if (!info)
>  			return NULL;
>  	}
> -- 
> 2.9.3
> 

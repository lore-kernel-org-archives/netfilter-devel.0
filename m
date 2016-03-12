From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: x_tables: check for size overflow
Date: Sat, 12 Mar 2016 11:53:49 +0100
Message-ID: <20160312105349.GA1542@salvia>
References: <1457571383-25520-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, hawkes@google.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43455 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbcCLKx4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Mar 2016 05:53:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 813994B9E4
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 11:53:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 702DCDA388
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 11:53:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7BC9BDA8F9
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 11:53:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1457571383-25520-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 01:56:23AM +0100, Florian Westphal wrote:
> Ben Hawkes says:
>  integer overflow in xt_alloc_table_info, which on 32-bit systems can
>  lead to small structure allocation and a copy_from_user based heap
>  corruption.

Applied, thanks Florian. I have slightly mangled this patch, the
second check suffices to catch this case for us.

> Reported-by: Ben Hawkes <hawkes@google.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/x_tables.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index c8a0b7d..17a9a9f 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -659,6 +659,9 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
>  	struct xt_table_info *info = NULL;
>  	size_t sz = sizeof(*info) + size;
>  
> +	if (sz < size || sz < sizeof(*info))
> +		return NULL;

So this will show up in the tree like this:

        if (sz < sizeof(*info))
                return NULL;

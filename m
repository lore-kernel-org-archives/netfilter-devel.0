From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v4 11/18] nfnetlink_log: exit_net cleanup check added
Date: Sun, 12 Nov 2017 14:28:37 +0300
Message-ID: <864c0cb8-5a82-d274-24dc-799333816c7f@cogentembedded.com>
References: <9dfa013e-9098-e155-9c47-a73753338288@virtuozzo.com>
 <9702fe4f-6b5d-bd5c-de87-6bf7ded4fbf2@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Vasily Averin <vvs@virtuozzo.com>, netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:56004 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbdKLL2h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2017 06:28:37 -0500
Received: by mail-lf0-f68.google.com with SMTP id e143so15397074lfg.12
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Nov 2017 03:28:36 -0800 (PST)
In-Reply-To: <9702fe4f-6b5d-bd5c-de87-6bf7ded4fbf2@virtuozzo.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

On 11/12/2017 11:46 AM, Vasily Averin wrote:

> Be sure that instance_table array initialized in net_init hook
> was return to initial state.
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>   net/netfilter/nfnetlink_log.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index cad6498..80236a2 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -1093,10 +1093,15 @@ static int __net_init nfnl_log_net_init(struct net *net)
>   
>   static void __net_exit nfnl_log_net_exit(struct net *net)
>   {
> +	unsigned int i;
> +	struct nfnl_log_net *log = nfnl_log_pernet(net);

    Need empty line after the declarations.

>   #ifdef CONFIG_PROC_FS
>   	remove_proc_entry("nfnetlink_log", net->nf.proc_netfilter);
>   #endif
>   	nf_log_unset(net, &nfulnl_logger);
> +	for (i = 0; i < INSTANCE_BUCKETS; i++)
> +		if (WARN_ON_ONCE(!hlist_empty(&log->instance_table[i])))
> +			break;
>   }
[...]

MBR, Sergei

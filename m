From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: don't permit unprivileged writes to global
 state via sysctls
Date: Thu, 20 Oct 2016 20:22:24 +0200
Message-ID: <20161020182224.GA10999@salvia>
References: <1474669264-3283-1-git-send-email-jann@thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jann Horn <jann@thejh.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41504 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752101AbcJTSWd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 14:22:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 129BB9D33C
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 20:22:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01F5CDA850
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 20:22:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C401FDA7F6
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 20:22:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474669264-3283-1-git-send-email-jann@thejh.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 24, 2016 at 12:21:04AM +0200, Jann Horn wrote:
> This prevents the modification of nf_conntrack_max in unprivileged network
> namespaces. For unprivileged network namespaces, ip_conntrack_max is kept
> as a readonly sysctl in order to minimize potential compatibility issues.
> 
> This patch should apply cleanly to the net tree.

For the record: This patch looks good to me, but this legacy
ip_conntrack sysctl code is now gone.

I don't know what is the procedure to get this to -stable branches now
that this cannot be pushed upstream.

> Signed-off-by: Jann Horn <jann@thejh.net>
> ---
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> index ae1a71a..a639e94 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> @@ -358,6 +358,9 @@ static int ipv4_init_net(struct net *net)
>  	if (!in->ctl_table)
>  		return -ENOMEM;
>  
> +	if (net->user_ns != &init_user_ns)
> +		in->ctl_table[0].mode = 0444;
> +
>  	in->ctl_table[0].data = &nf_conntrack_max;
>  	in->ctl_table[1].data = &net->ct.count;
>  	in->ctl_table[2].data = &nf_conntrack_htable_size;
> -- 
> 2.1.4
> 

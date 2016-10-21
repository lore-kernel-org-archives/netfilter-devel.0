From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: simplify init/uninit of L4
 protocol trackers
Date: Fri, 21 Oct 2016 19:12:09 +0200
Message-ID: <20161021171209.GB1556@salvia>
References: <22bf211a6755d8179835f707ed6e665ecb7ffbfc.1477060478.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932467AbcJURMQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 13:12:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DC090C8830
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 19:12:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1F26BAAA2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 19:12:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74328BAAC5
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 19:12:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <22bf211a6755d8179835f707ed6e665ecb7ffbfc.1477060478.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 21, 2016 at 04:42:40PM +0200, Davide Caratti wrote:
> modify registration and deregistration of layer-4 protocol trackers to
> facilitate inclusion of new elements into the current list of built-in
> protocols.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 93 +++++++++++---------------
>  net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 93 +++++++++++---------------
>  2 files changed, 78 insertions(+), 108 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> index 713c09a..6ffe3dc 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> @@ -336,47 +336,44 @@ MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
>  MODULE_ALIAS("ip_conntrack");
>  MODULE_LICENSE("GPL");
>  
> +static struct nf_conntrack_l4proto *nf_conntrack_l4proto4[] = {
> +	&nf_conntrack_l4proto_tcp4,
> +	&nf_conntrack_l4proto_udp4,
> +	&nf_conntrack_l4proto_icmp,
> +};
> +
>  static int ipv4_net_init(struct net *net)
>  {
> -	int ret = 0;
> +	int i, ret = 0;
>  
> -	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_tcp4);
> -	if (ret < 0) {
> -		pr_err("nf_conntrack_tcp4: pernet registration failed\n");
> -		goto out_tcp;
> -	}
> -	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_udp4);
> -	if (ret < 0) {
> -		pr_err("nf_conntrack_udp4: pernet registration failed\n");
> -		goto out_udp;
> -	}
> -	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_icmp);
> -	if (ret < 0) {
> -		pr_err("nf_conntrack_icmp4: pernet registration failed\n");
> -		goto out_icmp;
> +	for (i = 0; i < ARRAY_SIZE(nf_conntrack_l4proto4); i++) {
> +		ret = nf_ct_l4proto_pernet_register(net,
> +						    nf_conntrack_l4proto4[i]);
> +		if (ret < 0)
> +			goto cleanup_l4proto;

Could you add:

        ret = nf_ct_l4proto_pernet_register(net, nf_conntrack_l4proto4,
                                            ARRAY_SIZE(nf_conntrack_l4proto4));

?

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] extensions: libxt_cluster: Add translation to nft
Date: Tue, 30 May 2017 12:08:55 +0200
Message-ID: <20170530100855.GC1273@salvia>
References: <1496132734-3829-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo@debian.org, fw@strlen.de
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750925AbdE3KJR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2017 06:09:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D688E1DA080
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 12:09:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5AB6C100A73
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 12:08:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D910FF2D2
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 12:08:49 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1496132734-3829-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 30, 2017 at 01:55:34PM +0530, Shyam Saini wrote:
> Add translation for cluster match to nftables
> 
> $ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed
> 0xdeadbeef -j MARK --set-mark 0xffff
> nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 2 seed 0xdeadbeef eq 0 meta pkttype set host counter meta mark set
> 0xffff
> 
> $ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-nodemask 1 --cluster-hash-seed
> 0xdeadbeef -j MARK --set-mark 0xffff
> nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr mod 2 seed 0xdeadbeef eq 0 meta pkttype set host counter meta mark set
> 0xffff
> 
>  --debug=netlink Result
> ip mangle PREROUTING
>   [ meta load iifname => reg 1 ]
>   [ cmp eq reg 1 0x31687465 0x00000000 0x00000000 0x00000000 ]
>   [ ct load src => reg 2 , dir original ]
>   [ hash reg 1 = jhash(reg 2, 4, 0xdeadbeef) % mod 2 ]
>   [ cmp eq reg 1 0x00000000 ]
>   [ immediate reg 1 0x00000000 ]
>   [ meta set pkttype with reg 1 ]
>   [ counter pkts 0 bytes 0 ]
>   [ immediate reg 1 0x0000ffff ]
>   [ meta set mark with reg 1 ]
> 
> For Example:
> 
> If we have  total 2 nodes (i.e, --cluster-total-nodes is 2) in the cluster then
>  modulus 2 = {0, 1}
> 
> For node 1 (--cluster-local-node 1)
> 	jhash ct original saddr mod 2 seed 0xdeadbeef eq 0
> 
> For  node 2 (--cluster-local-node 2)
> 	jhash ct original saddr mod 2 seed 0xdeadbeef eq 1
> 
> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> ---
>  extensions/libxt_cluster.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
> index 3adff12..f2abd18 100644
> --- a/extensions/libxt_cluster.c
> +++ b/extensions/libxt_cluster.c
> @@ -126,6 +126,16 @@ cluster_save(const void *ip, const struct xt_entry_match *match)
>  		info->total_nodes, info->hash_seed);
>  }
>  
> +static int cluster_xlate(struct xt_xlate *xl,
> +		const struct xt_xlate_mt_params *params)
> +{
> +	const struct xt_cluster_match_info *info = (const struct xt_cluster_match_info *)params->match->data;
> +
> +	xt_xlate_add(xl, "jhash ct original saddr mod %u seed 0x%08x eq 0 meta pkttype set host",

This should use "eq %u" because:

	xt_xlate_add(xl, "jhash ct original saddr mod %u seed 0x%08x eq %u meta pkttype set host",

Also check:

        ldd /path/to/your/iptables binary

and check what libraries you're suing, probably your iptables binary
using old ones.

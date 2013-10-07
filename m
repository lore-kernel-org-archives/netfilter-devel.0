From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH] nft: arp: add parse_target to nft_family_ops_arp
Date: Mon, 07 Oct 2013 08:43:20 +0300
Message-ID: <525249F8.4020108@linux.intel.com>
References: <1381063007-6184-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47017 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab3JGFnW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Oct 2013 01:43:22 -0400
In-Reply-To: <1381063007-6184-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good catch!

I probably read that file dozens of time and did not spot this...

Thanks,

Tomasz

> This patch adds parse_target for arp family, fixing segfaults
> for xtables-arp -L after rules like:
>
> - xtables-arp -A OUTPUT -o eth0 -j CLASSIFY --set-class 0:7
> - xtables-arp -A OUTPUT -o eth1 --h-length 6 -j mangle --mangle-mac-s 01:00:5e:00:01:01
>
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>   iptables/nft-arp.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
> index 570962d..08f8814 100644
> --- a/iptables/nft-arp.c
> +++ b/iptables/nft-arp.c
> @@ -643,4 +643,5 @@ struct nft_family_ops nft_family_ops_arp = {
>   	.print_firewall		= nft_arp_print_firewall,
>   	.post_parse		= NULL,
>   	.rule_find		= nft_arp_rule_find,
> +	.parse_target		= nft_arp_parse_target,
>   };


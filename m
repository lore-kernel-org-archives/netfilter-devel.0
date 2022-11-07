Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8A4C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Nov 2022 08:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiKGI2h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Nov 2022 03:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiKGI2b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Nov 2022 03:28:31 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBE72D0
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Nov 2022 00:28:25 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 18A55CC02A9;
        Mon,  7 Nov 2022 09:28:24 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon,  7 Nov 2022 09:28:21 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id C5183CC0102;
        Mon,  7 Nov 2022 09:28:21 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id BEDC3343157; Mon,  7 Nov 2022 09:28:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id BCB6A343156;
        Mon,  7 Nov 2022 09:28:21 +0100 (CET)
Date:   Mon, 7 Nov 2022 09:28:21 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Vishwanath Pai <vpai@akamai.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, johunt@akamai.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] netfilter: ipset: Add bitmask support to
 hash:netnet
In-Reply-To: <20220928182536.602688-5-vpai@akamai.com>
Message-ID: <775f95e3-cd7a-49e0-e09a-96aa4c993af2@netfilter.org>
References: <20220928182536.602688-1-vpai@akamai.com> <20220928182536.602688-5-vpai@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, 28 Sep 2022, Vishwanath Pai wrote:

> Create a new revision of hash:netnet and add support for bitmask
> parameter. The set did not support netmask so we'll add both netmask and
> bitmask.

The "netmask" keyword is not added to the type but the "bitmask" only. 
Technically the latter covers the former one, but maybe it'd be good to 
add explicit support to "netmask" as well.

Best regards,
Jozsef

> Signed-off-by: Vishwanath Pai <vpai@akamai.com>
> Signed-off-by: Joshua Hunt <johunt@akamai.com>
> ---
>  lib/ipset_hash_netnet.c | 100 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 100 insertions(+)
> 
> diff --git a/lib/ipset_hash_netnet.c b/lib/ipset_hash_netnet.c
> index df993b8..3898b8f 100644
> --- a/lib/ipset_hash_netnet.c
> +++ b/lib/ipset_hash_netnet.c
> @@ -387,6 +387,105 @@ static struct ipset_type ipset_hash_netnet3 = {
>  	.description = "bucketsize, initval support",
>  };
>  
> +/* bitmask support */
> +static struct ipset_type ipset_hash_netnet4 = {
> +	.name = "hash:net,net",
> +	.alias = { "netnethash", NULL },
> +	.revision = 4,
> +	.family = NFPROTO_IPSET_IPV46,
> +	.dimension = IPSET_DIM_TWO,
> +	.elem = {
> +		[IPSET_DIM_ONE - 1] = {
> +			.parse = ipset_parse_ip4_net6,
> +			.print = ipset_print_ip,
> +			.opt = IPSET_OPT_IP
> +		},
> +		[IPSET_DIM_TWO - 1] = {
> +			.parse = ipset_parse_ip4_net6,
> +			.print = ipset_print_ip,
> +			.opt = IPSET_OPT_IP2
> +		},
> +	},
> +	.cmd = {
> +		[IPSET_CREATE] = {
> +			.args = {
> +				IPSET_ARG_FAMILY,
> +				/* Aliases */
> +				IPSET_ARG_INET,
> +				IPSET_ARG_INET6,
> +				IPSET_ARG_HASHSIZE,
> +				IPSET_ARG_MAXELEM,
> +				IPSET_ARG_TIMEOUT,
> +				IPSET_ARG_COUNTERS,
> +				IPSET_ARG_COMMENT,
> +				IPSET_ARG_FORCEADD,
> +				IPSET_ARG_SKBINFO,
> +				IPSET_ARG_BUCKETSIZE,
> +				IPSET_ARG_INITVAL,
> +				IPSET_ARG_BITMASK,
> +				IPSET_ARG_NONE,
> +			},
> +			.need = 0,
> +			.full = 0,
> +			.help = "",
> +		},
> +		[IPSET_ADD] = {
> +			.args = {
> +				IPSET_ARG_TIMEOUT,
> +				IPSET_ARG_NOMATCH,
> +				IPSET_ARG_PACKETS,
> +				IPSET_ARG_BYTES,
> +				IPSET_ARG_ADT_COMMENT,
> +				IPSET_ARG_SKBMARK,
> +				IPSET_ARG_SKBPRIO,
> +				IPSET_ARG_SKBQUEUE,
> +				IPSET_ARG_NONE,
> +			},
> +			.need = IPSET_FLAG(IPSET_OPT_IP)
> +				| IPSET_FLAG(IPSET_OPT_IP2),
> +			.full = IPSET_FLAG(IPSET_OPT_IP)
> +				| IPSET_FLAG(IPSET_OPT_CIDR)
> +				| IPSET_FLAG(IPSET_OPT_IP_TO)
> +				| IPSET_FLAG(IPSET_OPT_IP2)
> +				| IPSET_FLAG(IPSET_OPT_CIDR2)
> +				| IPSET_FLAG(IPSET_OPT_IP2_TO),
> +			.help = "IP[/CIDR]|FROM-TO,IP[/CIDR]|FROM-TO",
> +		},
> +		[IPSET_DEL] = {
> +			.args = {
> +				IPSET_ARG_NONE,
> +			},
> +			.need = IPSET_FLAG(IPSET_OPT_IP)
> +				| IPSET_FLAG(IPSET_OPT_IP2),
> +			.full = IPSET_FLAG(IPSET_OPT_IP)
> +				| IPSET_FLAG(IPSET_OPT_CIDR)
> +				| IPSET_FLAG(IPSET_OPT_IP_TO)
> +				| IPSET_FLAG(IPSET_OPT_IP2)
> +				| IPSET_FLAG(IPSET_OPT_CIDR2)
> +				| IPSET_FLAG(IPSET_OPT_IP2_TO),
> +			.help = "IP[/CIDR]|FROM-TO,IP[/CIDR]|FROM-TO",
> +		},
> +		[IPSET_TEST] = {
> +			.args = {
> +				IPSET_ARG_NOMATCH,
> +				IPSET_ARG_NONE,
> +			},
> +			.need = IPSET_FLAG(IPSET_OPT_IP)
> +				| IPSET_FLAG(IPSET_OPT_IP2),
> +			.full = IPSET_FLAG(IPSET_OPT_IP)
> +				| IPSET_FLAG(IPSET_OPT_CIDR)
> +				| IPSET_FLAG(IPSET_OPT_IP2)
> +				| IPSET_FLAG(IPSET_OPT_CIDR2),
> +			.help = "IP[/CIDR],IP[/CIDR]",
> +		},
> +	},
> +	.usage = "where depending on the INET family\n"
> +		 "      IP is an IPv4 or IPv6 address (or hostname),\n"
> +		 "      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
> +		 "      IP range is not supported with IPv6.",
> +	.description = "bitmask support",
> +};
> +
>  void _init(void);
>  void _init(void)
>  {
> @@ -394,4 +493,5 @@ void _init(void)
>  	ipset_type_add(&ipset_hash_netnet1);
>  	ipset_type_add(&ipset_hash_netnet2);
>  	ipset_type_add(&ipset_hash_netnet3);
> +	ipset_type_add(&ipset_hash_netnet4);
>  }
> -- 
> 2.25.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary

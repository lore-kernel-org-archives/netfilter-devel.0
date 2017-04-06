From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC v2] extensions: libxt_TOS: Add translation to nft
Date: Fri, 7 Apr 2017 00:43:24 +0200
Message-ID: <20170406224324.GA1661@salvia>
References: <1490727018-25703-1-git-send-email-gs051095@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gsoc2013@lists.netfilter.org, netfilter-devel@vger.kernel.org
To: Gargi Sharma <gs051095@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38088 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751938AbdDFWnk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 18:43:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BA23D137B8B
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:43:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9922DA804
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:43:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2CCEDDA848
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:43:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490727018-25703-1-git-send-email-gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 29, 2017 at 12:20:18AM +0530, Gargi Sharma wrote:
> Add translation for TOS to nftables. TOS is deprecated
> ans DSCP is ued in place of it. The first 6 bits of
> TOS specify the DSCP value.
> 
> Examples:
> 
> $ iptables-translate -t mangle -A PREROUTING -p TCP --dport 22 -j TOS --set-tos 0x10
> nft add rule ip mangle PREROUTING tcp dport 22 counter  ip6 dscp set 0x04

Applied, but I had to mangle this patch.

Coding style is not correct, for two reason, see below.

> diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
> index cef5876..f284d83 100644
> --- a/extensions/libxt_TOS.c
> +++ b/extensions/libxt_TOS.c
> @@ -183,6 +183,30 @@ static void tos_tg_save(const void *ip, const struct xt_entry_target *target)
>  	printf(" --set-tos 0x%02x/0x%02x", info->tos_value, info->tos_mask);
>  }
>  
> +static int tos_xlate(struct xt_xlate *xl,
> +		     const struct xt_xlate_tg_params *params)
> +{
> +	const struct ipt_tos_target_info *info =
> +			(struct ipt_tos_target_info *) params->target->data;
> +
^^^
No need for new line here.

> +	__u8 dscp = (info->tos)>>2;

Missing space here between declaration and code.
You can just use uint8_t from stdint.h BTW.
And the parens are not required, plus missing spaces:

	__u8 dscp = info->tos >> 2;

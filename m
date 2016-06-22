From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: extensions: libxt_CONNMARK: Add translation to
 nft
Date: Wed, 22 Jun 2016 19:54:31 +0200
Message-ID: <20160622175431.GB8772@salvia>
References: <1466179850-20928-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: rodanber@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45214 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbcFVRyo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 13:54:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C03B6E8E91
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:54:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A540E266759
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:54:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9C1059EBAB
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:54:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466179850-20928-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied with minor glitches.

On Fri, Jun 17, 2016 at 06:10:50PM +0200, rodanber@gmail.com wrote:
> +static int
> +connmark_tg_xlate(const void *ip, const struct xt_entry_target *target,
> +		  struct xt_xlate *xl, int numeric)
> +{
> +	const struct xt_connmark_tginfo1 *info = (const void *)target->data;
> +	
   ^^^^^
I can see there unnecessary indentation for an empty line.

> +	switch (info->mode) {
> +	case XT_CONNMARK_SET:
> +		xt_xlate_add(xl, "ct mark set ");
> +		if (info->ctmark == 0)
> +			xt_xlate_add(xl, "ct mark and 0x%x", ~info->ctmask);
> +		else if (info->ctmark == info->ctmask)
> +			xt_xlate_add(xl, "ct mark or 0x%x",
> +				     info->ctmark);
> +		else if (info->ctmask == 0)
> +			xt_xlate_add(xl, "ct mark xor 0x%x",
> +				     info->ctmark);
> +		else if (info->ctmask == 0xFFFFFFFFU)
> +			xt_xlate_add(xl, "0x%x ", info->ctmark);
> +		else
> +			xt_xlate_add(xl, "ct mark xor 0x%x and 0x%x",
> +				     info->ctmark, ~info->ctmask);
> +		break;
> +	case XT_CONNMARK_SAVE:
> +		xt_xlate_add(xl, "ct mark set mark");
> +		if (!(info->nfmask == UINT32_MAX && info->ctmask == UINT32_MAX))
> +		{

Wrong coding style, instead:

		if (!(info->nfmask == UINT32_MAX &&
                    info->ctmask == UINT32_MAX)) {
                        ...

I have fixed this here this time. Thanks.

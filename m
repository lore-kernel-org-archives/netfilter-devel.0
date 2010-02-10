From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] netfilter: xtables: use xt_table for hook instantiation
Date: Wed, 10 Feb 2010 16:33:51 +0100
Message-ID: <4B72D1DF.4040409@trash.net>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53192 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab0BJPd4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:33:56 -0500
In-Reply-To: <1265813954-13854-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> +static unsigned int xt_hookmask_bitcount(unsigned int mask)
> +{
> +	unsigned int bits = 0;
> +
> +	for (; mask != 0; mask >>= 1)
> +		if (mask & 1)
> +			++bits;
> +	return bits;
> +}

Why not use hweight32()?

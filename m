From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: xtables: merge registration structure
 to NFPROTO_UNSPEC
Date: Wed, 31 Mar 2010 10:31:29 +0200
Message-ID: <4BB30861.3060101@trash.net>
References: <1270022629-2494-1-git-send-email-jengelh@medozas.de> <1270022629-2494-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56950 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab0CaIba (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:31:30 -0400
In-Reply-To: <1270022629-2494-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> +static struct xt_match state_mt_reg __read_mostly = {
> +	.name       = "state",
> +	.family     = NFPROTO_UNSPEC,
> +	.checkentry = state_mt_check,
> +	.match      = state_mt,
> +	.destroy    = state_mt_destroy,
> +	.matchsize  = sizeof(struct xt_state_info),
> +	.me         = THIS_MODULE,
>  };

This is the one I actually wanted to see since the subject didn't
state which module is changes.

The patch looks fine, however I'd prefer if in the future you'd add
a changelog entry for these conversions stating why this will work
properly in all cases even with arptables and ebtables using the
xtables infrastructure.


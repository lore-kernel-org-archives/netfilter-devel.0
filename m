From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] netfilter: xtables: inclusion of xt_TEE
Date: Tue, 13 Apr 2010 15:37:56 +0200
Message-ID: <4BC473B4.6070408@trash.net>
References: <1271162268-28131-1-git-send-email-jengelh@medozas.de> <1271162268-28131-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49787 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0DMNh5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:37:57 -0400
In-Reply-To: <1271162268-28131-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> +++ b/include/linux/netfilter/xt_TEE.h
> @@ -0,0 +1,8 @@
> +#ifndef _XT_TEE_TARGET_H
> +#define _XT_TEE_TARGET_H
> +
> +struct xt_tee_tginfo {
> +	union nf_inet_addr gw;
> +};

Mhh, quoting what I wrote earlier:

> That might make it unnessarily complicated to use src-based routing
> when using TEE. I guess you'd usually have a host for logging or IDS
> somewhere on a private network and TEE packets there. So specifying
> oif and gateway seems most useful to me.

This really should support oif in my opinion. Please add this
(and update to use IP6SKB while at it). I've pushed out the
patches I've applied so far.

BTW, no need to resend the other patches unless there are clashes.

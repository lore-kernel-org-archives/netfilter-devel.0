From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/10] netfilter: ebtables: avoid explicit XT_ALIGN()
 in match/targets
Date: Mon, 15 Feb 2010 18:40:44 +0100
Message-ID: <4B79871C.5000609@trash.net>
References: <1265897559-10610-1-git-send-email-fw@strlen.de> <1265897559-10610-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fwestphal@astaro.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65349 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab0BORkr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:40:47 -0500
In-Reply-To: <1265897559-10610-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> From: Florian Westphal <fwestphal@astaro.com>
> 
> This will cause trouble once CONFIG_COMPAT support is added
> to ebtables.
> xt_compat_*_offset() calculate the kernel/userland structure size delta
> using:
> 
> XT_ALIGN(size) - COMPAT_XT_ALIGN(size)
> 
> If the match/target sizes are aligned at registration time,
> delta is always zero.
> 
> Should have zero effect for existing systems: xtables uses
> XT_ALIGN() whenever it deals with match/target sizes.

Applied, thanks.

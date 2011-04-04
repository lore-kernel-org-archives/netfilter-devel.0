From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xt_conntrack: fix inverted conntrack direction
 test
Date: Mon, 04 Apr 2011 17:07:06 +0200
Message-ID: <4D99DE9A.8050408@trash.net>
References: <1301926740-22216-1-git-send-email-fwestphal@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fwestphal@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54161 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1DDPHM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:07:12 -0400
In-Reply-To: <1301926740-22216-1-git-send-email-fwestphal@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.04.2011 16:19, Florian Westphal wrote:
> --ctdir ORIGINAL matches REPLY packets, and vv:
> 
> userspace sets "invert_flags &= ~XT_CONNTRACK_DIRECTION" in ORIGINAL
> case.
> 
> Thus: (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) ^
>       !!(info->invert_flags & XT_CONNTRACK_DIRECTION))
> 
> yields "1 ^ 0", which is true -> returns false.
> 
> Reproducer:
> iptables -I OUTPUT 1 -p tcp --syn -m conntrack --ctdir ORIGINAL

Applied, thanks Florian.

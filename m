From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: ipt_addrtype: rename to xt_addrtype
Date: Tue, 08 Mar 2011 16:11:26 +0100
Message-ID: <4D76471E.8050503@trash.net>
References: <1299341328-4663-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60218 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab1CHPL2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:11:28 -0500
In-Reply-To: <1299341328-4663-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 05.03.2011 17:08, schrieb Florian Westphal:
> From: Florian Westphal <fwestphal@astaro.com>
> 
> followup patch will add ipv6 support.
> 
> Signed-off-by: Florian Westphal <fwestphal@astaro.com>
> ---
>  include/linux/netfilter/Kbuild                     |    1 +
>  .../ipt_addrtype.h => netfilter/xt_addrtype.h}     |   16 +++++-----

Please keep this file and the original definitions for a while
(add to feature-removal-schedule) for compatibility. You can
redefine them to the xt_ values/structures so they can be used
inside the kernel.

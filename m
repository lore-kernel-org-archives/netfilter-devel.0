From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 1/3] netfilter: af_info: add network namespace parameter
 to route hook
Date: Mon, 04 Apr 2011 16:57:09 +0200
Message-ID: <4D99DC45.4080708@trash.net>
References: <1300998597-2018-1-git-send-email-fw@strlen.de> <20110324.161510.57488462.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54011 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab1DDO5R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:57:17 -0400
In-Reply-To: <20110324.161510.57488462.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.03.2011 00:15, David Miller wrote:
>> > This is required to eventually replace the rt6_lookup call in xt_addrtype.c
>> > with nf_afinfo->route().
>> > 
>> > Signed-off-by: Florian Westphal <fw@strlen.de>
> Acked-by: David S. Miller <davem@davemloft.net>

Applied, thanks.

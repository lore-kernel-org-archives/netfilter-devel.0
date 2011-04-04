From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 3/3] netfilter: xt_addrtype: replace rt6_lookup with
 nf_afinfo->route
Date: Mon, 04 Apr 2011 17:02:26 +0200
Message-ID: <4D99DD82.3060501@trash.net>
References: <1300998597-2018-1-git-send-email-fw@strlen.de>	<1300998597-2018-3-git-send-email-fw@strlen.de> <20110324.161525.214209011.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54082 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab1DDPCc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:02:32 -0400
In-Reply-To: <20110324.161525.214209011.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.03.2011 00:15, David Miller wrote:
>> > This avoids pulling in the ipv6 module when using (ipv4-only) iptables -m addrtype.
>> > 
>> > Signed-off-by: Florian Westphal <fw@strlen.de>
> Acked-by: David S. Miller <davem@davemloft.net>

Also applied, thanks.

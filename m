From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 3/3] netfilter: xt_addrtype: replace rt6_lookup with
 nf_afinfo->route
Date: Thu, 24 Mar 2011 16:15:25 -0700 (PDT)
Message-ID: <20110324.161525.214209011.davem@davemloft.net>
References: <1300998597-2018-1-git-send-email-fw@strlen.de>
	<1300998597-2018-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54039
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934344Ab1CXXOq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:14:46 -0400
In-Reply-To: <1300998597-2018-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>
Date: Thu, 24 Mar 2011 21:29:57 +0100

> This avoids pulling in the ipv6 module when using (ipv4-only) iptables -m addrtype.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: David S. Miller <davem@davemloft.net>

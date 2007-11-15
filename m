From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER]: fix compat_nf_sockopt typo
Date: Thu, 15 Nov 2007 14:30:57 -0800 (PST)
Message-ID: <20071115.143057.141932099.davem@davemloft.net>
References: <473CC10D.2010305@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40692
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754567AbXKOWa5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:30:57 -0500
In-Reply-To: <473CC10D.2010305@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 15 Nov 2007 22:58:37 +0100

> [NETFILTER]: fix compat_nf_sockopt typo
> 
> It should pass opt to the ->get/->set functions, not ops.
> 
> Tested-by: Luca Tettamanti <kronos.it@gmail.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks a lot Patrick.

I double checked and it seems -stable doesn't need this,
only 2.6.24

Let me know if my analysis is incorrect.

Thanks again.

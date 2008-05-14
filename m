From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 2/2]: xt_iprange: module aliases for xt_iprange
Date: Tue, 13 May 2008 23:27:59 -0700 (PDT)
Message-ID: <20080513.232759.98005109.davem@davemloft.net>
References: <48297CA5.6030309@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43716
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbYENG2F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 02:28:05 -0400
In-Reply-To: <48297CA5.6030309@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 13 May 2008 13:33:57 +0200

> [NETFILTER]: xt_iprange: module aliases for xt_iprange
> 
> Using iptables 1.3.8 with kernel 2.6.25, rules which include '-m iprange'
> don't automatically pull in xt_iprange module.  Below patch adds module
> aliases to fix that.  Patch against latest -git, but seems like a good
> candidate for -stable also.
> 
> Signed-off-by: Phil Oester <kernel@linuxace.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied, thanks a lot.

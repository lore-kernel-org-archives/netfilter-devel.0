From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 03/03: xt_hashlimit: fix race between htable_destroy
 and htable_gc
Date: Thu, 31 Jul 2008 00:39:01 -0700 (PDT)
Message-ID: <20080731.003901.55306768.davem@davemloft.net>
References: <20080731063312.18150.49494.sendpatchset@localhost.localdomain>
	<20080731063316.18150.32852.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54651
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbYGaHjC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:39:02 -0400
In-Reply-To: <20080731063316.18150.32852.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 31 Jul 2008 08:33:16 +0200 (MEST)

> netfilter: xt_hashlimit: fix race between htable_destroy and htable_gc
> 
> Deleting a timer with del_timer doesn't guarantee, that the
> timer function is not running at the moment of deletion. Thus
> in the xt_hashlimit case we can get into a ticklish situation
> when the htable_gc rearms the timer back and we'll actually
> delete an entry with a pending timer.
> 
> Fix it with using del_timer_sync().
> 
> AFAIK del_timer_sync checks for the timer to be pending by
> itself, so I remove the check.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied, thanks.

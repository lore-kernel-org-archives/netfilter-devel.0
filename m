From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 05/06: fix double-free and use-after free
Date: Sat, 26 Jul 2008 17:49:44 -0700 (PDT)
Message-ID: <20080726.174944.10653380.davem@davemloft.net>
References: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
	<20080726233712.15283.88177.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56285
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756360AbYG0Atp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 20:49:45 -0400
In-Reply-To: <20080726233712.15283.88177.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 27 Jul 2008 01:37:14 +0200 (MEST)

> netfilter: fix double-free and use-after free
> 
> As suggested by Patrick McHardy, introduce a __krealloc() that doesn't
> free the original buffer to fix a double-free and use-after-free bug
> introduced by me in netfilter that uses RCU.
> 
> Reported-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Tested-by: Dieter Ries <clip2@gmx.de>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.

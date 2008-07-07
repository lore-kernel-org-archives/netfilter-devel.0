From: David Miller <davem@davemloft.net>
Subject: Re: Get rid of refrences to no longer existant Fast NAT.
Date: Mon, 07 Jul 2008 05:10:02 -0700 (PDT)
Message-ID: <20080707.051002.114744444.davem@davemloft.net>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
	<20080707120516.4975.88905.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57586
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbYGGMKC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:10:02 -0400
In-Reply-To: <20080707120516.4975.88905.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon,  7 Jul 2008 14:05:17 +0200 (MEST)

> Get rid of refrences to no longer existant Fast NAT.
> 
> IP_ROUTE_NAT support was removed in August of 2004, but references to Fast
> NAT were left in a couple of config options.
> 
> Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

I guess this is patch 02/13, right? :-)

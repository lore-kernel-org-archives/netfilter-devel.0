From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Tue, 29 Apr 2008 03:35:25 -0700 (PDT)
Message-ID: <20080429.033525.258726573.davem@davemloft.net>
References: <4816DF00.8060704@snapgear.com>
	<20080429.032008.163377774.davem@davemloft.net>
	<4816F6E7.5040009@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: philipc@snapgear.com, netfilter-devel@vger.kernel.org,
	rmk@arm.linux.org.uk
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47661
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754171AbYD2Kf1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:35:27 -0400
In-Reply-To: <4816F6E7.5040009@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 29 Apr 2008 12:22:31 +0200

> David Miller wrote:
> > Looks good to me, Patrick?
> 
> Yes, please apply. I'm travelling, so I can't test myself, but
> I'll also have a closer look once I return home. Thanks.

Ok, I've applied it, thanks.

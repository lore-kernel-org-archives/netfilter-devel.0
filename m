From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Tue, 29 Apr 2008 03:20:08 -0700 (PDT)
Message-ID: <20080429.032008.163377774.davem@davemloft.net>
References: <4816B5A1.8050906@snapgear.com>
	<4816B829.9080206@trash.net>
	<4816DF00.8060704@snapgear.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	rmk@arm.linux.org.uk
To: philipc@snapgear.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59040
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbYD2KUJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:20:09 -0400
In-Reply-To: <4816DF00.8060704@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Philip Craig <philipc@snapgear.com>
Date: Tue, 29 Apr 2008 18:40:32 +1000

> Patrick McHardy wrote:
> > I think the memset-solution is preferrable, using byte-wise
> > accesses to the entire tuple would really suck.
> 
> Here's the memset patch.

Looks good to me, Patrick?

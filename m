From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Mon, 28 Apr 2008 22:44:00 -0700 (PDT)
Message-ID: <20080428.224400.193700589.davem@davemloft.net>
References: <481589D2.2050901@snapgear.com>
	<4815D842.8010303@trash.net>
	<4816A89B.7050300@snapgear.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	rmk@arm.linux.org.uk
To: philipc@snapgear.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35349
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbYD2FoE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:44:04 -0400
In-Reply-To: <4816A89B.7050300@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Philip Craig <philipc@snapgear.com>
Date: Tue, 29 Apr 2008 14:48:27 +1000

> I prefer to remove the padding so that we don't change how other
> architectures work.  The attached patch does this.  I'm not sure
> if this has any performance penalties on ARM. 
> 
> The attribute(packed) is required on both the port structs
> and the unions.

It has performance penalties on most RISC architectures.

Now these elements cannot be assumed to have any particular
alignment, so gcc will emit byte-at-a-time accesses to these
elements.

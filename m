From: David Miller <davem@davemloft.net>
Subject: Re: kernel 2.6.25-rc7 highly unstable on high load
Date: Thu, 27 Mar 2008 15:03:08 -0700 (PDT)
Message-ID: <20080327.150308.205829519.davem@davemloft.net>
References: <47EBC641.8040405@cosmosbay.com>
	<20080327183745.M9944@visp.net.lb>
	<47EBEDC9.6080100@cosmosbay.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: denys@visp.net.lb, kaber@trash.net, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: dada1@cosmosbay.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55716
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758314AbYC0WDI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:03:08 -0400
In-Reply-To: <47EBEDC9.6080100@cosmosbay.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Thu, 27 Mar 2008 19:56:09 +0100

> Maybe some netfilter problem ?
> 
> Please tell us more about your machine ;)

I'm beginning to suspect it's IFB and shaping somehow.

If those variables could be eliminated by eliminating them
from the configuration, it would help diagnose this a lot.

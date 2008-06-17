From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 00/03: netfilter fixes
Date: Tue, 17 Jun 2008 15:53:21 -0700 (PDT)
Message-ID: <20080617.155321.221734712.davem@davemloft.net>
References: <20080617140351.1355.59710.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38999
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759335AbYFQWxX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:53:23 -0400
In-Reply-To: <20080617140351.1355.59710.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 17 Jun 2008 16:03:51 +0200 (MEST)

> following are three fixes for netfilter:
> 
> - fix for NAT RCU races related to ct_extend
> - fix for a memory leak in a H.323 module init error path
> - fix for a crash when unloading the H.323 module while H.245 expectation
>   or connections are active
> 
> Please apply, thanks.

Applied to net-2.6, and I'll push back out to kernel.org after some
build sanity checks.

Thanks!

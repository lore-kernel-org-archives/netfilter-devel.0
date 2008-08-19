From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 05/06: ctnetlink: sleepable allocation with spin
 lock bh
Date: Mon, 18 Aug 2008 21:31:53 -0700 (PDT)
Message-ID: <20080818.213153.238415631.davem@davemloft.net>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
	<20080818165154.18978.78109.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39651
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbYHSEbx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:31:53 -0400
In-Reply-To: <20080818165154.18978.78109.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 18 Aug 2008 18:51:55 +0200 (MEST)

> netfilter: ctnetlink: sleepable allocation with spin lock bh
> 
> This patch removes a GFP_KERNEL allocation while holding a spin lock with
> bottom halves disabled in ctnetlink_change_helper().
> 
> This problem was introduced in 2.6.23 with the netfilter extension
> infrastructure.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.

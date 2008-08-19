From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 04/06: ctnetlink: fix sleep in read-side lock section
Date: Mon, 18 Aug 2008 21:31:32 -0700 (PDT)
Message-ID: <20080818.213132.88034681.davem@davemloft.net>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
	<20080818165153.18978.28019.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39648
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbYHSEbd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:31:33 -0400
In-Reply-To: <20080818165153.18978.28019.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 18 Aug 2008 18:51:54 +0200 (MEST)

> netfilter: ctnetlink: fix sleep in read-side lock section
> 
> Fix allocation with GFP_KERNEL in ctnetlink_create_conntrack() under
> read-side lock sections.
> 
> This problem was introduced in 2.6.25.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks.

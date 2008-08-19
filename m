From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 03/06: ctnetlink: fix double helper assignation for
 NAT'ed conntracks
Date: Mon, 18 Aug 2008 21:31:09 -0700 (PDT)
Message-ID: <20080818.213109.05805895.davem@davemloft.net>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
	<20080818165151.18978.90816.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39645
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbYHSEbJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:31:09 -0400
In-Reply-To: <20080818165151.18978.90816.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 18 Aug 2008 18:51:52 +0200 (MEST)

> netfilter: ctnetlink: fix double helper assignation for NAT'ed conntracks
> 
> If we create a conntrack that has NAT handlings and a helper, the helper
> is assigned twice. This happens because nf_nat_setup_info() - via
> nf_conntrack_alter_reply() - sets the helper before ctnetlink, which
> indeed does not check if the conntrack already has a helper as it thinks that
> it is a brand new conntrack.
> 
> The fix moves the helper assignation before the set of the status flags.
> This avoids a bogus assertion in __nf_ct_ext_add (if netfilter assertions are
> enabled) which checks that the conntrack must not be confirmed.
> 
> This problem was introduced in 2.6.23 with the netfilter extension
> infrastructure.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Aplied.

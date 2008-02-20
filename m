From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/07]: Netfilter fixes
Date: Tue, 19 Feb 2008 17:25:15 -0800 (PST)
Message-ID: <20080219.172515.143081394.davem@davemloft.net>
References: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57234
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752382AbYBTBYi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:24:38 -0500
In-Reply-To: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 19 Feb 2008 17:25:44 +0100 (MET)

> following are a few netfilter fixes for 2.6.25, fixing a BUG() when
> mangling non-linear skbs in {ip,ip6,nfnetlink}_queue, a compilation
> error in busybox, IPv6 address range matching in xt_iprange, missing
> unidef'ing of xt_policy.h. Additionally there is a patch to remove
> an unnecessary member from the xt_hashlimit matchinfo, which we need
> to do know before it hits a release.
> 
> Please apply, thanks.

All applied, thanks Patrick.

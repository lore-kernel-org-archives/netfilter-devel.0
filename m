From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/69]: Netfilter Update
Date: Thu, 31 Jan 2008 04:56:00 -0800 (PST)
Message-ID: <20080131.045600.101123303.davem@davemloft.net>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43387
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754331AbYAaMzj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:55:39 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 30 Jan 2008 21:16:52 +0100 (MET)

> following is the final netfilter update for 2.6.25. containing the iptables
> netns work by Alexey Dobriyan, lots of sparse warning fixes by Stephen, Eric
> and myself, const annotations throughout netfilter by Jan Engelhardt,
> a set of patches to finally use RCU for the conntrack and NAT hashes, some
> conntrack optimizations and some minor misc cleanups.

All applied, thanks Patrick.

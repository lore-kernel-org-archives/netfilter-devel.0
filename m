From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/49]: Netfilter update
Date: Wed, 05 Dec 2007 01:35:29 -0800 (PST)
Message-ID: <20071205.013529.41086001.davem@davemloft.net>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39656
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbXLEJfa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:35:30 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue,  4 Dec 2007 13:01:54 +0100 (MET)

> following is the first batch of my netfilter patches for 2.6.25,
> containing (among other things) some x_tables unification patches
> for the owner and tos matches and the TOS target, and new
> TCPOPTSTRIP target to strip away TCP options as workaround for
> broken firewalls, a new RATEEST target + rateest match for rate
> estimation, a large queueing cleanup and some optimizations and
> a few patches to remove runtime dependencies of x_tables modules
> and the H.323 helper on IPv6 modules. The CONFIG_NETFILTER_ADVANCED
> patch is not included yet since I'm not entirely happy with it.

All applied and pushed out, thanks a lot Patrick.

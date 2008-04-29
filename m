From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/03]: Netfilter fixes
Date: Tue, 29 Apr 2008 03:16:51 -0700 (PDT)
Message-ID: <20080429.031651.141136499.davem@davemloft.net>
References: <20080428220643.18270.24909.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59026
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbYD2KQw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:16:52 -0400
In-Reply-To: <20080428220643.18270.24909.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 29 Apr 2008 00:06:40 +0200 (MEST)

> these three patches fix (again) skb_over_panic caused by netfilter queueing,
> a namespace leak when reading /proc/net/xxx_tables_names and incorrect error
> handling in the TCPOPTSTRIP target.
> 
> Please apply, thanks.

All 3 patches applied, thanks Patrick.

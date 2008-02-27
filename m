From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 05/05]: Fix NF_QUEUE_NR() parenthesis
Date: Wed, 27 Feb 2008 12:21:27 -0800 (PST)
Message-ID: <20080227.122127.85405542.davem@davemloft.net>
References: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
	<20080227131434.26831.91147.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51947
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbYB0UV2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:21:28 -0500
In-Reply-To: <20080227131434.26831.91147.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 27 Feb 2008 14:14:26 +0100 (MET)

> [NETFILTER]: Fix NF_QUEUE_NR() parenthesis
> 
> Properly add parens around the macro argument. This is not needed by
> the kernel but the macro is exported to userspace, so it shouldn't
> make any assumptions.
> 
> Also use NF_VERDICT_BITS instead of NF_VERDICT_QBTIS for the left-shift
> since thats whats logically correct.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks.

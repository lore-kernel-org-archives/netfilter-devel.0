From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] nefilter: use pr_devel instead of pr_debug
Date: Thu, 22 Apr 2010 04:00:26 -0700 (PDT)
Message-ID: <20100422.040026.102028104.davem@davemloft.net>
References: <1271856071-32179-2-git-send-email-jengelh@medozas.de>
	<4BD02914.9030100@trash.net>
	<alpine.LSU.2.01.1004221248010.31972@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49768
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753882Ab0DVLAW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:00:22 -0400
In-Reply-To: <alpine.LSU.2.01.1004221248010.31972@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Thu, 22 Apr 2010 12:53:38 +0200 (CEST)

> On Thursday 2010-04-22 12:46, Patrick McHardy wrote:
> Once upon a time, most of the Netfilter debug statements read like:
> 
> #ifdef TURNMEON
> #define duprintf(...) printk(...)
> #else
> #define duprintf(...)
> #endif
> 
> So the intention was to have a behavior that requires a developer to 
> explicitly turn on debugging in source code. By adding a line like 
> #define IP_DEBUG_FIREWALL at the start. (I explicitly exclude 
> blocks like #ifdef CONFIG_ in this consideration.)
> 
> When pr_debug became available, parts of the netfilter code moved to 
> pr_debug, as that behaved just the same - the only change was that the 
> variable was now named DEBUG across the entire kernel source rather than 
> IP_DEBUG_FIREWALL - whatever the actual name was.

Jan, things are even better now.  With dynamic debug enabled you can
select down to the source file and line which debug printk you want
enabled.

No functionality has been removed, in fact you have more control
over the situation now, not less.

Eventually it will probably be even more efficient by using dynamic
code patching as well.

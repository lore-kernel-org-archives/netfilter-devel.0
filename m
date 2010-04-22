From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] nefilter: use pr_devel instead of pr_debug
Date: Thu, 22 Apr 2010 13:00:24 +0200
Message-ID: <4BD02C48.6060904@trash.net>
References: <1271856071-32179-1-git-send-email-jengelh@medozas.de> <1271856071-32179-2-git-send-email-jengelh@medozas.de> <4BD02914.9030100@trash.net> <alpine.LSU.2.01.1004221248010.31972@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63136 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0DVLAa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:00:30 -0400
In-Reply-To: <alpine.LSU.2.01.1004221248010.31972@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-04-22 12:46, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Netfilter traditionally used debug prints that were omitted unless
>>> someone explicitly defined DEBUG. Recently that has no longer been the
>>> case (see explanation in commit v2.6.30-rc2-184-g4ccb457). Switch our
>>> pr_debug calls to pr_devel.
>> The intention of CONFIG_DYNAMIC_DEBUG is exactly to make those debug
>> statements available dynamically. I presume the mentioned distribution
>> had a reason to enable that option. Why should we undermine that by
>> turning debug statements into "devel" statements?
> 
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
> 
> Enter pr_devel, which suddenly turned all pr_debug calls into pieces 
> that would expand despite DEBUG being undefined - and that seemed 
> contrary to the original intent.

The code is only expanded when CONFIG_DYNAMIC_DEBUG is enabled. Which
is exactly what this option is there for.

I've noticed you already included a few pr_devel() statements in a
recent submission. I'd rather convert those to pr_debug()

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-failover] [conntrack-utils PATCH r7254 04/14] fix	misoptimization
 for	next_alarm calculation
Date: Mon, 21 Jan 2008 01:05:32 +0100
Message-ID: <4793E1CC.2010300@netfilter.org>
References: <20080118104935.4444.26673.stgit@woodpecker.roonstrasse.net> <20080118105309.4444.78574.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-failover@lists.netfilter.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42114 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754351AbYAUAFv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:05:51 -0500
In-Reply-To: <20080118105309.4444.78574.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> do_alarm_run() determines the next_alarm time.  there is however a
> condition where this result comes wrong, because of "unsafe" side
> effects of list_for_each_entry_safe().  Example: imagine there are two
> alarms: A is due now, and B is due in 5 minutes.
> 
> When do_alarm_run() runs alarm A, list_for_each_entry_safe() remembers
> B as the alarm for the next loop iteration.
> 
> Now A re-schedules itself in 1 minute.  It is again the first entry in
> the alarm_list queue, but list_for_each_entry_safe() will not handle
> it in this loop.
> 
> Instead, do_alarm_run() sees B and returns "5 minutes" as the
> next_alarm time.
> 
> Solve this by breaking from the loop when a late event is detected,
> and letting get_next_alarm() do all the work.

Good point. I noticed this while rewriting the alarm scheduler, in the
rewrite it should handle this case correctly.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

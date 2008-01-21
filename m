From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-failover] [conntrack-utils PATCH r7254 08/14] check alarms
 even	if select()!=0
Date: Mon, 21 Jan 2008 01:10:53 +0100
Message-ID: <4793E30D.7040002@netfilter.org>
References: <20080118104935.4444.26673.stgit@woodpecker.roonstrasse.net> <20080118105309.4444.39660.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-failover@lists.netfilter.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43144 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754424AbYAUALB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:11:01 -0500
In-Reply-To: <20080118105309.4444.39660.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> It is not documented that select() always returns 0 when the timeout
> expires - the timeout may expire, and there may be events on file
> descriptors at the same time.  Don't check the select() return value,
> check timerisset(next_alarm) instead, and always update next_alarm
> with get_next_alarm()

Indeed, good point. This was fixed in r7260.

> Also the old code never checked for new alarms which were added during
> the file descriptor handlers.

Same thing.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFCT ulogd pluging [was Re: [ULOGD RFC 11/30] NFCT: make reconfigurable]
Date: Wed, 30 Jan 2008 20:51:23 +0100
Message-ID: <47A0D53B.4090103@trash.net>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190127.847510508@kruemel.intranet.astaro.de> <47A0D063.7040807@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>, heitzenberger@astaro.com,
	netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59840 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbYA3Tv7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:51:59 -0500
In-Reply-To: <47A0D063.7040807@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hi,
>
> JFYI: conntrackd also does connection tracking accounting so I'm not
> sure if ulogd should do this as well via the NFCT plugin. This looks
> like duplicated effort IMO and, as for now, conntrackd also provides
> userspace conntrack table dumping without locking the kernel via
> `conntrackd -i' which is a feature that ulogd does not provide.
>   

Mhh .. I'm not sure how that is duplicated effort, we're talking about
two different programs that do completely different things.

Locking is not an issue BTW, I have patches queued which finally
move conntrack to RCU.


From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: Re: NFCT ulogd pluging [was Re: [ULOGD RFC 11/30] NFCT: make reconfigurable]
Date: Wed, 30 Jan 2008 22:04:08 +0100
Message-ID: <47A0E648.1020709@astaro.com>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190127.847510508@kruemel.intranet.astaro.de> <47A0D063.7040807@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@vger.kernel.org, holger@eitzenberger.org,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-17.dex002.intermedia.net ([64.78.21.83]:40810 "EHLO
	dhost002-17.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbYA3VEO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:04:14 -0500
In-Reply-To: <47A0D063.7040807@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:

> JFYI: conntrackd also does connection tracking accounting so I'm not
> sure if ulogd should do this as well via the NFCT plugin. This looks
> like duplicated effort IMO and, as for now, conntrackd also provides
> userspace conntrack table dumping without locking the kernel via
> `conntrackd -i' which is a feature that ulogd does not provide.

Hi Pablo,

yes, I know that conntrackd does that, but for a different audience. 
Also, can conntrackd write a SQLITE database too?

IMO the strong point in favour of ulogd is its flexibility.  Want 
Postgres as a backend?  Or a plain text file?  Not a problem, just 
change the config file.

   /holger



From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFCT ulogd pluging [was Re: [ULOGD RFC 11/30] NFCT: make reconfigurable]
Date: Fri, 01 Feb 2008 02:17:25 +0100
Message-ID: <47A27325.10301@netfilter.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190127.847510508@kruemel.intranet.astaro.de> <47A0D063.7040807@netfilter.org> <47A0E648.1020709@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@vger.kernel.org, holger@eitzenberger.org,
	Patrick McHardy <kaber@trash.net>
To: Holger Eitzenberger <heitzenberger@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38370 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934882AbYBABRe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:17:34 -0500
In-Reply-To: <47A0E648.1020709@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> Pablo Neira Ayuso wrote:
> 
>> JFYI: conntrackd also does connection tracking accounting so I'm not
>> sure if ulogd should do this as well via the NFCT plugin. This looks
>> like duplicated effort IMO and, as for now, conntrackd also provides
>> userspace conntrack table dumping without locking the kernel via
>> `conntrackd -i' which is a feature that ulogd does not provide.
> 
> yes, I know that conntrackd does that, but for a different audience.
> Also, can conntrackd write a SQLITE database too?
> 
> IMO the strong point in favour of ulogd is its flexibility.  Want
> Postgres as a backend?  Or a plain text file?  Not a problem, just
> change the config file.

Indeed. This makes sense.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

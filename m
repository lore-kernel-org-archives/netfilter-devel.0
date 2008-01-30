From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: NFCT ulogd pluging [was Re: [ULOGD RFC 11/30] NFCT: make reconfigurable]
Date: Wed, 30 Jan 2008 20:30:43 +0100
Message-ID: <47A0D063.7040807@netfilter.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190127.847510508@kruemel.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org,
	holger@eitzenberger.org, Patrick McHardy <kaber@trash.net>
To: Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49066 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751281AbYA3TbE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:31:04 -0500
In-Reply-To: <20080130190127.847510508@kruemel.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

JFYI: conntrackd also does connection tracking accounting so I'm not
sure if ulogd should do this as well via the NFCT plugin. This looks
like duplicated effort IMO and, as for now, conntrackd also provides
userspace conntrack table dumping without locking the kernel via
`conntrackd -i' which is a feature that ulogd does not provide.

I'm not sure if the effort is worth, Harald?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

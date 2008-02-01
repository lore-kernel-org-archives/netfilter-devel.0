From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD RFC 08/30] NFCT: rework
Date: Fri, 01 Feb 2008 02:23:13 +0100
Message-ID: <47A27481.7080700@netfilter.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190127.400747893@kruemel.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60789 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753713AbYBABXa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:23:30 -0500
In-Reply-To: <20080130190127.400747893@kruemel.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> Also implement garbage collection to account for the fact that netlink
> messages are sometimes lost (ENOBUFS) on busy sites.

Well, this NFCT stuff is a big hack. I'm sure that you have solved
several issues with those patches but sorry, I don't like them at all.
There's several parts of conntrackd that we could use to rework this eg.
an implementation of a generic hash table in conntrackd that we can
reuse and nfnl_recv_msgs looks very similar to nfnl_catch, etc. Also,
the ENOBUFS handling is still a mess. I'm better keeping back these NFCT
patches. I'll try to give some spins to it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

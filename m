From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD RFC 07/30] Renice to -1 on startup
Date: Fri, 01 Feb 2008 08:19:09 +0100
Message-ID: <47A2C7ED.6060106@trash.net>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <20080130190127.273612103@kruemel.intranet.astaro.de> <47A2965A.6090504@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org,
	holger@eitzenberger.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39141 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbYBAHTP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:19:15 -0500
In-Reply-To: <47A2965A.6090504@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> heitzenberger@astaro.com wrote:
>> Thus possibly preventing e.g. ctnetlink from overruns on busy sites.
> 
> Also interesting, do you really observe a real improvement? I'll try
> this with conntrackd tomorrow in my testbed.


I noticed huge differences in nfnetlink_queue performance by renicing,
which is a clear indication of insufficient buffer space in the
socker receive queue (in case of nfnetlink_queue actually receive
queue size *or* kernel queue size). The buffers have to be dimensioned
large enough to catch userspace latency fluctuations, so the proper
fix is most likely to simply increase the receive queue size.

Which reminds me, for nfnetlink_queue we should think about providing
a mechanism to automatically size both kernel queue and socket receive
buffers properly or at least measure latencies.


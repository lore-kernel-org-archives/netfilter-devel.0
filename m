From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: conntrack: remove timer from ecache
 extension
Date: Thu, 5 Jun 2014 16:33:11 +0200
Message-ID: <20140605143311.GA24460@localhost>
References: <1400751788-7923-1-git-send-email-fw@strlen.de>
 <1400751788-7923-3-git-send-email-fw@strlen.de>
 <20140605142549.GA24216@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58708 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFEOdU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:33:20 -0400
Content-Disposition: inline
In-Reply-To: <20140605142549.GA24216@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 05, 2014 at 04:25:49PM +0200, Pablo Neira Ayuso wrote:
> I tried two different tests:
> 
> 1) Normal conntrackd sync configuration, with reliable events. My
> testbed is composed of three machines, the client, the firewall and
> the server. I generated lots of small HTTP connections from the client
> to the server through the firewall. Things were working quite fine, I
> could see ~8% of CPU consumption in the workqueue thread, probably due
> to retransmission. The dying list remained also empty.
> 
> 2) Stress scenario. I have set a very small receive buffer size via
> NetlinkBufferSize and NetlinkBufferSizeMaxGrowth (I set it to 1024,
> which results in slightly more). The idea is that just very little
> events can be delivered at once and we don't leak events/entries.
> 
> For this test, I generated something like ~60000 conntrack entries
> (with wget --spider) during very short time, and then I run 'conntrack -F'
> so all the entries try to get out from at the same time.
> 
> In one test, I noticed around ~75 entries stuck in the dying list. In
> another test, I noticed conntrackd -i | wc -l showed one entry that
> got stuck in the cache, which was not in the dying list. I suspect
> some problem in the retransmission logic.

Another interesting information. If I generate new entries that get
stuck in the dying list because of undelivered events, the worker
seems to give another chance to deliver, and the entries that were
stuck are not there anymore.

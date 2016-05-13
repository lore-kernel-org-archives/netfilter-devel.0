From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/7] flow statement
Date: Fri, 13 May 2016 20:12:45 +0200
Message-ID: <20160513181245.GA23428@salvia>
References: <1461756590-22880-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35961 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbcEMSNF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 May 2016 14:13:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9E10D1EFDA4
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 20:13:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8C51D2687D9
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 20:13:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7D82B2687D9
	for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 20:13:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1461756590-22880-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 27, 2016 at 12:29:43PM +0100, Patrick McHardy wrote:
> The following patches add the "flow" statement to dynamically instantiate
> stateful expression for each user defined flow. This can currently be used
> for per flow accounting and per flow rate limiting, similar to what hashlimit
> provides, but with a much more flexible definition of a flow.
> 
> Examples:
> 
> # Per flow accounting
> $ nft filter input flow table acct ip saddr . ip daddr counter
> 
> # Host rate limiting for each port
> $ nft filter input flow ip saddr . tcp dport timeout 60s limit rate 10/second
> 
> The tables are so far not shown in the ruleset output, but can be displayed
> using "nft list set". This will not be a permanent solution, the plan is to
> add new commands for flow tables that will display them in a more structured
> fashion and allow sorting by individual keys or parts of the per flow statment,
> f.i. the counters. However this requires some rather large changes to how
> nft prints data and needs more work, so the intention is to merge this part
> now and add the output part once it is finished.
> 
> Comments and testing welcome.

Series applied.

I had to rebased the test updates to get this applying to current git HEAD.

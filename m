From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/4, V3, nft] Simplify parser rule_spec tree
Date: Fri, 12 Aug 2016 14:11:39 +0200
Message-ID: <20160812121139.GA13855@salvia>
References: <20160808144834.GB6264@salvia>
 <20160810094857.14227-1-carlosfg@riseup.net>
 <20160810094857.14227-3-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55432 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbcHLMLo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 08:11:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 62EFAD162B
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 14:11:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 547996DB36
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 14:11:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 57EDE7E077
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 14:11:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160810094857.14227-3-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 11:48:56AM +0200, Carlos Falgueras García wrote:
> This patch separates the rule identification from the rule localization, so
> the logic moves from the evaluator to the parser. This allows to revert the
> patch "evaluate: improve rule managment checks"
> (4176c7d30c2ff1b3f52468fc9c08b8df83f979a8) and saves a lot of code.
> 
> An specific error message is shown when user commits a syntax error, as
> before this patch:
> 
> 	$ nft add rule t c handle ip saddr 1.1.1.1 counter
> 	<cmdline>:1:14-19: Error: syntax error, unexpected handle
> 	add rule t c handle ip saddr 1.1.1.1 counter
> 	             ^^^^^^
> 	<cmdline>:1:14-19: Error: Expected `position' or nothing
> 	add rule t c handle ip saddr 1.1.1.1 counter

I get a double error with this, which is odd:

# nft add rule t c handle ip saddr 1.1.1.1 counter
<cmdline>:1:14-19: Error: syntax error, unexpected handle
add rule t c handle ip saddr 1.1.1.1 counter
             ^^^^^^
<cmdline>:1:14-19: Error: Expected `position' or nothing
add rule t c handle ip saddr 1.1.1.1 counter
             ^^^^^^

We don't have any similar behaviour in our existing code that I can
remember.

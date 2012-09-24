From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libxt_time: add support to ignore day transition
Date: Mon, 24 Sep 2012 14:40:17 +0200
Message-ID: <20120924124017.GA30792@1984>
References: <1347877389-15728-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47052 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab2IXMkY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:40:24 -0400
Content-Disposition: inline
In-Reply-To: <1347877389-15728-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 17, 2012 at 12:23:08PM +0200, Florian Westphal wrote:
> Currently, if you want to do something like:
> "match Monday, starting 23:00, for two hours"
> You need two rules, one for Mon 23:00 to 0:00 and one for Tue 0:00-1:00.
> The rule
> --weekdays Mo --timestart 23:00  --timestop 01:00
> looks correct, but it will first match on monday from midnight to 1 a.m.
> and then again for another hour from 23:00 onwards.
> 
> This permits userspace to explicitly ignore the day transition and
> match for a single, continuous time period instead.

Applied to the iptables-linux-3.7 branch.

Will merge this to master once linux-3.7-rc1 is released.

Thanks Florian.

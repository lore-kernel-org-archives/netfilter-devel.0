From: Simon Lodal <simonl@parknet.dk>
Subject: Re: xt2 table core
Date: Fri, 2 Jul 2010 05:32:12 +0200
Message-ID: <201007020532.12596.simonl@parknet.dk>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cuda.parknet.dk ([84.238.112.40]:38754 "EHLO cuda.parknet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab0GBDoX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Jul 2010 23:44:23 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tirsdag 29 juni 2010 10:42:40 skrev Jan Engelhardt:
> Hi,
> 
> 
> This patchset adds the xtables2 main proper, and incrementally
> changes ip6_tables to use it. There are more patches for iptables
> and arptables and, but to not make it larger than needed, just this
> much for now.
> 
> Previously featured on http://lwn.net/Articles/345176/ .
> 
> The full piece is in the xt2-20100629 branch and would look like:
>   38 files changed, 3361 insertions(+), 5644 deletions(-)
>   [40% reduction; the remaining 10% were merged already]
> 
> 
> Please leave some comments!

Nice to see some new development! Guess we all have a long wishlist that is 
hard to implement in the current design, and this may make it easier.

But what about performance? I think all these lists must cause a huge amount 
of jumps in hot path (eg. filtering packets). The packed blob format is hard to 
work with, but once created it is efficient. Do you have any expectations or 
even numbers on the performance?


Simon

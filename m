From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 nf] netfilter: x_tables: speed up jump target
 validation
Date: Thu, 14 Jul 2016 20:07:52 +0200
Message-ID: <20160714180752.GA1471@salvia>
References: <1468511486-17283-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49413 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbcGNSH5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2016 14:07:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E32022519AB
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 20:07:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D45EF9EBBD
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 20:07:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D0DAF9EBBD
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 20:07:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468511486-17283-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 14, 2016 at 05:51:26PM +0200, Florian Westphal wrote:
> The dummy ruleset I used to test the original validation change was broken,
> most rules were unreachable and were not tested by mark_source_chains().
>
> In some cases rulesets that used to load in a few seconds now require
> several minutes.

Thanks for fixing this so fast. I was a bit surprised this O(n!)
validation was only taking 11% more time when you first posted this
patchset.

> sample ruleset that shows the behaviour:
> 
> echo "*filter"
> for i in $(seq 0 100000);do
>         printf ":chain_%06x - [0:0]\n" $i
> done
> for i in $(seq 0 100000);do
>    printf -- "-A INPUT -j chain_%06x\n" $i
>    printf -- "-A INPUT -j chain_%06x\n" $i
>    printf -- "-A INPUT -j chain_%06x\n" $i
> done
> echo COMMIT

Not exactly related to this patch.

As I said in the workshop, I would really to love to see more tests in
our trees.

Is there any chance you can get reuse that tests/shell/ directory that
Arturo made for nftables and place this in one of those scripts? You
can inagurate it with this scripts, and others that you used to fix
the lack of sanity checks (those actually would require some little C
code though).

With something like this in place, we can all validate better that
tests are not broken and catch regressions.

Thanks!

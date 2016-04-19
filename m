From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC nf-next 0/3] named expressions for nf_tables
Date: Tue, 19 Apr 2016 21:46:38 +0200
Message-ID: <20160419194638.GA7710@salvia>
References: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
 <570BC27F.9080409@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40818 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbcDSTqv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2016 15:46:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id ECE76C9EC2
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2016 21:46:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D9FAFC21AF
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2016 21:46:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B71669D0F0
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2016 21:46:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <570BC27F.9080409@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Andreas,

On Mon, Apr 11, 2016 at 05:27:59PM +0200, Andreas Schultz wrote:
> Would this support to have rules based on the value of a counter and/or
> the current rate (like quotas in nfacct)?
> 
> something like this:
> 
> nft add rule filter tcp-chain counter name tcp-counter bytes > 10000 jump deny
>
> A more realistic setup might more look like:
> 
> table ip filter {
>          counter counter-user1234 {
>                  packets 6086 bytes 6278052
>          }
> 
>          chain chain-user1234 {
>                  counter name counter-user1234
> 		 counter name counter-user1234 > 10000000 goto chain-user1234-overlimit
> 		 counter name counter-user1234 > 500000 goto rate-limit
> 		 accept
>          }
> 
>          chain chain-user1234-overlimit {
>                  do-once notify userspace somehow
> 		 reject
>          }

I think we can express this with:

        nft add limit counter-user1234 rate over 100 mbytes/day
        nft add rule filter input \
                limit name counter-user1234 \
                log prefix "user1234" group 10 \
                reject

The idea is to create a 'counter-user1234' limit. Then refer to this
from the rule.

BTW, currently the 'reject' statement will rely on icmp unreach to
reject this. Probably you want a plain 'drop' here.

> As far as I know there is currently no mechanism in nft that could do
> the "do-once notify userspace somehow", or is there???

You can do this through the log statement, and then use
libnetfilter_log for your application.

> The other issue I have with such a scheme that it requires lots of chains per
> client and might limit the number of clients that could be supported.

I think we can skip the extra non-base chains in the example above.
The question is if you would be OK by specifying the quota using
ratelimit, opposed to counter.

The idea is that you can reset limits with something like:

        nft reset limit name user1234

so this basically resets the quota. Or even upgrade via:

        nft update limit name user1234 over 1000 mbytes/day

(this would keep what it's been consumed already, so statefulness is
preserved).

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: x_tables: ratelimit most printks
Date: Wed, 14 Feb 2018 20:49:03 +0100
Message-ID: <20180214194903.lxl7xwedby6gvjnh@salvia>
References: <20180207134828.18691-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34082 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162994AbeBNTtH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 14:49:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 26334FFB61
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:49:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14CD0DA789
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:49:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180207134828.18691-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 07, 2018 at 02:48:21PM +0100, Florian Westphal wrote:
> Aeons ago, before namespaces, there was no need to ratelimit this:
> all of these error messages got triggered in response to iptables
> commands, which need CAP_NET_ADMIN.
> 
> Nowadays we have namespaces, so its better to ratelimit these.
> This should also help fuzzing (syzkaller), as it can generate a large
> volume of error messages (which are useless there).
> 
> The patches are split as follows:
> - first get rid of printks that should never be triggered, as userland
>   doesn't generate such malformed rules anyway.
> - second, switch some printks to pr_debug.  This is mostly for messages
>   where it might make sense for developers to see what exactly went
>   wrong.
> 
> Rest of the patches swap remaining pr_foo with pr_foo_ratelimited().
> 
> Note that most patches introduce overly long lines, but splitting these
> would make it necessary to split the error messages which is worse.
> 
> 46 files changed, 254 insertions(+), 257 deletions(-)

Series applied, thanks Florian.

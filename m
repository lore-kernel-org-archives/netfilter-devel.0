From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,1/4] netfilter: conntrack: don't cache
 nlattr_tuple_size result in nla_size
Date: Mon, 6 Nov 2017 16:18:30 +0100
Message-ID: <20171106151830.GB21167@salvia>
References: <20171102184112.32584-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41978 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752245AbdKFPSl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 10:18:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3330D1B8406
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:18:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24268DA86E
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:18:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171102184112.32584-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 02, 2017 at 18:41:09PM +0100, Florian Westphal wrote:
> We currently call ->nlattr_tuple_size() once at register time and
> cache result in l4proto->nla_size.
>
> nla_size is the only member that is written to, avoiding this would
> allow to make l4proto trackers const.
>
> We can use ->nlattr_tuple_size() at run time, and cache result in
> the individual trackers instead.
>
> This is an intermediate step, next patch removes nlattr_size()
> callback and computes size at compile time, then removes nla_size.

Florian, I can only see this one in this series via patchwork:

http://patchwork.ozlabs.org/patch/833477/

Please, resend the three remaining patches so I can apply them.

Sorry for the inconvenience.

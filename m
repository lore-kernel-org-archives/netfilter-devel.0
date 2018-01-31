From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: on sockopt() acquire sock lock only in
 the required scope
Date: Wed, 31 Jan 2018 16:39:32 +0100
Message-ID: <20180131153932.xuujohoomcrmp4ch@salvia>
References: <590fca0265dd06aa75e124fdbce29486b58a7b25.1517335086.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49270 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932085AbeAaPjk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jan 2018 10:39:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 90A2F1176A8
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jan 2018 16:39:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82702DA387
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jan 2018 16:39:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <590fca0265dd06aa75e124fdbce29486b58a7b25.1517335086.git.pabeni@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 30, 2018 at 07:01:40PM +0100, Paolo Abeni wrote:
> Syzbot reported several deadlocks in the netfilter area caused by
> rtnl lock and socket lock being acquired with a different order on
> different code paths, leading to backtraces like the following one:
[...]
> The problem, as Florian noted, is that nf_setsockopt() is always
> called with the socket held, even if the lock itself is required only
> for very tight scopes and only for some operation.

Applied, thanks Paolo.

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch net v2] ipt_CLUSTERIP: fix a refcount bug in
 clusterip_config_find_get()
Date: Wed, 14 Feb 2018 20:50:39 +0100
Message-ID: <20180214195039.p3p4jjnzwqkjgokb@salvia>
References: <20180208215352.8294-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pabeni@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34506 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163043AbeBNTun (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 14:50:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4AA78FFB64
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:50:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3AF47DA729
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:50:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180208215352.8294-1-xiyou.wangcong@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 08, 2018 at 01:53:52PM -0800, Cong Wang wrote:
> In clusterip_config_find_get() we hold RCU read lock so it could
> run concurrently with clusterip_config_entry_put(), as a result,
> the refcnt could go back to 1 from 0, which leads to a double
> list_del()... Just replace refcount_inc() with
> refcount_inc_not_zero(), as for c->refcount.

Applied, thanks Cong.

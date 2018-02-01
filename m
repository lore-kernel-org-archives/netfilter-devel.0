From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/6] Netfilter fixes for net
Date: Thu, 01 Feb 2018 14:45:44 -0500 (EST)
Message-ID: <20180201.144544.1810952791328890164.davem@davemloft.net>
References: <20180201180217.24356-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:49884 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752838AbeBATps (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Feb 2018 14:45:48 -0500
In-Reply-To: <20180201180217.24356-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu,  1 Feb 2018 19:02:11 +0100

> The following patchset contains Netfilter fixes for your net tree,
> they are:
> 
> 1) Fix OOM that syskaller triggers with ipt_replace.size = -1 and
>    IPT_SO_SET_REPLACE socket option, from Dmitry Vyukov.
> 
> 2) Check for too long extension name in xt_request_find_{match|target}
>    that result in out-of-bound reads, from Eric Dumazet.
> 
> 3) Fix memory exhaustion bug in ipset hash:*net* types when adding ranges
>    that look like x.x.x.x-255.255.255.255, from Jozsef Kadlecsik.
> 
> 4) Fix pointer leaks to userspace in x_tables, from Dmitry Vyukov.
> 
> 5) Insufficient sanity checks in clusterip_tg_check(), also from Dmitry.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.

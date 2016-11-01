From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 01/22] netfilter: ipset: Correct
 rcu_dereference_bh_nfnl() usage
Date: Tue, 1 Nov 2016 20:13:04 +0100
Message-ID: <20161101191304.GA18827@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1477255075-15255-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50864 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbcKATNM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:13:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 67E1A168397
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:13:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59122BAC2D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:13:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD652BAC2B
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:13:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:34PM +0200, Jozsef Kadlecsik wrote:
> When rcu_dereference_bh_nfnl() macro would be defined on the target
> system it will accept pointer and subsystem id.
> 
> Check if rcu_dereference_bh_nfnl() is defined and make it accepting two
> arguments.
> 
> Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.
> 
> Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  net/netfilter/ipset/ip_set_hash_gen.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index d32fd6b..bc54be4 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -17,7 +17,9 @@
>  #define ipset_dereference_protected(p, set) \
>  	__ipset_dereference_protected(p, spin_is_locked(&(set)->lock))
>  
> -#define rcu_dereference_bh_nfnl(p)	rcu_dereference_bh_check(p, 1)
> +#ifndef rcu_dereference_bh_nfnl

Why this new ifndef? I guess this has to be with the ipset bundle that
you release as standalone module.

> +#define rcu_dereference_bh_nfnl(p, ss)	rcu_dereference_bh_check(p, 1)

If you add this new subsystem parameter, then I think it makes sense
to use lockdep_nfnl_is_held() here. Otherwise, passing the subsystem
ID is not useful.

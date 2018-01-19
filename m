From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH nf-next] netfilter: remove messages print and boot/module
 load time
Date: Fri, 19 Jan 2018 14:13:48 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1801191413120.20974@blackhole.kfki.hu>
References: <20180119124702.2650-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:59975 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754719AbeASNNv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 08:13:51 -0500
In-Reply-To: <20180119124702.2650-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 19 Jan 2018, Pablo Neira Ayuso wrote:

> Several reasons for this:
> 
> * Several modules maintain internal version numbers, that they print at
>   boot/module load time, that are not exposed to userspace, as a
>   primitive mechanism to make revision number control from the earlier
>   days of Netfilter.
> 
> * IPset shows the protocol version at boot/module load time, instead
>   display this via module description, as Jozsef suggested.
> 
> * Remove copyright notice at boot/module load time in two spots, the
>   Netfilter codebase is a collective development effort, if we would
>   have to display copyrights for each contributor at boot/module load
>   time for each extensions we have, we would probably fill up logs with
>   lots of useless information - from a technical standpoint.
> 
> So let's be consistent and remove them all.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/ipset/ip_set_core.c    | 3 ++-
>  net/netfilter/nf_conntrack_netlink.c | 5 -----
>  net/netfilter/nf_tables_api.c        | 1 -
>  net/netfilter/nfnetlink.c            | 4 ----
>  net/netfilter/nfnetlink_acct.c       | 2 --
>  net/netfilter/nft_compat.c           | 2 --
>  6 files changed, 2 insertions(+), 15 deletions(-)

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary

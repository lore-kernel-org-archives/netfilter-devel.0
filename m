Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6044C4167B
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Dec 2022 12:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiL3MmJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Dec 2022 07:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiL3MmI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Dec 2022 07:42:08 -0500
X-Greylist: delayed 84471 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 30 Dec 2022 04:42:05 PST
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6051912084
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Dec 2022 04:42:05 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id D88AC67400F0;
        Fri, 30 Dec 2022 13:42:03 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 30 Dec 2022 13:42:01 +0100 (CET)
Received: from mentat.rmki.kfki.hu (host-94-248-211-167.kabelnet.hu [94.248.211.167])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id A15A867400EC;
        Fri, 30 Dec 2022 13:42:01 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
        id 3FCB745C; Fri, 30 Dec 2022 13:42:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mentat.rmki.kfki.hu (Postfix) with ESMTP id 3D4546A6;
        Fri, 30 Dec 2022 13:42:01 +0100 (CET)
Date:   Fri, 30 Dec 2022 13:42:01 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] ipset patches for nf
In-Reply-To: <20221230122438.1618153-1-kadlec@netfilter.org>
Message-ID: <bfd683-b621-9d38-4139-74486f70e834@netfilter.org>
References: <20221230122438.1618153-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 0%
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 30 Dec 2022, Jozsef Kadlecsik wrote:

> Please pull the next patches into your nf tree.
> 
> - The first patch fixes a hang when 0/0 subnets is added to a
>   hash:net,port,net type of set. Except hash:net,port,net and
>   hash:net,iface, the set types don't support 0/0 and the auxiliary
>   functions rely on this fact. So 0/0 needs a special handling in
>   hash:net,port,net which was missing (hash:net,iface was not affected
>   by this bug).
> - When adding/deleting large number of elements in one step in ipset,
>   it can take a reasonable amount of time and can result in soft lockup
>   errors. This patch is a complete rework of the previous version in order
>   to use a smaller internal batch limit and at the same time removing
>   the external hard limit to add arbitrary number of elements in one step.
> 
> Please note, while the second patch removes half of the first patch, the
> remaining part of the first patch is still important.

In the versions I sent the first patch was collapsed with the part for 
hash:net,port,net from the second patch. So now for proper functionality 
it depends on the second one. If it is not OK, just let me know!

Best regards,
Jozsef

> The following changes since commit 123b99619cca94bdca0bf7bde9abe28f0a0dfe06:
> 
>   netfilter: nf_tables: honor set timeout and garbage collection updates (2022-12-22 10:36:37 +0100)
> 
> are available in the Git repository at:
> 
>   git://blackhole.kfki.hu/nf 82f6ab0989c5aa14e
> 
> for you to fetch changes up to 82f6ab0989c5aa14e89f2689f47f89589733f2b2:
> 
>   netfilter: ipset: Rework long task execution when adding/deleting entries (2022-12-30 13:11:23 +0100)
> 
> ----------------------------------------------------------------
> Jozsef Kadlecsik (2):
>       netfilter: ipset: fix hash:net,port,net hang with /0 subnet
>       netfilter: ipset: Rework long task execution when adding/deleting entries
> 
>  include/linux/netfilter/ipset/ip_set.h       |  2 +-
>  net/netfilter/ipset/ip_set_core.c            |  7 ++---
>  net/netfilter/ipset/ip_set_hash_ip.c         | 14 +++++-----
>  net/netfilter/ipset/ip_set_hash_ipmark.c     | 13 ++++-----
>  net/netfilter/ipset/ip_set_hash_ipport.c     | 13 ++++-----
>  net/netfilter/ipset/ip_set_hash_ipportip.c   | 13 ++++-----
>  net/netfilter/ipset/ip_set_hash_ipportnet.c  | 13 +++++----
>  net/netfilter/ipset/ip_set_hash_net.c        | 17 +++++-------
>  net/netfilter/ipset/ip_set_hash_netiface.c   | 15 +++++------
>  net/netfilter/ipset/ip_set_hash_netnet.c     | 23 +++++-----------
>  net/netfilter/ipset/ip_set_hash_netport.c    | 19 +++++--------
>  net/netfilter/ipset/ip_set_hash_netportnet.c | 40 +++++++++++++++-------------
>  12 files changed, 89 insertions(+), 100 deletions(-)
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary

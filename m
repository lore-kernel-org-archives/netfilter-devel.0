From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: set the path of the lock file via a configure
 option.
Date: Tue, 14 Mar 2017 11:22:06 +0100
Message-ID: <20170314102206.GA1933@salvia>
References: <20170314085550.10153-1-lorenzo@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, jscherpelz@google.com
To: Lorenzo Colitti <lorenzo@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36048 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750876AbdCNKWZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 06:22:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C036424935
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 11:22:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6777DA38C
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 11:22:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B3D9DA3A4
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 11:22:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170314085550.10153-1-lorenzo@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 14, 2017 at 05:55:50PM +0900, Lorenzo Colitti wrote:
> Currently the iptables lock is hardcoded as "/run/xtables.lock".
> Allow users to change this path using the --with-xt-lock-name
> option to ./configure option. This is useful on systems like
> Android which do not have /run.
> 
> Tested on Ubuntu, as follows:
> 
> 1. By default, the lock is placed in /run/xtables.lock:
> 
> $ make distclean-recursive && ./autogen.sh &&
>   ./configure --disable-nftables --prefix /tmp/iptables &&
>   make -j64 &&
>   make install &&
>   sudo strace -e open,flock /tmp/iptables/sbin/iptables -L foo
> ...
> open("/run/xtables.lock", O_RDONLY|O_CREAT, 0600) = 3
> flock(3, LOCK_EX|LOCK_NB)               = 0
> iptables: No chain/target/match by that name.
> 
> 2. Specifying the lock results in the expected location being
>    used:
> 
> $ make distclean-recursive && ./autogen.sh && \
>   ./configure --disable-nftables --prefix /tmp/iptables \
>   --with-xt-lock-name=/tmp/iptables/run/xtables.lock &&
>   make -j64 &&
>   make install &&
>   sudo strace -e open,flock /tmp/iptables/sbin/iptables -L foo
> ...
> open("/tmp/iptables/run/xtables.lock", O_RDONLY|O_CREAT, 0600) = 3
> flock(3, LOCK_EX|LOCK_NB)               = 0
> iptables: No chain/target/match by that name.

Applied, thanks Lorenzo!

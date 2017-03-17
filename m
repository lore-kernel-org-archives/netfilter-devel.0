From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: move XT_LOCK_NAME from CFLAGS to config.h.
Date: Fri, 17 Mar 2017 14:14:19 +0100
Message-ID: <20170317131419.GA12186@salvia>
References: <20170316035420.96237-1-lorenzo@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, jscherpelz@google.com
To: Lorenzo Colitti <lorenzo@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751010AbdCQNPG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 09:15:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4F7E7EDB00
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:14:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D5BDDA86C
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:14:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54AE3CA6BF
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:14:19 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170316035420.96237-1-lorenzo@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 16, 2017 at 12:54:20PM +0900, Lorenzo Colitti wrote:
> This slightly simplifies configure.ac and results in more
> correct dependencies.
> 
> Tested by running ./configure with --with-xt-lock-name and
> without, and using strace to verify that the right lock is used.
> 
> $ make distclean-recursive && ./autogen.sh &&
>   ./configure --disable-nftables --prefix /tmp/iptables &&
>   make -j64 &&
>   make install &&
>   sudo strace -e open,flock /tmp/iptables/sbin/iptables -L foo
> ...
> open("/run/xtables.lock", O_RDONLY|O_CREAT, 0600) = 3
> flock(3, LOCK_EX|LOCK_NB)               = 0
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

Applied, thanks Lorenzo.

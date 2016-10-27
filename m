From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 00/22] ipset patches for nf-next, v2
Date: Thu, 27 Oct 2016 18:53:51 +0200
Message-ID: <20161027165351.GA17233@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45584 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755930AbcJ0QyK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 12:54:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4DD3962D24
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:53:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B3F1DA81F
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:53:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21F64DA846
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:53:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:33PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Sorry for the first version, it was a mistake at copying the patch content
> from the ipset package (where the original version was checked and
> verified).
> 
> Please consider to apply the next bunch of patches for ipset.
> There is new set type in it (hash:ip,mac), elemet counts are reported
> to userspace in the set headers data and a couple of small cleanups,
> improvements
> 
> * rcu_dereference_bh_nfnl() redefined to accept netfilter subsys id.
> * Header files cleanup: counter helper functions are grouped together,
>   some args are changed to const.
> * struct ip_set_skbinfo is introduced instead of open coded fields
>   in skbinfo get/init helper funcions.
> * In comment extension allocate area with kmalloc() rather than kzalloc().
> * Split all extensions into separate files.
> * Separate memsize calculation into dedicated functions.
> * ip_set_put_extensions() is regrouped and extern is added.
> * Add element count to hash headers by Eric B Munson.
> * Add element count to all set types header for uniform output.
> * Count non-static extension memory into memsize calculation for
>   userspace.
> * Simplify mtype_expire() for hash types by removing redundant
>   parameters which can be get from other ones.
> * Make NLEN compile time constant for hash types.
> * Make sure element data size is a multiple of u32.
> * Optimize hash creation routine, exit as early as possible.
> * Make struct htype per ipset family.
> * Collapse same condition body into a single one.
> * Fix reported memory size for hash:* types.
> * hash:ipmac type support added to ipset by Tomasz Chilinski.
> * Use setup_timer() and mod_timer() instead of init_timer()
>   by Muhammad Falak R Wani, individually for the set type families.
> * hash: fix boolreturn.cocci warnings avout bool should use true/false
>   by Fengguang Wu.

Pulled, thanks Jozsef.

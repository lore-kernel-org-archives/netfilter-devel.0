From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf V2] netfilter: invoke synchronize_rcu after set the
 _hook_ to NULL
Date: Mon, 27 Mar 2017 13:54:53 +0200
Message-ID: <20170327115453.GA5270@salvia>
References: <1490403192-15663-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752419AbdC0LzZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 07:55:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4517CE8E82
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 13:54:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15065DA38F
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 13:54:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C052CDA729
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 13:54:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490403192-15663-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 25, 2017 at 08:53:12AM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Otherwise, another CPU may access the invalid pointer. For example:
>     CPU0                CPU1
>      -              rcu_read_lock();
>      -              pfunc = _hook_;
>   _hook_ = NULL;          -
>   mod unload              -
>      -                 pfunc(); // invalid, panic
>      -             rcu_read_unlock();
> 
> So we must call synchronize_rcu() to wait the rcu reader to finish.
> 
> Also note, in nf_nat_snmp_basic_fini, synchronize_rcu() will be invoked
> by later nf_conntrack_helper_unregister, but I'm inclined to add a
> explicit synchronize_rcu after set the nf_nat_snmp_hook to NULL. Depend
> on such obscure assumptions is not a good idea.
> 
> Last, in nfnetlink_cttimeout, we use kfree_rcu to free the time object,
> so in cttimeout_exit, invoking rcu_barrier() is not necessary at all,
> remove it too.

Applied, thanks.

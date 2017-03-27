From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf V3] netfilter: nfnl_cthelper: fix a race when walk the
 nf_ct_helper_hash table
Date: Mon, 27 Mar 2017 13:55:05 +0200
Message-ID: <20170327115505.GB5270@salvia>
References: <1490414955-57988-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752468AbdC0LzZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 07:55:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F93FE8E93
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 13:55:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00845DA870
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 13:55:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6300DA7F7
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 13:55:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490414955-57988-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 25, 2017 at 12:09:15PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> The nf_ct_helper_hash table is protected by nf_ct_helper_mutex, while
> nfct_helper operation is protected by nfnl_lock(NFNL_SUBSYS_CTHELPER).
> So it's possible that one CPU is walking the nf_ct_helper_hash for
> cthelper add/get/del, another cpu is doing nf_conntrack_helpers_unregister
> at the same time. This is dangrous, and may cause use after free error.
> 
> Note, delete operation will flush all cthelpers added via nfnetlink, so
> using rcu to do protect is not easy.
> 
> Now introduce a dummy list to record all the cthelpers added via
> nfnetlink, then we can walk the dummy list instead of walking the
> nf_ct_helper_hash. Also, keep nfnl_cthelper_dump_table unchanged, it
> may be invoked without nfnl_lock(NFNL_SUBSYS_CTHELPER) held.

Also applied, thanks Liping.

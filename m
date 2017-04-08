From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_ct_expect: use proper RCU list
 traversal/update APIs
Date: Sat, 8 Apr 2017 23:46:26 +0200
Message-ID: <20170408214626.GE5301@salvia>
References: <1491128737-14747-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35794 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751976AbdDHVqd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 17:46:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6194C24937
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:46:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 074A6DA725
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:46:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3A100DA807
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:46:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491128737-14747-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 02, 2017 at 06:25:37PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> We should use proper RCU list APIs to manipulate help->expectations,
> as we can dump the conntrack's expectations via nfnetlink, i.e. in
> ctnetlink_exp_ct_dump_table(), where only rcu_read_lock is acquired.
> 
> So for list traversal, use hlist_for_each_entry_rcu; for list add/del,
> use hlist_add_head_rcu and hlist_del_rcu.

Good catch. Applied, thanks.

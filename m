From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf V2] netfilter: ctnetlink: make it safer when updating
 ct->status
Date: Fri, 14 Apr 2017 01:25:55 +0200
Message-ID: <20170413232555.GA7517@salvia>
References: <1492088027-10389-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, cernekee@chromium.org,
        fgao@ikuai8.com, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56430 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752040AbdDMX0L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:26:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7F9BCC1083
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:26:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8D02DA86B
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:26:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9343DA848
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:26:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492088027-10389-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 13, 2017 at 08:53:47PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> User can update the ct->status via nfnetlink, but using a non-atomic
> operation "ct->status |= status;". This is unsafe, and may clear
> IPS_DYING_BIT bit set by another CPU unexpectedly. For example:
>          CPU0                            CPU1
>   ctnetlink_change_status        __nf_conntrack_find_get
>       old = ct->status              nf_ct_gc_expired
>           -                         nf_ct_kill
>           -                      test_and_set_bit(IPS_DYING_BIT
>       new = old | status;                 -
>   ct->status = new; <-- oops, _DYING_ is cleared!

This is fixing an issue that was introduced in ca7433df3a67.

So I would like this comes in a patch batch including the several
patches that we need to fix the conntrack update path from ctnetlink.

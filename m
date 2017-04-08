From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ctnetlink: skip dumping expect when
 nfct_help(ct) is NULL
Date: Sat, 8 Apr 2017 23:44:18 +0200
Message-ID: <20170408214418.GD5301@salvia>
References: <1491127293-11235-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35642 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751976AbdDHVo0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 17:44:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65EF124935
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:44:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0AFC2DA729
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:44:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53DC6DA804
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:44:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491127293-11235-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 02, 2017 at 06:01:33PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> For IPCTNL_MSG_EXP_GET, if the CTA_EXPECT_MASTER attr is specified, then
> the NLM_F_DUMP request will dump the expectations related to this
> connection tracking.
> 
> But we forget to check whether the conntrack has nf_conn_help or not,
> so if nfct_help(ct) is NULL, oops will happen:
> 
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>  IP: ctnetlink_exp_ct_dump_table+0xf9/0x1e0 [nf_conntrack_netlink]
>  Call Trace:
>   ? ctnetlink_exp_ct_dump_table+0x75/0x1e0 [nf_conntrack_netlink]
>   netlink_dump+0x124/0x2a0
>   __netlink_dump_start+0x161/0x190
>   ctnetlink_dump_exp_ct+0x16c/0x1bc [nf_conntrack_netlink]
>   ? ctnetlink_exp_fill_info.constprop.33+0xf0/0xf0 [nf_conntrack_netlink]
>   ? ctnetlink_glue_seqadj+0x20/0x20 [nf_conntrack_netlink]
>   ctnetlink_get_expect+0x32e/0x370 [nf_conntrack_netlink]
>   ? debug_lockdep_rcu_enabled+0x1d/0x20
>   nfnetlink_rcv_msg+0x60a/0x6a9 [nfnetlink]
>   ? nfnetlink_rcv_msg+0x1b9/0x6a9 [nfnetlink]
>   [...]

Applied, thanks.

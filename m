From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nfnetlink: remove static declaration
 from err_list
Date: Sun, 19 Feb 2017 20:45:36 +0100
Message-ID: <20170219194536.GA5088@salvia>
References: <1487385347-25257-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750905AbdBSTpl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Feb 2017 14:45:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0EEA6ED905
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Feb 2017 20:45:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB88CDA807
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Feb 2017 20:45:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D66F9DA7FA
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Feb 2017 20:45:37 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1487385347-25257-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Feb 18, 2017 at 10:35:47AM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Otherwise, different subsys will race to access the err_list, with holding
> the different nfnl_lock(subsys_id).
> 
> But this will not happen now, since ->call_batch is only implemented by
> nftables, so the err_list is protected by nfnl_lock(NFNL_SUBSYS_NFTABLES).

Good catch, applied, thanks.

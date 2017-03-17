From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] netfilter: ctlink: Fix one possible memleak in
 nfnl_cthelper_create
Date: Fri, 17 Mar 2017 13:39:26 +0100
Message-ID: <20170317123926.GA5321@salvia>
References: <1489627656-104238-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751110AbdCQMjo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 08:39:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C1943E3A11
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 13:39:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B44D3DA874
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 13:39:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE37ADA862
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 13:39:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489627656-104238-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 16, 2017 at 09:27:36AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> When nf_conntrack_helper_register failed, the error handler just frees
> the helper, but it does not free the helper->expect_policy which is
> allocated in nfnl_cthelper_parse_expect_policy.

Applied, thanks.

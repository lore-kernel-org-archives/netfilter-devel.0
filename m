From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] netfilter: nf_tables: Remove the rcu lock
 for dump functions
Date: Thu, 12 Jan 2017 12:11:00 +0100
Message-ID: <20170112111100.GB1048@salvia>
References: <1484217474-122356-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52486 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750843AbdALLLk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2017 06:11:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B7867523C6
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 12:11:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7AB7A7F24
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 12:11:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64E8D9D695
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 12:11:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1484217474-122356-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 12, 2017 at 06:37:54PM +0800, fgao@ikuai8.com wrote:
> From: Feng <fgao@ikuai8.com>
> 
> The rcu lock protect is added 3 years ago with the commit
> e688a7f8c6cb7a18aae7e55ccdd175f0ad9e69c0. But I find the dump
> operation is protected by the nfnl_lock in the current codes. The
> dump is a synchronization opertion in the netlink callback function
> which is protected by the nfnl_lock.

nfnl_lock() only protects the first call, follow up recvmsg() calls in
rely on rcu. Please, see netlink_dump().

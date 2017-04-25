From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v3] netfilter: xt_CT: fix refcnt leak on error path
Date: Tue, 25 Apr 2017 11:05:18 +0200
Message-ID: <20170425090518.GA2833@salvia>
References: <1492135208-52964-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>,
        Liping Zhang <zlpnobody@gmail.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43038 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937253AbdDYJFb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:05:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B3737F5E6
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:05:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF7F8FF2D1
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:05:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C8BFFF6F3
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:05:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492135208-52964-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 14, 2017 at 10:00:08AM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are two cases which causes refcnt leak.
> 
> 1. When nf_ct_timeout_ext_add failed in xt_ct_set_timeout, it should
> free the timeout refcnt.
> Now goto the err_put_timeout error handler instead of going ahead.
> 
> 2. When the time policy is not found, we should call module_put.
> Otherwise, the related cthelper module cannot be removed anymore.
> It is easy to reproduce by typing the following command:
>   # iptables -t raw -A OUTPUT -p tcp -j CT --helper ftp --timeout xxx

Applied, thanks.

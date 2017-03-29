From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: fix secctx memory leak
Date: Wed, 29 Mar 2017 12:31:51 +0200
Message-ID: <20170329103151.GA4996@salvia>
References: <1490713165-60445-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, r.kubiak@samsung.com,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46176 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755527AbdC2KcA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 06:32:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8B2ADBA1B3
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:31:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DE66DA871
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:31:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56501DA87C
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:31:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490713165-60445-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 28, 2017 at 10:59:25PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> We must call security_release_secctx to free the memory returned by
> security_secid_to_secctx, otherwise memory may be leaked forever.

Applied, thanks.

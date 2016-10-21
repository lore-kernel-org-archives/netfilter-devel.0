From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: xt_multiport: Use switch case instead
 of multiple condition checks
Date: Fri, 21 Oct 2016 12:37:58 +0200
Message-ID: <20161021103758.GA2118@salvia>
References: <1474896217-31351-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52070 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754655AbcJUKiF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 06:38:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4A56E26E20
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:38:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 359C2DA7FA
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:38:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 313F8DA7F7
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:37:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474896217-31351-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 26, 2016 at 09:23:37PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are multiple equality condition checks in the original codes, so it
> is better to use switch case instead of them.

Applied.

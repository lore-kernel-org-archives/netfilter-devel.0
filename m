From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: xt_connlimit: don't store address in
 the conn nodes
Date: Tue, 24 Oct 2017 18:05:04 +0200
Message-ID: <20171024160504.GC12134@salvia>
References: <20171015090034.6314-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57544 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdJXQFM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 12:05:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1133AE976C
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:05:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0157ADA7F7
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:05:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171015090034.6314-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 15, 2017 at 11:00:34AM +0200, Florian Westphal wrote:
> Only stored, never read.  This is a leftover from commit 7d08487777c8
> ("netfilter: connlimit: use rbtree for per-host conntrack obj storage"),
> which added the rbtree node struct that stores the address instead.

Applied, thanks.

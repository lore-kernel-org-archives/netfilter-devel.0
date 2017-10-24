From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: make l3proto trackers const
Date: Tue, 24 Oct 2017 18:04:47 +0200
Message-ID: <20171024160447.GB12134@salvia>
References: <20171012073830.9102-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57396 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdJXQEw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 12:04:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1F167E9770
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:04:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D9B8DA871
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:04:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171012073830.9102-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 12, 2017 at 09:38:30AM +0200, Florian Westphal wrote:
> previous patches removed all writes to them.

Applied, thanks.

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] libnftables: Fix for multiple context instances
Date: Mon, 20 Nov 2017 13:37:26 +0100
Message-ID: <20171120123726.GA17459@salvia>
References: <20171116191024.18908-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbdKTMhb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2017 07:37:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CC9E554D5F6
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 13:37:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BCF9977D8E
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 13:37:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171116191024.18908-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 16, 2017 at 08:10:24PM +0100, Phil Sutter wrote:
> If a second context is created, the second call to nft_ctx_free() leads
> to freeing invalid pointers in nft_exit(). Fix this by introducing a
> reference counter so that neither nft_init() nor nft_exit() run more
> than once in a row.
> 
> This reference counter has to be protected from parallel access. Do this
> using a mutex in a way that once nft_init() returns, the first call to
> that function running in parallel is guaranteed to be finished -
> otherwise it could happen that things being initialized in one thread
> are already accessed in another one.

I would prefer this table is placed into the context object, so they
are not global anymore. So I would prefer we fix this the right way(tm).

Let me know your thoughts, thanks!

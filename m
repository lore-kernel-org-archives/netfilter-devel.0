From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 0/3] netfilter: conntrack: removal prealloc
 support
Date: Mon, 24 Apr 2017 10:38:38 +0200
Message-ID: <20170424083838.GB3408@salvia>
References: <20170420075424.12190-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1166792AbdDXIin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Apr 2017 04:38:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BE5C9523C9
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:38:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADEA7FF2C5
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:38:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91D35FF2D5
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:38:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170420075424.12190-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 09:54:21AM +0200, Florian Westphal wrote:
> The prealloc flag is only used for the nat extension (and
> that extension is not even needed anymore in some cases).
> 
> This removes prealloc, marks all extension structs as const and then
> also simplifies the initial extension allocation.
> 
> Currently (default settings), each conntrack will use 64 bytes of the initial
> extension allocation.

Series applied, thanks.

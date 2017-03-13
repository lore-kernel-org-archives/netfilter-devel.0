From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_conntrack: reduce
 resolve_normal_ct args
Date: Mon, 13 Mar 2017 19:31:12 +0100
Message-ID: <20170313183112.GA535@salvia>
References: <20170309115715.22940-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751777AbdCMSbW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 14:31:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 108371B8420
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 19:31:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02AE9DA848
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 19:31:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08B2BDA848
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 19:31:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170309115715.22940-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 09, 2017 at 12:57:15PM +0100, Florian Westphal wrote:
> also mark init_conntrack noinline, in most cases resolve_normal_ct will
> find an existing conntrack entry.
> 
> text    data     bss     dec     hex filename
> 16735    5707     176   22618    585a net/netfilter/nf_conntrack_core.o
> 16687    5707     176   22570    582a net/netfilter/nf_conntrack_core.o

Applied.

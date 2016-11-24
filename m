From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nat: fix crash when conntrack entry is
 re-used
Date: Thu, 24 Nov 2016 13:53:26 +0100
Message-ID: <20161124125326.GB23970@salvia>
References: <1479859863-1067-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58978 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935112AbcKXMxd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 07:53:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 90551209427
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:53:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C5FCDA849
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:53:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26599DA849
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:53:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479859863-1067-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 23, 2016 at 01:11:03AM +0100, Florian Westphal wrote:
> Stas Nichiporovich reports oops in nf_nat_bysource_cmp(), trying to
> access nf_conn struct at address 0xffffffffffffff50.
> 
> This is the result of fetching a null rhash list (struct embedded at
> offset 176; 0 - 176 gets us ...fff50).
> 
> The problem is that conntrack entries are allocated from a
> SLAB_DESTROY_BY_RCU cache, i.e. entries can be free'd and reused
> on another cpu while nf nat bysource hash access the same conntrack entry.
> 
> Freeing is fine (we hold rcu read lock); zeroing rhlist_head isn't.
> 
> -> Move the rhlist struct outside of the memset()-inited area.

Also applied, thanks.

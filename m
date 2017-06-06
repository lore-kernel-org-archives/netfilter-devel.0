From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] ct: fix inet/bridge/netdev family handling for
 saddr/daddr
Date: Tue, 6 Jun 2017 18:09:25 +0200
Message-ID: <20170606160925.GB13625@salvia>
References: <20170529172538.27878-1-fw@strlen.de>
 <20170529172538.27878-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36632 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbdFFQJd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 12:09:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 35429209910
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:09:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27ACA100795
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:09:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 32D86FF2F1
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 18:09:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170529172538.27878-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 29, 2017 at 07:25:38PM +0200, Florian Westphal wrote:
> "ct orignal saddr" has an invalid data type, as the address can be either ipv4 or ipv6.
> For some cases we could infer it from the rhs, but there are cases where we don't have any
> information, e.g. when passing ct original saddr to jhash expression.
> 
> So do the same thing that we do for "rt nexthop" -- error out and hint to user
> they need to specifiy the desired address type with "meta nfproto".
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

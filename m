From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/2] netfilter: reduce size of hook entry points
Date: Wed, 6 Dec 2017 09:20:03 +0100
Message-ID: <20171206082003.GB4076@salvia>
References: <20171202235848.22737-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33342 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbdLFIUH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Dec 2017 03:20:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 05991C0B25
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 09:20:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB4F9DA804
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 09:20:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171202235848.22737-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 03, 2017 at 12:58:46AM +0100, Florian Westphal wrote:
> struct net contains:
> 
> struct nf_hook_entries __rcu *hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
> 
> where NFPROTO_NUMPROTO = 13 and NF_MAX_HOOKS = 8.
> 
> ... and that needs a *lot* more space than what we really need.
> We only need hooks for arp, bridge, ipv4, ipv6 and decnet.
> 
> Arp only has 3 hook types, decnet has 7, all others have 5.
> So replace this with dedicated arrays of the correct size to save
> some space.

Also applied, thanks.

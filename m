From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: do not enable connection
 tracking unless needed
Date: Mon, 31 Jul 2017 20:16:17 +0200
Message-ID: <20170731181617.GA15144@salvia>
References: <20170728092204.11953-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750940AbdGaSQa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 14:16:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1AAF13025A7
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 20:16:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A234DA46C
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 20:16:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8CE1DA812
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 20:16:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170728092204.11953-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 28, 2017 at 11:22:04AM +0200, Florian Westphal wrote:
> Discussion during NFWS 2017 in Faro has shown that the current
> conntrack behaviour is unreasonable.
> 
> Even if conntrack module is loaded on behalf of a single net namespace,
> its turned on for all namespaces, which is expensive.  Commit
> 481fa373476 ("netfilter: conntrack: add nf_conntrack_default_on sysctl")
> attempted to provide an alternative to the 'default on' behaviour by
> adding a sysctl to change it.
> 
> However, as Eric points out, the sysctl only becomes available
> once the module is loaded, and then its too late.
> 
> So we either have to move the sysctl to the core, or, alternatively,
> change conntrack to become active only once the rule set requires this.
> 
> This does the latter, conntrack is only enabled when a rule needs it.

Applied, thanks.

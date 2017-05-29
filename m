From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/5] netfilter: conntrack: rework nf_ct_iterate,
 part 1.
Date: Mon, 29 May 2017 11:35:32 +0200
Message-ID: <20170529093532.GA10029@salvia>
References: <20170521105259.10239-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58812 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750974AbdE2Jfg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 05:35:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B16CF1DA087
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:35:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A10E6FF2FB
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:35:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B534FFF2FB
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:35:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170521105259.10239-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 21, 2017 at 12:52:54PM +0200, Florian Westphal wrote:
> First batch of changes to rework how we iterate over the conntrack table.
> 
> Historically, we had one table.
> When net namespaces were added, we got one table per namespace.
> Nowadays we again only have a single table (which considers netns
> during lookups).
> 
> This series prepares for removal of some open-coded table iteration
> places.
> 
> It also adds nf_ct_iterate_destroy(), to be used in module exit path
> when we need to inspect every conntrack entry regardless of namespace,
> then uses it from nat module exit path.

Series applied, thanks.

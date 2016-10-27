From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3 nf-next] nf_tables: add fib expression
Date: Thu, 27 Oct 2016 20:16:55 +0200
Message-ID: <20161027181655.GA24243@salvia>
References: <1477321002-14056-1-git-send-email-fw@strlen.de>
 <1477321002-14056-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48830 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933792AbcJ0SRA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 14:17:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5AE731D94AC
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 20:16:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C1B7DA7F7
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 20:16:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16546DA847
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 20:16:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1477321002-14056-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 24, 2016 at 04:56:40PM +0200, Florian Westphal wrote:
> Add FIB expression, supported for ipv4, ipv6 and inet family (the latter
> just dispatches to ipv4 or ipv6 one based on nfproto).
> 
> Currently supports fetching output interface index/name and the
> rtm_type associated with an address.
> 
> This can be used for adding path filtering. rtm_type is useful
> to e.g. enforce a strong-end host model where packets
> are only accepted if daddr is configured on the interface the
> packet arrived on.
> 
> The fib expression is a native nftables alternative to the
> xtables addrtype and rp_filter matches.
> 
> FIB result order for oif/oifname retrieval is as follows:
>  - if packet is local (skb has rtable, RTF_LOCAL set, this
>    will also catch looped-back multicast packets), set oif to
>    the loopback interface.
>  - if fib lookup returns an error, or result points to local,
>    store zero result.  This means '--local' option of -m rpfilter
>    is not supported. It is possible to use 'fib type local' or add
>    explicit saddr/daddr matching rules to create exceptions if this
>    is really needed.
>  - store result in the destination register.
>    In case of multiple routes, search set for desired oif in case
>    strict matching is requested.
> 
> ipv4 and ipv6 behave fib expressions are supposed to behave the same.

This looks great, applied, thanks Florian.

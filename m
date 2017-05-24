From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 0/4 RFC] Support IPv6 AH header matches
Date: Wed, 24 May 2017 12:36:42 +0200
Message-ID: <20170524103642.GA23278@salvia>
References: <20170522164936.28034-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S939515AbdEXKgr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 06:36:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 269031EF5E7
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 12:36:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1557E6E7AB
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 12:36:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0929918500
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 12:36:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170522164936.28034-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 22, 2017 at 06:49:32PM +0200, Phil Sutter wrote:
> The following series allows users to match on IPv6 AH header fields. I
> consider this a bit of a hack since it's the "cheap" solution. As to why
> this is, let me first picture the problem once again:
> 
> AH header is an extension header in IPv6 land. This means in order to
> find it, one has to use ip6_find_hdr() (in kernel space) since
> pkt->xt.thoff (which payload expression uses) points past extension
> headers in IPv6 packets. So while the existing AH header match for IPv4
> uses payload expression, a theoretical one for IPv6 has to use exthdr
> expression.
> 
> Expressions are constructed in user space at rule creation time, so it
> is not always clear which packet family they will get applied to (see
> inet or bridge family tables).
> 
> I see two alternatives for solving this situation: The better one is to
> allow the kernel to choose the right expression (payload or exthdr)
> depending on IP address family when searching the AH header. The other
> one is presented here: Userspace demands the user to clarify which IP
> address family an AH header match should apply to, so it can create the
> right expression for the job.
> 
> For the sake of simplicity, in this implementation I went without some
> kind of placeholder expression but just convert the parser-generated
> payload expression into an exthdr one if protocol context states layer 3
> is IPv6.
> 
> I looked at netlink debug output and the following commands seem to turn
> out right:
> 
> | $ nft add rule ip t c ah spi 2	# ip table family
> | $ nft add rule ip6 t c ah spi 2	# ip6 table family
> | $ nft add rule inet t c ip6 version 6 ah spi 2
> | $ nft add rule inet t c ip version 4 ah spi 2
> 
> There are still a few oddities here: E.g. 'meta protocol ip6' is not
> sufficient since that doesn't create a protocol dependency, hence why I
> used the somewhat redundant 'ip6 version 6' match instead. So if we
> decide to use the solution proposed here, I'd suggest do patch up meta
> expression to generate the dependency as well.

We fixed this from the kernel side, so both IPv4 and IPv6 meta l4proto
says ah. And transport offsets are set to the AH header.

So the code we already have should work out of the box.

Am I missing anything?

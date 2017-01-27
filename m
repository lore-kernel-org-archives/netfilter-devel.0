From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] payload: explicit network ctx assignation for
 icmp/icmp6 in special families
Date: Fri, 27 Jan 2017 13:37:13 +0100
Message-ID: <20170127123713.GA10831@salvia>
References: <148534500812.3696.9146810123952951607.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33800 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932634AbdA0MhX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Jan 2017 07:37:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 28B9C16B287
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jan 2017 13:37:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1AD69A7BE8
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jan 2017 13:37:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0AA2DA878
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jan 2017 13:37:14 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <148534500812.3696.9146810123952951607.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 25, 2017 at 12:51:08PM +0100, Arturo Borrero Gonzalez wrote:
> In the inet, bridge and netdev families, we can add rules like these:
> 
> % nft add rule inet t c ip protocol icmp icmp type echo-request
> % nft add rule inet t c ip6 nexthdr icmpv6 icmpv6 type echo-request
> 
> However, when we print the ruleset:
> 
> % nft list ruleset
> table inet t {
> 	chain c {
> 		icmpv6 type echo-request
> 		icmp type echo-request
> 	}
> }
> 
> These rules we obtain can't be added again:
> 
> % nft add rule inet t c icmp type echo-request
> <cmdline>:1:19-27: Error: conflicting protocols specified: inet-service vs. icmp
> add rule inet t c icmp type echo-request
>                   ^^^^^^^^^
> 
> % nft add rule inet t c icmpv6 type echo-request
> <cmdline>:1:19-29: Error: conflicting protocols specified: inet-service vs. icmpv6
> add rule inet t c icmpv6 type echo-request
>                   ^^^^^^^^^^^
> 
> Since I wouldn't expect an IP packet carrying ICMPv6, or IPv6 packet
> carrying ICMP, if the link layer is inet, the network layer protocol context
> can be safely update to 'ip' or 'ip6'.
> 
> Moreover, nft currently generates a 'meta nfproto ipvX' depedency when
> using icmp or icmp6 in the inet family, and similar in netdev and bridge
> families.
> 
> While at it, a bit of code factorization is introduced.

Applied, thanks Arturo!

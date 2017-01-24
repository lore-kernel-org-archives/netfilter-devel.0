From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] payload: use explicit network ctx assignation for
 icmp/icmp6 in inet family
Date: Tue, 24 Jan 2017 20:48:54 +0100
Message-ID: <20170124194854.GA10867@salvia>
References: <148491481186.20302.13599222282579510532.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46150 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbdAXTtF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 14:49:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 214C11EC2CF
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 20:49:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 011DEFEFB1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 20:49:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4284A7E7C
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 20:48:59 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <148491481186.20302.13599222282579510532.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 20, 2017 at 01:20:11PM +0100, Arturo Borrero Gonzalez wrote:
> In the inet family, we can add rules like these:
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
> using icmp or icmp6 in the inet family.

Applied, thanks Arturo.

BTW, it would be great if you can cook a patch with new tests/py lines
covering this case.

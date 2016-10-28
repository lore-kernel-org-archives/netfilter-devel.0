From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 nf-next] netfilter: nft: introduce routing expression
Date: Fri, 28 Oct 2016 10:24:09 +0200
Message-ID: <20161028082409.GA7603@salvia>
References: <1477634055.1059.27.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32824 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759312AbcJ1IYU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 04:24:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3899261E8E
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 10:24:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2837021FEC
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 10:24:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 303E621FE4
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 10:24:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1477634055.1059.27.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 28, 2016 at 05:54:15AM +0000, Anders K. Pedersen | Cohaesio wrote:
> From: Anders K. Pedersen <akp@cohaesio.com>
> 
> Introduces an nftables rt expression for routing related data with support
> for nexthop (i.e. the directly connected IP address that an outgoing packet
> is sent to), which can be used either for matching or accounting, eg.
> 
>  # nft add rule filter postrouting \
> 	ip daddr 192.168.1.0/24 rt nexthop != 192.168.0.1 drop
> 
> This will drop any traffic to 192.168.1.0/24 that is not routed via
> 192.168.0.1.
> 
>  # nft add rule filter postrouting \
> 	flow table acct { rt nexthop timeout 600s counter }
>  # nft add rule ip6 filter postrouting \
> 	flow table acct { rt nexthop timeout 600s counter }
> 
> These rules count outgoing traffic per nexthop. Note that the timeout
> releases an entry if no traffic is seen for this nexthop within 10 minutes.
> 
>  # nft add rule inet filter postrouting \
> 	ether type ip \
> 	flow table acct { rt nexthop timeout 600s counter }
>  # nft add rule inet filter postrouting \
> 	ether type ip6 \
> 	flow table acct { rt nexthop timeout 600s counter }
> 
> Same as above, but via the inet family, where the ether type must be
> specified explicitly.
> 
> "rt classid" is also implemented identical to "meta rtclassid", since it
> is more logical to have this match in the routing expression going forward.

Applied, thanks Anders!

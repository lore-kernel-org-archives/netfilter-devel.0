From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] exthdr: avoid crash with older kernels
Date: Fri, 7 Apr 2017 00:55:06 +0200
Message-ID: <20170406225506.GB2867@salvia>
References: <20170404184646.16038-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39882 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932310AbdDFWzQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 18:55:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C17C2137B8B
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:55:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0AF9DA729
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:55:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1F80DA729
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:55:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170404184646.16038-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 04, 2017 at 08:46:46PM +0200, Florian Westphal wrote:
> if kernel is older it won't understand the EXTHDR_OP attribute, i.e.
> the rule gets accepted as a check for ipv6 exthdr.
> 
> On dump nft is then presented with a invalid ipv6 exthdr.
> So we need to get rid of the assert and output an "invalid" message on
> list.  Longterm we need a proper vm description or kernel-side check
> to reject such messages in first place.
> 
> After patch, test suite yields erros of type
> ip6/tcpopt.t: WARNING: 'src/nft add rule --debug=netlink ip6 test-ip6 \
>    input tcp option sack right 1': 'tcp option sack right 1' mismatches
> 'ip6 nexthdr 6 unknown-exthdr unknown 0x1 [invalid type]'
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

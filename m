From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 1/8] tests: adjust output to silence warnings
Date: Fri, 27 Oct 2017 14:41:21 +0200
Message-ID: <20171027124121.GM19457@breakpoint.cc>
References: <20171026230611.14269-1-fw@strlen.de>
 <20171026230611.14269-2-fw@strlen.de>
 <20171027102906.GA14147@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34132 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752258AbdJ0Mlj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Oct 2017 08:41:39 -0400
Content-Disposition: inline
In-Reply-To: <20171027102906.GA14147@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Fri, Oct 27, 2017 at 01:06:04AM +0200, Florian Westphal wrote:
> > silence following (correct but harmless) warnings:
> > bridge/icmpX.t: WARNING: line: 6: 'src/nft add rule --debug=netlink bridge test-bridge input icmp type echo-request': 'icmp type echo-request' mismatches 'ether type ip icmp type echo-request'
> > bridge/icmpX.t: WARNING: line: 8: 'src/nft add rule --debug=netlink bridge test-bridge input icmpv6 type echo-request': 'icmpv6 type echo-request' mismatches 'ether type ip6 icmpv6 type echo-request'
> > inet/icmpX.t: WARNING: line: 6: 'src/nft add rule --debug=netlink inet test-inet input icmp type echo-request': 'icmp type echo-request' mismatches 'meta nfproto ipv4 icmp type echo-request'
> > inet/icmpX.t: WARNING: line: 8: 'src/nft add rule --debug=netlink inet test-inet input icmpv6 type echo-request': 'icmpv6 type echo-request' mismatches 'meta nfproto ipv6 icmpv6 type echo-request'
> 
> Hm, I'm not hitting this here, probably there's a bug in test
> infrastructure.

The test case is new, most likely git pull will help.

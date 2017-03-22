From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: allow update of net base w. meta l4proto icmpv6
Date: Wed, 22 Mar 2017 17:07:26 +0100
Message-ID: <20170322160726.GA23136@salvia>
References: <20170321185437.22959-1-fw@strlen.de>
 <20170322130902.GA21742@salvia>
 <20170322134412.GA8584@breakpoint.cc>
 <20170322152909.GA22809@salvia>
 <20170322153204.GA22898@salvia>
 <20170322154400.GB8584@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47838 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760462AbdCVQHb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 12:07:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4AC6B170DA3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 17:07:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B8B4DA873
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 17:07:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2948DA804
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 17:07:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170322154400.GB8584@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 22, 2017 at 04:44:00PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hm, I wonder why you need this new line in proto_inet_service:
> > 
> > +         PROTO_LINK(IPPROTO_ICMPV6,      &proto_icmp6),
> 
> meta_expr_pctx_update calls proto_find_upper(), without this
> that returns NULL and proto base is set to 'unknown'.

Oh right.

Will this still happen if you tell nft to generate the dependency
using meta l4proto instead of ip6 nexthdr?

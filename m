From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: allow update of net base w. meta l4proto icmpv6
Date: Wed, 29 Mar 2017 12:13:16 +0200
Message-ID: <20170329101316.GA4349@salvia>
References: <20170321185437.22959-1-fw@strlen.de>
 <20170322130902.GA21742@salvia>
 <20170322134412.GA8584@breakpoint.cc>
 <20170322152909.GA22809@salvia>
 <20170322153204.GA22898@salvia>
 <20170322154400.GB8584@breakpoint.cc>
 <20170322160726.GA23136@salvia>
 <20170322192252.GC8584@breakpoint.cc>
 <20170324115021.GA2515@salvia>
 <20170324122112.GG10418@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755123AbdC2KNW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 06:13:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DC129BA1A7
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:13:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD49FDA848
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:13:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4888ADA848
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:13:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170324122112.GG10418@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 24, 2017 at 01:21:12PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > We can just use NFT_META_L4PROTO all the time, so we use it from IPv4
> > too, right?
> 
> Right, we can indeed do that and change ip as well.

BTW, I think this problem may be the root cause for this report:

https://bugzilla.netfilter.org/show_bug.cgi?id=1138

Probably these people are just getting that ICMPv6 with some extension
header.

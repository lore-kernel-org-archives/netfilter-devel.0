From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 04/10] tests: fix up meta l4proto change for ip6
 family
Date: Wed, 17 May 2017 20:13:45 +0200
Message-ID: <20170517181345.GA23132@salvia>
References: <20170509155122.26356-1-fw@strlen.de>
 <20170509155122.26356-5-fw@strlen.de>
 <20170516102225.GA19858@salvia>
 <20170516105221.GD16290@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56584 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753465AbdEQSN5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 May 2017 14:13:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1DC15396276
        for <netfilter-devel@vger.kernel.org>; Wed, 17 May 2017 20:13:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F011A78A
        for <netfilter-devel@vger.kernel.org>; Wed, 17 May 2017 20:13:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD022FF2D8
        for <netfilter-devel@vger.kernel.org>; Wed, 17 May 2017 20:13:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170516105221.GD16290@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Tue, May 16, 2017 at 12:52:21PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, May 09, 2017 at 05:51:16PM +0200, Florian Westphal wrote:
> > > After previous commit nft generates meta l4proto for ipv6 dependencies
> > > instead of checking the (first) nexthdr value.
> > > 
> > > This fixes up all tests cases accordingly except one which fails with
> > > 
> > > ip6/reject.t: ... 12: 'ip6 nexthdr 6 reject with tcp reset' mismatches 'meta l4proto 6 reject with tcp reset'
> > > This will be fixed by removing the implicit dependency in a followup patch.
> > > 
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [..]
> > >  # icmpv6 type echo-request
> > >  bridge test-bridge input
> > > -  [ payload load 2b @ link header + 12 => reg 1 ]
> > > -  [ cmp eq reg 1 0x0000dd86 ]
> > > -  [ payload load 1b @ network header + 6 => reg 1 ]
> > > +  [ meta load l4proto => reg 1 ]
> > >    [ cmp eq reg 1 0x0000003a ]
> > >    [ payload load 1b @ transport header + 0 => reg 1 ]
> > >    [ cmp eq reg 1 0x00000080 ]
> > 
> > I think this is not correct.
> > 
> > Before this patch, we restricted this to match on IPv6 traffic.
> 
> Right.
> 
> > Now, we can match an IPv4 packet carrying an ICMPv6 protocol, this is
> > obviously handcrafted (incorrect) packet, but this rule would match.
> 
> Yes.  I am not sure what the correct or desired behaviour is.
> 
> Simply speaking we're asked to check if transport protocol is 58, and
> thats what this does.

Right. However, this forces users to add explicit ip6 nexthdr or meta
protocol to restrict this IPv6. My concern here is that this loose
matching, for something that from a protocol perspective is incorrect.

> If you prefer special-casing this I can look into it, probably
> best thing is to inject 'meta nfproto ip6' test.

For inet, yes. For bridge and netdev families the dependency would be
different.

I suspect this is working now with your patches to use meta for the
implicit dependencies. I would point to the patch that adds icmp and
icmpv6 as protocol to proto_inet_service as the one removing this
special casing.

> What would you expect in these cases (note, ip family):
> 
> a) add rule filter input meta l4proto icmpv6
> b) add rule filter input meta l4proto icmpv6 icmpv6 type echo-request
> c) add rule filter input icmpv6 type echo-request
>
> with master only a) is accepted.
> With patch #1 of the series, b) is also accepted.

b) and c) are equivalent. Since c) should generate both the meta
protocol and the meta l4proto dependency.

Then, we should allow this too:

        meta protocol ip meta l4proto icmpv6

so we can match IPv4 packets that container ICMPv6 packet. I know,
this is crazy, but we should users to match this. A handcrafted packet
may look like that.

I think this logic should be placed somewhere at payload_gen_dependency().

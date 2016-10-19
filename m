From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/2] netfilter: autoload NAT support for
 non-builtin L4 protocols
Date: Wed, 19 Oct 2016 17:56:41 +0200
Message-ID: <20161019155641.GA5118@salvia>
References: <cover.1475773632.git.dcaratti@redhat.com>
 <20161017175827.GA21172@salvia>
 <1476781962.2878.31.camel@redhat.com>
 <20161019122334.GA1656@salvia>
 <20161019125733.GA1528@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Davide Caratti <dcaratti@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50160 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755276AbcJSP4u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Oct 2016 11:56:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA5D79B7EF
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 17:56:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2954DA81A
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 17:56:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A781BAC44
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 17:56:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20161019125733.GA1528@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 19, 2016 at 02:57:33PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > > and maybe also nf_conntrack_proto_gre.o, built into
> > > nf_conntrack.ko? 
> > 
> > Please, keep gre back by now, I think this is quite specific of the
> > pptp conntrack helper that we have in the tree and it only works for
> > IPv4 and it cannot work with NAT either, it's very limited. So please
> > start by building in dccp, sctp and udplite protocols.
> 
> Wrt. udplite, I think it makes sense to merge it into udp one, I suspect
> a lot of this becomes redundant after some refactoring.

At quick glance, udplite is a copy and paste from udp trackers, except
for the udplite_error() function. So glad to see this merged into UDP.

> For sctp I am not so sure, it will add a dependency of conntrack
> on crc32, but maybe thats not so important...?

Actually, this would add a dependency for nf_nat, not for
nf_conntrack. The real crc32c implementation details are placed
behind the crypto infrastructure, I don't see any way we can skip
this.

We can still keep config NF_NAT_PROTO_SCTP around, just turn it into
boolean toggle, so people can still compile this out if such
dependency becomes a problem.

I would also remove 'default IP_SCTP' from CONFIG_NF_CT_PROTO_SCTP
since we don't need any local SCTP stack support to forward packets.

Just to summarize: What we're discuss here is a good default
configuration. After reading those RFCs that propose SCTP over UDP
tunneling tricks to workaround firewalls on the Internet, my
impression is that we may be probably responsible for this in some
way.

> Merging NAT makes sense, the external helper modules are very
> small (~120 lines inlcuding boilerplate...).

Correct, it's fairly small amount of code.

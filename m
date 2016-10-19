From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 0/2] netfilter: autoload NAT support for
 non-builtin L4 protocols
Date: Wed, 19 Oct 2016 14:57:33 +0200
Message-ID: <20161019125733.GA1528@breakpoint.cc>
References: <cover.1475773632.git.dcaratti@redhat.com>
 <20161017175827.GA21172@salvia>
 <1476781962.2878.31.camel@redhat.com>
 <20161019122334.GA1656@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Davide Caratti <dcaratti@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56212 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934682AbcJSORa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Oct 2016 10:17:30 -0400
Content-Disposition: inline
In-Reply-To: <20161019122334.GA1656@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Oct 18, 2016 at 11:12:42AM +0200, Davide Caratti wrote:
> [...]
> > > Once these protocols are supported built-in, users can configure from
> > > our control plane, ie. iptables/nft, if they explicitly don't want to
> > > allow them by dropping protocols of this kind. But in that case we
> > > would not be responsible anymore for the current situation at least.
> > > 
> > > Moreover, following this approach, we would also avoid the new
> > > attribute in nft_nat to indicate the layer 4 protocol that you have
> > > mentioned already.
> > 
> > Ok - so do you think it's better to have
> > nf_nat_proto_{dccp,sctp,udplite}.o built into nf_nat.ko and
> > nf_conntrack_proto_{dccp,sctp,udplite}.o,
> 
> Yes. We agreed on doing so during the Netfilter Workshop Amsterdam.

Hmm, did we?  I wonder what my opinion on that subject was :)

> > and maybe also nf_conntrack_proto_gre.o, built into
> > nf_conntrack.ko? 
> 
> Please, keep gre back by now, I think this is quite specific of the
> pptp conntrack helper that we have in the tree and it only works for
> IPv4 and it cannot work with NAT either, it's very limited. So please
> start by building in dccp, sctp and udplite protocols.

Wrt. udplite, I think it makes sense to merge it into udp one, I suspect
a lot of this becomes redundant after some refactoring.

For sctp I am not so sure, it will add a dependency of conntrack
on crc32, but maybe thats not so important...?

Merging NAT makes sense, the external helper modules are very
small (~120 lines inlcuding boilerplate...).

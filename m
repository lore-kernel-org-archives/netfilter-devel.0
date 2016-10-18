From: Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH nf-next 0/2] netfilter: autoload NAT support for
 non-builtin L4 protocols
Date: Tue, 18 Oct 2016 11:12:42 +0200
Message-ID: <1476781962.2878.31.camel@redhat.com>
References: <cover.1475773632.git.dcaratti@redhat.com>
         <20161017175827.GA21172@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752344AbcJRJMp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Oct 2016 05:12:45 -0400
In-Reply-To: <20161017175827.GA21172@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hello Pablo,

On Mon, 2016-10-17 at 19:58 +0200, Pablo Neira Ayuso wrote:
> I would really like to see DCCP, SCTP and UDPlite built-in, just like
> other protocol trackers (TCP, UDP...). This may require a bit of
> review work on your/our side, but it would greatly appreciated.

thank you for looking at this. At the moment, I'm testing a v2 of this
patch extending to REDIRECT targets _ which are exposing the same issue as
SNAT and DNAT, and using existing NFTA_RULE_COMPAT_PROTO attribute to
carry the transport protocol number in case a SNAT/DNAT/REDIRECT target is
specified in a nftables statement.

> Many vendors rely on default configurations, not even looking into
> modprobing things, so these protocols are hopeless in the current
> situation since routers running Netfilter will likely not supported
> them. This is worse since nf_conntrack drops packets for protocols
> like SCTP and DCCP since the generic protocol can no longer be used.

true, unless user modprobes nf_conntrack_proto_{dccp,udplite,sctp}, any
SNAT/DNAT/REDIRECT rule will not be hit by traffic.

> Once these protocols are supported built-in, users can configure from
> our control plane, ie. iptables/nft, if they explicitly don't want to
> allow them by dropping protocols of this kind. But in that case we
> would not be responsible anymore for the current situation at least.
> 
> Moreover, following this approach, we would also avoid the new
> attribute in nft_nat to indicate the layer 4 protocol that you have
> mentioned already.

Ok - so do you think it's better to have
nf_nat_proto_{dccp,sctp,udplite}.o built into nf_nat.ko and
nf_conntrack_proto_{dccp,sctp,udplite}.o, and maybe also
nf_conntrack_proto_gre.o, built into nf_conntrack.ko? 

thank you in advance,
regards
--
davide


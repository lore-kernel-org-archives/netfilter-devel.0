From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/2] netfilter: autoload NAT support for
 non-builtin L4 protocols
Date: Wed, 19 Oct 2016 14:23:34 +0200
Message-ID: <20161019122334.GA1656@salvia>
References: <cover.1475773632.git.dcaratti@redhat.com>
 <20161017175827.GA21172@salvia>
 <1476781962.2878.31.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46130 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943299AbcJSOud (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Oct 2016 10:50:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CCC0526E1D
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 14:24:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7653BAABF
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 14:24:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7656DDA7F7
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 14:23:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476781962.2878.31.camel@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 18, 2016 at 11:12:42AM +0200, Davide Caratti wrote:
[...]
> > Once these protocols are supported built-in, users can configure from
> > our control plane, ie. iptables/nft, if they explicitly don't want to
> > allow them by dropping protocols of this kind. But in that case we
> > would not be responsible anymore for the current situation at least.
> > 
> > Moreover, following this approach, we would also avoid the new
> > attribute in nft_nat to indicate the layer 4 protocol that you have
> > mentioned already.
> 
> Ok - so do you think it's better to have
> nf_nat_proto_{dccp,sctp,udplite}.o built into nf_nat.ko and
> nf_conntrack_proto_{dccp,sctp,udplite}.o,

Yes. We agreed on doing so during the Netfilter Workshop Amsterdam.

> and maybe also nf_conntrack_proto_gre.o, built into
> nf_conntrack.ko? 

Please, keep gre back by now, I think this is quite specific of the
pptp conntrack helper that we have in the tree and it only works for
IPv4 and it cannot work with NAT either, it's very limited. So please
start by building in dccp, sctp and udplite protocols.

Thanks.

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/2] netfilter: autoload NAT support for
 non-builtin L4 protocols
Date: Mon, 17 Oct 2016 19:58:28 +0200
Message-ID: <20161017175827.GA21172@salvia>
References: <cover.1475773632.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753370AbcJQR6n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 13:58:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3F4953EBA86
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 19:58:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A7B4BAAB0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 19:58:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E940EBAAA6
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 19:58:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <cover.1475773632.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 06, 2016 at 07:09:27PM +0200, Davide Caratti wrote:
> this series fixes SNAT/DNAT rules where port number translation is
> explicitly configured, but only the L3 address is translated:
> 
> # iptables -t nat -A POSTROUTING -o eth1 -p stcp -j SNAT --to-source 10.0.0.1:61000
> # tcpdump -s46 -tni eth1 sctp
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on eth1, link-type EN10MB (Ethernet), capture size 46 bytes
> IP 10.0.0.1.37788 > 10.0.0.2.2000: sctp
>             ^^^^^
> IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp
> IP 10.0.0.1.37788 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp
> IP 10.0.0.1.37788 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp
> 
> This happens for all protocols that don't have L4 NAT support built into
> nf_nat.ko, such as DCCP, SCTP and UDPLite: unless the user modprobes
> nf_nat_proto_{dccp,sctp,udplite}.ko, port translation as specified in the
> above rule will not be done. 
> The first patch provides persistent and generic aliases for the above
> modules; the second patch autoloads nf_nat_proto_{dccp,sctp,udplite} when a
> SNAT/DNAT rule matching one of the above protocols is created.

I would really like to see DCCP, SCTP and UDPlite built-in, just like
other protocol trackers (TCP, UDP...). This may require a bit of
review work on your/our side, but it would greatly appreciated.

We discussed this during the last Netfilter Workshop, the current
situation is not good, we're in some way responsible for breaking the
deployment of new protocols on the Internet.

Many vendors rely on default configurations, not even looking into
modprobing things, so these protocols are hopeless in the current
situation since routers running Netfilter will likely not supported
them. This is worse since nf_conntrack drops packets for protocols
like SCTP and DCCP since the generic protocol can no longer be used.

Once these protocols are supported built-in, users can configure from
our control plane, ie. iptables/nft, if they explicitly don't want to
allow them by dropping protocols of this kind. But in that case we
would not be responsible anymore for the current situation at least.

Moreover, following this approach, we would also avoid the new
attribute in nft_nat to indicate the layer 4 protocol that you have
mentioned already.

Thanks!

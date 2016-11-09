From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v3] netfilter: conntrack: simplify init/uninit of
 L4 protocol trackers
Date: Thu, 10 Nov 2016 00:07:50 +0100
Message-ID: <20161109230750.GA12156@salvia>
References: <9ca5c9c7f41ac474c9c51f581f51f10f315f7920.1478539442.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Florian Westphal <fw@strlen.de>
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54504 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752621AbcKIXH7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2016 18:07:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 38F3EA7CB5
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 00:07:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A884A7E9F
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 00:07:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 355D2A7E90
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 00:07:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <9ca5c9c7f41ac474c9c51f581f51f10f315f7920.1478539442.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 07, 2016 at 06:31:17PM +0100, Davide Caratti wrote:
> modify registration and deregistration of layer-4 protocol trackers to
> facilitate inclusion of new elements into the current list of builtin
> protocols. Both builtin (TCP, UDP, ICMP) and non-builtin (DCCP, GRE, SCTP,
> UDPlite) layer-4 protocol trackers usually register/deregister themselves
> using consecutive calls to nf_ct_l4proto_{,pernet}_{,un}register(...).
> This sequence is interrupted and rolled back in case of error; in order to
> simplify addition of builtin protocols, the input of the above functions
> has been modified to allow registering/unregistering multiple protocols.

Applied, thanks Davide.

From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 0/4] netfilter: built-in conntrack support for
 DCCP, SCTP, UDPlite
Date: Sun, 4 Dec 2016 20:43:16 +0100
Message-ID: <20161204194316.GA3493@salvia>
References: <cover.1479217169.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Florian Westphal <fw@strlen.de>, mikko.rapeli@iki.fi,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55896 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbcLDTn1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 14:43:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA7F610078B
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 20:43:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9573DA85F
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 20:43:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FB8EDA80B
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 20:43:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <cover.1479217169.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 15, 2016 at 03:08:23PM +0100, Davide Caratti wrote:
> When netfilter needs to match traffic made by one of the above protocols,
> layer-4 connection tracking functionality will not be available, unless the
> user explicly loads it in the kernel (e.g. "modprobe nf_conntrack_proto_sctp")
> or modifies the default kernel configuration and rebuilds.
> In order to remove such limitation, this series converts
> CONFIG_NF_CT_PROTO_{DCCP,SCTP,UDPLITE} from tristate to boolean: in case
> conntrack support for these protocols is enabled in the kernel configuration,
> it will be built into nf_conntrack.ko.
> 
> Patch 1/4 fixes nf_conntrack_tuple_common.h to avoid compile-time errors
> when moving module per-net private data.
> Patches 2/4  3,4 and 4/4 remove loadable kernel module support from DCCP,
> SCTP and UDPlite respectively.

Series applies, thanks Davide.

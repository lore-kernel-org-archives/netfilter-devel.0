From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 0/3] netfilter: built-in NAT support for DCCP,
 SCTP, UDPlite
Date: Sun, 4 Dec 2016 21:00:52 +0100
Message-ID: <20161204200052.GA13980@salvia>
References: <cover.1476980105.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58830 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbcLDUA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 15:00:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0D55CD1629
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:00:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1963A7E8F
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:00:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7B03A7E94
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:00:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <cover.1476980105.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 20, 2016 at 06:33:00PM +0200, Davide Caratti wrote:
> Version 2 changes:
> - use #ifdef ... in place of #if IS_ENABLED()
> - add footprint test results
> 
> The above L4 protocols usually need an explicit modprobe command (e.g
> "modprobe nf_nat_proto_sctp") to provide full functionality of REDIRECT
> targets and SNAT/DNAT targets where port number translation is explicitly
> configured.
> In order to remove such limitation, this series converts 
> CONFIG_NF_NAT_PROTO_{DCCP,SCTP,UDPLITE} from tristate to boolean: in case 
> NAT support for these protocols is enabled in the kernel configuration, it
> will be built into nf_nat.ko.

Series applied, thanks Davide.

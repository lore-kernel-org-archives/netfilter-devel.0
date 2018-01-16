From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter : add NAT support for shifted portmap ranges
Date: Tue, 16 Jan 2018 15:32:18 +0100
Message-ID: <20180116143218.xlgqmh7pmmaxfcco@salvia>
References: <7503dae4-e597-c3ca-1671-a24809be4ed0@dtsystems.be>
 <c4e20749-09c1-b78c-845a-13c94d5cd739@dtsystems.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Thierry Du Tre <thierry@dtsystems.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35044 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbeAPOcZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 09:32:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 45E5FC39F5
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 15:32:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 370FDDA84B
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 15:32:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <c4e20749-09c1-b78c-845a-13c94d5cd739@dtsystems.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Thierry,

On Mon, Jan 15, 2018 at 01:56:09PM +0100, Thierry Du Tre wrote:
> Hi Pablo,
> 
> I prepared this third version to get aligned about the way forward for the extension for struct nf_nat_range.
> 
> Renaming the old definition as you suggested indeed results in a much smaller patch for netfilter kernel part.
> However, doing it like this also means that userspace code will require changes to cope with the new value for sizeof(struct nf_nat_range).
> 
> i.e. iptables-1.6.1 :
> 
> ./extensions/libip6t_SNAT.c:306:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
> ./extensions/libip6t_DNAT.c:290:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
> ./extensions/libip6t_NETMAP.c:89:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
> ./extensions/libip6t_MASQUERADE.c:159:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
> ./extensions/libip6t_REDIRECT.c:158:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
> 
> As far as I understand, all these xt target modules will have to increment their revision which makes them incompatible with current kernel versions.
> The other option is to replace all occurences of nf_nat_range with nf_nat_range1 in these userspace libraries.
> That would solve iptables but possible other applications might also be impacted ?
> 
> Somehow this doesn't seem right to me, so I might have misinterpreted your earlier response.

I guess you need to add new revisions for the userspace code too,
right? Am I missing anything?

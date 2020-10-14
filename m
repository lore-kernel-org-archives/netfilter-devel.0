Return-Path: <SRS0=zc7w=DV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757DDC433E7
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 00:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 425DF2078A
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 00:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgJNAGd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Oct 2020 20:06:33 -0400
Received: from correo.us.es ([193.147.175.20]:36376 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbgJNAGc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 20:06:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E47ACE7813
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 02:06:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3E00DA791
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 02:06:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C8C69DA789; Wed, 14 Oct 2020 02:06:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA40CDA72F;
        Wed, 14 Oct 2020 02:06:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Oct 2020 02:06:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A091D42EFB80;
        Wed, 14 Oct 2020 02:06:28 +0200 (CEST)
Date:   Wed, 14 Oct 2020 02:06:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
Message-ID: <20201014000628.GA15290@salvia>
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
 <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu>
 <20201009110323.GC5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092035550.19307@blackhole.kfki.hu>
 <20201009185552.GF5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092132220.19307@blackhole.kfki.hu>
 <20201009200548.GG5723@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201009200548.GG5723@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 09, 2020 at 10:05:48PM +0200, Florian Westphal wrote:
> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > The "delay unregister" remark was wrt. the "all rules were deleted"
> > > case, i.e. add a "grace period" rather than acting right away when
> > > conntrack use count did hit 0.
> > 
> > Now I understand it, thanks really. The hooks are removed, so conntrack 
> > cannot "see" the packets and the entries become stale. 
> 
> Yes.
> 
> > What is the rationale behind "remove the conntrack hooks when there are no 
> > rule left referring to conntrack"? Performance optimization? But then the 
> > content of the whole conntrack table could be deleted too... ;-)
> 
> Yes, this isn't the case at the moment -- only hooks are removed,
> entries will eventually time out.
> 
> > > Conntrack entries are not removed, only the base hooks get unregistered. 
> > > This is a problem for tcp window tracking.
> > > 
> > > When re-register occurs, kernel is supposed to switch the existing 
> > > entries to "loose" mode so window tracking won't flag packets as 
> > > invalid, but apparently this isn't enough to handle keepalive case.
> > 
> > "loose" (nf_ct_tcp_loose) mode doesn't disable window tracking, it 
> > enables/disables picking up already established connections. 
> > 
> > nf_ct_tcp_be_liberal would disable TCP window checking (but not tracking) 
> > for non RST packets.
> 
> You are right, mixup on my part.
> 
> > But both seems to be modified only via the proc entries.
> 
> Yes, we iterate table on re-register and modify the existing entries.

For iptables-nft, it might be possible to avoid this deregister +
register ct hooks in the same transaction: Maybe add something like
nf_ct_netns_get_all() to bump refcounters by one _iff_ they are > 0
before starting the transaction processing, then call
nf_ct_netns_put_all() which decrements refcounters and unregister
hooks if they reach 0.

The only problem with this approach is that this pulls in the
conntrack module, to solve that, struct nf_ct_hook in
net/netfilter/core.c could be used to store the reference to
->netns_get_all and ->net_put_all.

Legacy would still be flawed though.

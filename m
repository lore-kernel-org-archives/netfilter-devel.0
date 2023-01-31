Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA17C636CC
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Jan 2023 11:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjAaLZU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Jan 2023 06:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjAaLZU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Jan 2023 06:25:20 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3799749573
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Jan 2023 03:25:18 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pMolH-0002dC-UA; Tue, 31 Jan 2023 12:25:15 +0100
Date:   Tue, 31 Jan 2023 12:25:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Wolfgang Nothdurft <wolfgang@linogate.de>
Subject: Re: [PATCH nf] netfilter: br_netfilter: disable sabotage_in hook
 after first suppression
Message-ID: <20230131112515.GC12902@breakpoint.cc>
References: <20230130103929.66551-1-fw@strlen.de>
 <Y9jwoxBMqfs5FoZf@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9jwoxBMqfs5FoZf@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jan 30, 2023 at 11:39:29AM +0100, Florian Westphal wrote:
> > When using a xfrm interface in a bridged setup (the outgoing device is
> > bridged), the incoming packets in the xfrm interface are only tracked
> > in the outgoing direction.
> > 
> > $ brctl show
> > bridge name     interfaces
> > br_eth1         eth1
> > 
> > $ conntrack -L
> > tcp 115 SYN_SENT src=192... dst=192... [UNREPLIED] ...
> > 
> > If br_netfilter is enabled, the first (encrypted) packet is received onR
> > eth1, conntrack hooks are called from br_netfilter emulation which
> > allocates nf_bridge info for this skb.
> > 
> > If the packet is for local machine, skb gets passed up the ip stack.
> > The skb passes through ip prerouting a second time. br_netfilter
> > ip_sabotage_in supresses the re-invocation of the hooks.
> > 
> > After this, skb gets decrypted in xfrm layer and appears in
> > network stack a second time (after decyption).
> > 
> > Then, ip_sabotage_in is called again and suppresses netfilter
> > hook invocation, even though the bridge layer never called them
> > for the plaintext incarnation of the packet.
> > 
> > Free the bridge info after the first suppression to avoid this.
> 
> I'll add this tag (just one sufficiently old):
> 
> Fixes: c4b0e771f906 ("netfilter: avoid using skb->nf_bridge directly")
> 
> unless you prefer anything else.

I was unable to figure out where the regression comes from,
as far as i can see br_netfilter always had this problem; i did not
expect that skb is looped again with different headers.

I'm fine with a pseudo-tag.

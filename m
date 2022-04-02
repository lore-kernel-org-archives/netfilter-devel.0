Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9688C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Apr 2022 11:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiDBLOC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Apr 2022 07:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240442AbiDBLOA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Apr 2022 07:14:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA921544A5
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Apr 2022 04:11:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nabfh-0004al-87; Sat, 02 Apr 2022 13:11:57 +0200
Date:   Sat, 2 Apr 2022 13:11:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vasily Averin <vvs@openvz.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, kernel@openvz.org
Subject: Re: troubles caused by conntrack overlimit in init_netns
Message-ID: <20220402111157.GD28321@breakpoint.cc>
References: <de70cc55-6c11-d772-8b08-e8994fd934a0@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de70cc55-6c11-d772-8b08-e8994fd934a0@openvz.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Vasily Averin <vvs@openvz.org> wrote:
> There is an old issue with conntrack limit on multi-netns (read container) nodes.
> 
> Any connection to containers hosted on the node creates a conntrack in init_netns.
> If the number of conntrack in init_netns reaches the limit, the whole node becomes
> unavailable.

Right, from inet_net p.o.v. connections coming from container netns is
no different from different physical host on pyhsical network.

> To avoid it OpenVz had special patches disabled conntracks on init_ns on openvz nodes, 
> but this automatically limits the functionality of host's firewall.
> 
> This has been our specific pain for many years, however, containers are now 
> being used much more widely than before, and the severity of the described problem
> is growing more and more.
> 
> Do you know perhaps some alternative solution?

If you need conntrack in init_net, then no.

If you don't (or only for connections that won't be rerouted to
container netns) you could -j NOTRACK traffic coming from/going to
container.

But, why do you need conntrack in the container netns?
Normally I'd expect that if packet was already handled in init_net,
why re-run skb through conntrack again?


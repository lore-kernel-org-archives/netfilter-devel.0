Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41F9C77B7A
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 May 2023 10:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjESKyI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 May 2023 06:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjESKyH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2023 06:54:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A3110DF;
        Fri, 19 May 2023 03:54:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pzxk4-0001lt-Fx; Fri, 19 May 2023 12:53:48 +0200
Date:   Fri, 19 May 2023 12:53:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Jeremy Sowden <jeremy@azazel.net>
Subject: Re: [PATCH net-next 3/9] netfilter: nft_exthdr: add boolean DCCP
 option matching
Message-ID: <20230519105348.GA24477@breakpoint.cc>
References: <20230518100759.84858-1-fw@strlen.de>
 <20230518100759.84858-4-fw@strlen.de>
 <20230518140450.07248e4c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518140450.07248e4c@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 18 May 2023 12:07:53 +0200 Florian Westphal wrote:
> > From: Jeremy Sowden <jeremy@azazel.net>
> > 
> > The xt_dccp iptables module supports the matching of DCCP packets based
> > on the presence or absence of DCCP options.  Extend nft_exthdr to add
> > this functionality to nftables.
> 
> Someone is actually using DCCP ? :o

Don't know but its still seeing *some* activity.
When I asked the same question I was pointed at

https://multipath-dccp.org/

respectively the out-of-tree implementation at
https://github.com/telekom/mp-dccp/

There is also some ietf activity for dccp, e.g.
BBR-like CC:
https://www.ietf.org/archive/id/draft-romo-iccrg-ccid5-00.html

Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E60C77B7A
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 May 2023 15:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjESP0T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 May 2023 11:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbjESP0S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2023 11:26:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E639C1B5;
        Fri, 19 May 2023 08:26:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1q01zP-0003WV-Qw; Fri, 19 May 2023 17:25:55 +0200
Date:   Fri, 19 May 2023 17:25:55 +0200
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
Message-ID: <20230519152555.GB24477@breakpoint.cc>
References: <20230518100759.84858-1-fw@strlen.de>
 <20230518100759.84858-4-fw@strlen.de>
 <20230518140450.07248e4c@kernel.org>
 <20230519105348.GA24477@breakpoint.cc>
 <20230519082143.3d20db49@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519082143.3d20db49@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> Oh, Deutsche Telekom, ISDN and now DCCP?
> I wonder if we could make one of them a maintainer, because DCCP
> is an Orphan.. but then the GH tree has such gold as:
> net/dccp/non_gpl_scheduler/ 

Could just mark it CONFIG_BROKEN or rip it out
altogether.  It can be brought back if anyone cares.

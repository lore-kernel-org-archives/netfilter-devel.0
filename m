Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE58C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 13:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238655AbiKWNIY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 08:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238665AbiKWNHl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 08:07:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A4578187
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 04:50:34 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oxpCy-00011b-Ky; Wed, 23 Nov 2022 13:50:32 +0100
Date:   Wed, 23 Nov 2022 13:50:32 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables-nft RFC 1/5] nft-shared: dump errors on stdout to
 garble output
Message-ID: <20221123125032.GA2753@breakpoint.cc>
References: <20221121111932.18222-1-fw@strlen.de>
 <20221121111932.18222-2-fw@strlen.de>
 <Y30NJTaQx8Wn7RLE@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y30NJTaQx8Wn7RLE@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> What I don't like about this is that users won't notice the problem
> until they try to restore the ruleset. For us it is clearly beneficial
> to see where things break, but I doubt regular users care and we should
> just tell them to stop mixing iptables and nft calls.

So what would you propose...?

> Can we maybe add "--force" to iptables-nft-save to make it print as much
> as possible despite the table being considered incompatible? Not sure
> how ugly this is to implement, though.

I don't see this as useful thing because we already have "nft --debug=netlink".

> We still exit(0) in case parsing fails, BTW. Guess this is the most
> important thing to fix despite all the above.

Huh?
iptables-restore < bla
iptables-restore v1.8.8 (nf_tables): unknown option "--bla"
Error occurred at line: 7 Try `iptables-restore -h' or 'iptables-restore --help' for more information.

... exits with 2.

Can you give an example?

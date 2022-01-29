Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA43DC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Jan 2022 20:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbiA2U2N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Jan 2022 15:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353078AbiA2U2N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jan 2022 15:28:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4FBC061714
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jan 2022 12:28:13 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nDuKR-0004JB-Dn; Sat, 29 Jan 2022 21:28:11 +0100
Date:   Sat, 29 Jan 2022 21:28:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 2/2] netfilter: conntrack: re-init state for
 retransmitted syn-ack
Message-ID: <20220129202811.GL25922@breakpoint.cc>
References: <20220129164701.175221-1-fw@strlen.de>
 <20220129164701.175221-2-fw@strlen.de>
 <8388b8bd-3c41-a8ec-c338-28be9491fa74@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8388b8bd-3c41-a8ec-c338-28be9491fa74@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> I can only assume that the client is/are behind like a carrier-grade NAT
> and the bogus SYN-ACK sent by the server is replying a connection attempt 
> from another client. Yes, the best thing to do is to reinit the state.

Yes, thats my guess as well, some sort of CGN or stateless nat hding
multiple clients.

Thanks for the quick review!
